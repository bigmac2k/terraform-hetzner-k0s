output "k0sctl_yaml" {
  value = local.k0sctl_yaml
}
output "kubeconfig" {
  value = data.external.k0sctl_apply.result.kubeconfig
}
output "kubeconfig_base64" {
  value = data.external.k0sctl_apply.result.kubeconfig_base64
}
