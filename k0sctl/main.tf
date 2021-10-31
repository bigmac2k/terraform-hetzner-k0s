resource "local_file" "k0sctl_yaml" {
  content = local.k0sctl_yaml
  filename = "${path.module}/k0sctl.yaml"
}
data "external" "k0sctl_apply" {
  program = ["${path.module}/run_k0sctl.sh"]
  query = {
    module_path = path.module
  }
  depends_on = [local_file.k0sctl_yaml]
}
