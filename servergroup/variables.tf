variable "count_" {
  type = number
}
variable "name" {
  type = string
}
variable "location" {
  type = string
}
variable "server_type" {
  type = string
}
variable "network_id" {
  type = string
}
variable "subnet_id" {
  type = string
}
variable "clustername" {
  type = string
}
variable "extralabels" {
  type = map
  default = {}
}
variable "user_daa" {
  type = string
  default = ""
}
variable "ssh_keys" {
  type = list(string)
}
variable "placement_group_id" {
  type = string
}
