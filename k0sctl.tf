module "k0sctl" {
  source = "./k0sctl"
  clustername = "k0s"
  controller_addrs = module.mastergroup.ips.*.ipv4_address
  worker_addrs = module.workergroup.ips.*.ipv4_address
  k0s_version = var.k0s_version
  externalAddress = hcloud_load_balancer_network.lb-internal-net.ip
  publicAddress = hcloud_load_balancer.external.ipv4
}
