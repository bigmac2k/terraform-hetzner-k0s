module "mastergroup" {
  source = "./servergroup"
  count_ = 3
  name = "${var.clustername}-master"
  network_id = hcloud_network.net.id
  subnet_id = hcloud_network_subnet.subnet.id
  clustername = var.clustername
  extralabels = {"master-${var.clustername}" = "", name = var.clustername}
  ssh_keys = [hcloud_ssh_key.ssh_root.name]
  location = var.location
  server_type = "cx11"
  placement_group_id = hcloud_placement_group.placementgroup.id
  netbase = "10.0.0"
  ipbase = 50
}
