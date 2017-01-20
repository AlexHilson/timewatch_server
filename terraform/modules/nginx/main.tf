data "template_file" "nginx_config" {
  template = "${file("${path.module}/files/nginx.tpl")}"

  vars = {
    proxy_pass = "${var.proxy_pass}"
  }
}

data "template_file" "nginx_bootstrap" {
  template = "${file("${path.module}/files/bootstrap.tpl")}"

  vars = {
    ssl_dn = "${var.ssl_dn}"
    nginx_config = "${data.template_file.nginx_config.rendered}"
  }
}