resource "hcloud_network" "net" {
  name     = "${var.clustername}"
  ip_range = "10.0.0.0/16"
  labels = {
    name = "${var.clustername}"
  }
}
resource "hcloud_network_subnet" "subnet" {
  network_id   = hcloud_network.net.id
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = "10.0.0.0/24"
}
