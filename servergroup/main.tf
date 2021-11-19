resource "hcloud_server" "server" {
  count = var.count_
  name        = "${var.name}${count.index}"
  ssh_keys = var.ssh_keys
  location = var.location
  image       = "ubuntu-20.04"
  server_type = var.server_type
  network {
    network_id = var.network_id
    ip = "${var.netbase}.${var.ipbase + count.index}"
  }
  placement_group_id = var.placement_group_id
  depends_on = [var.subnet_id]
  labels = merge({"fw-${var.clustername}" = ""}, var.extralabels)
}
