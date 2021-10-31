resource "hcloud_load_balancer" "internal" {
  name               = "${var.clustername}-internal"
  load_balancer_type = "lb11"
  location           = var.location
  algorithm {
    type = "round_robin"
  }
  labels = {
    name = "${var.clustername}"
  }
}
resource "hcloud_load_balancer_network" "lb-internal-net" {
  load_balancer_id = hcloud_load_balancer.internal.id
  network_id       = hcloud_network.net.id
  ip               = "10.0.0.2"
  enable_public_interface = false
  depends_on = [hcloud_network_subnet.subnet]
}
resource "hcloud_load_balancer_service" "lb-internal-k8sapi" {
  load_balancer_id = hcloud_load_balancer.internal.id
  protocol         = "tcp"
  listen_port = 6443
  destination_port = 6443
  health_check {
    protocol = "tcp"
    port = 6443
    interval = 3
    timeout = 3
    retries = 2
  }
}
resource "hcloud_load_balancer_service" "lb-internal-konnectivity" {
  load_balancer_id = hcloud_load_balancer.internal.id
  protocol         = "tcp"
  listen_port = 8132
  destination_port = 8132
  health_check {
    protocol = "tcp"
    port = 8132
    interval = 3
    timeout = 3
    retries = 2
  }
}
resource "hcloud_load_balancer_service" "lb-internal-joinapi" {
  load_balancer_id = hcloud_load_balancer.internal.id
  protocol         = "tcp"
  listen_port = 9443
  destination_port = 9443
  health_check {
    protocol = "tcp"
    port = 9443
    interval = 3
    timeout = 3
    retries = 2
  }
}
resource "hcloud_load_balancer_target" "lb-internal-master" {
  type             = "label_selector"
  load_balancer_id = hcloud_load_balancer.internal.id
  label_selector = "master-${var.clustername}"
  use_private_ip = true
  depends_on = [hcloud_load_balancer_network.lb-internal-net]
}

resource "hcloud_load_balancer" "external" {
  name               = "${var.clustername}-external"
  load_balancer_type = "lb11"
  location           = var.location
  algorithm {
    type = "round_robin"
  }
  labels = {
    name = "${var.clustername}"
  }
}
resource "hcloud_load_balancer_network" "lb-external-net" {
  load_balancer_id = hcloud_load_balancer.external.id
  network_id       = hcloud_network.net.id
  ip               = "10.0.0.3"
  enable_public_interface = true
  depends_on = [hcloud_network_subnet.subnet]
}
resource "hcloud_load_balancer_service" "lb-external-k8sapi" {
  load_balancer_id = hcloud_load_balancer.external.id
  protocol         = "tcp"
  listen_port = 6443
  destination_port = 6443
  health_check {
    protocol = "tcp"
    port = 6443
    interval = 3
    timeout = 3
    retries = 2
  }
}
resource "hcloud_load_balancer_target" "lb-external-master" {
  type             = "label_selector"
  load_balancer_id = hcloud_load_balancer.external.id
  label_selector = "master-${var.clustername}"
  use_private_ip = true
  depends_on = [hcloud_load_balancer_network.lb-external-net]
}
