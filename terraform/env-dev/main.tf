module "nginx" {
  source = "../modules/nginx"
  proxy_pass = "http://127.0.0.1:3000"
  ssl_dn = "/CN=timewatch"
}

module "node_bootstrap" {
  source = "../modules/node_bootstrap"
}

resource "aws_instance" "timewatch_server" {
  ami = "ami-6f587e1c"
  instance_type = "t2.micro"

  key_name = "gateway"
  user_data = "${format("%s\n%s", module.nginx.rendered, module.node_bootstrap.rendered)}"

  security_groups = ["default", "${aws_security_group.timewatch_server.name}"]

  tags {
    Name = "${var.service_name}"
  }

}

resource "aws_security_group" "timewatch_server" {
  name = "${var.service_name}"
}

resource "aws_security_group_rule" "allow_all_outgoing" {
  type = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.timewatch_server.id}"
}

resource "aws_security_group_rule" "allow_incoming" {
  type = "ingress"
  from_port = 0
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["${var.allowed_ips_cidr}"]

  security_group_id = "${aws_security_group.timewatch_server.id}"
}
