output "ips" {
  value = [for server in hcloud_server.server.* : {
    ipv4_address = server.ipv4_address
    ipv6_address = server.ipv6_address
    private_address = tolist(server.network)[0].ip
  }]
}
