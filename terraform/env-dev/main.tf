module "nginx" {
  source = "../modules/nginx"
  proxy_pass = "http://127.0.0.1:3000"
  ssl_dn = "/CN=timewatch"
}

module "node_bootstrap" {
  source = "../modules/node_bootstrap"
}

module "timewatch_server" {
  source = "../modules/timewatch_server"
}

resource "aws_security_group" "timewatch_server" {
  name = "${var.service_name}"
}

resource "aws_security_group_rule" "allow_all_outgoing" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = [
    "0.0.0.0/0"]

  security_group_id = "${aws_security_group.timewatch_server.id}"
}

resource "aws_security_group_rule" "allow_incoming" {
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = [
    "${var.allowed_ips_cidr}"]

  security_group_id = "${aws_security_group.timewatch_server.id}"
}

resource "aws_launch_configuration" "timewatch" {
  image_id = "ami-6f587e1c"
  instance_type = "m4.large"
  key_name = "gateway"
  iam_instance_profile = "${aws_iam_instance_profile.timewatch.name}"
  user_data = "${format("%s\n%s\n%s",
                        module.nginx.rendered,
                        module.node_bootstrap.rendered,
                        module.timewatch_server.rendered)}"
  security_groups = [
    "default",
    "${aws_security_group.timewatch_server.name}"
  ]
}
  
resource "aws_iam_role" "timewatch" {
  name               = "timewatch"
  assume_role_policy = "${file("assume-role-policy.json")}"
}

resource "aws_iam_policy" "timewatch_s3" {
  name        = "timewatch_s3"
  description = "Allow timewatch to access s3"
  policy      = "${file("policy-s3-bucket.json")}"
}

resource "aws_iam_policy_attachment" "timewatch" {
  name       = "timewatch"
  roles     = ["${aws_iam_role.timewatch.name}"]
  policy_arn = "${aws_iam_policy.timewatch_s3.arn}"
}

resource "aws_iam_instance_profile" "timewatch" {
  name  = "timewatch"
  role = "${aws_iam_role.timewatch.name}"
}

resource "aws_autoscaling_group" "timewatch" {
  name                  = "${var.service_name}"
  availability_zones    = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  max_size              = 1
  min_size              = 1
  desired_capacity      = 1
  health_check_grace_period = 300
  health_check_type     = "EC2"
  force_delete          = true
  launch_configuration  = "${aws_launch_configuration.timewatch.name}"

  tag {
    key                 = "Name"
    value               = "${var.service_name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "environment"
    value               = "prod"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_schedule" "stop-timewatch" {
  scheduled_action_name = "stop-timewatch"
  min_size = 0
  max_size = 0
  desired_capacity = 0
  recurrence = "30 20 * * 1-5"
  autoscaling_group_name = "${aws_autoscaling_group.timewatch.name}"
}

resource "aws_autoscaling_schedule" "start-timewatch" {
  scheduled_action_name = "start-timewatch"
  min_size = 1 
  max_size = 1
  desired_capacity = 1
  recurrence = "30 18 * * 1-5"
  autoscaling_group_name = "${aws_autoscaling_group.timewatch.name}"
}

