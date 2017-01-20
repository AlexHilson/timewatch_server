data "template_file" "node_bootstrap" {
  template = "${file("${path.module}/files/bootstrap.tpl")}"
}