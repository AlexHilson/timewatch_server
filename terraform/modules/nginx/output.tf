output "rendered" {
  value = "${data.template_file.nginx_bootstrap.rendered}"
}