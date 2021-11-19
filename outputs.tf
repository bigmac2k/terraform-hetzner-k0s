output "master_ips" {
  value = module.mastergroup.ips
}
output "worker_ips" {
  value = module.workergroup.ips
}
#output "k0sctl_yaml" {
#  value = module.k0sctl.k0sctl_yaml
#}
output "kubeconfig" {
  sensitive = true
  value = module.k0sctl.kubeconfig
}
output "public_lb" {
  value = hcloud_load_balancer.external.ipv4
}
