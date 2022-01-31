module "k0sctl" {
  source = "github.com/bigmac2k/terraform-k0sctl"
  clustername = "k0s"
  controller_addrs = [for addr in tolist(module.mastergroup.ips.*.ipv4_address): {
    addr = addr
    private_interface = "ens10"
  }]
  worker_addrs = [for addr in tolist(module.workergroup.ips.*.ipv4_address): {
    addr = addr
    private_interface = "ens10"
  }]
  k0s_version = var.k0s_version
  kubeapiIp = hcloud_load_balancer_network.lb-internal-net.ip
  kubeapiIpPublicOverride = hcloud_load_balancer.external.ipv4
  extra_sans = [hcloud_load_balancer.external.ipv4]
}
