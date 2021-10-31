resource "hcloud_firewall" "firewall" {
  name = "${var.clustername}"
  apply_to {
    label_selector = "fw-${var.clustername}"
  }
  rule {
    direction = "in"
    protocol  = "icmp"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "22"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
  labels = {
    name = "${var.clustername}"
  }
}
