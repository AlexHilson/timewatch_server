data "template_file" "timewatch_bootstrap" {
  template = "${file("${path.module}/files/bootstrap.tpl")}"
}