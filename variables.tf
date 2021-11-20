#variable "ssh_key_name" {
#  type        = string
#  description = "ssh key name"
#}
variable "clustername" {
  type        = string
  description = "k0s cluster name"
  default     = "k0s"
}
#variable "user_data" {
#  type        = string
#  default     = ""
#  description = "user_data for machines"
#}
variable "k0s_version" {
  type        = string
  default     = "v1.22.4+k0s.0"
  description = "Version of k0s to install"
}
variable "location" {
  type        = string
  default     = "nbg1"
  description = "hetzner location"
}
variable "mastergroups" {
  type = list(object({
    count = number
    server_type = string
  }))
  default = [
    {
      count = 3
      name = "k0s-master"
      server_type = "cx11-ceph"
      labels = []
    }
  ]
}
