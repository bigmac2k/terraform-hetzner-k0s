locals {
  k0sctl_yaml = templatefile("${path.module}/k0sctl.yaml.tmpl", {
    clustername = var.clustername
    controller_addrs = var.controller_addrs
    worker_addrs = var.worker_addrs
    version = var.k0s_version
    externalAddress = var.externalAddress
    publicAddress = var.publicAddress
  })
}
