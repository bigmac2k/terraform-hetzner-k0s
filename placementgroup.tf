resource "hcloud_placement_group" "placementgroup" {
  name = "${var.clustername}"
  type = "spread"
  labels = {
    name = "${var.clustername}"
  }
}
