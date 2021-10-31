variable "clustername" {
  type = string
  default = "k0s"
}
variable "controller_addrs" {
  type = list(string)
}
variable "worker_addrs" {
  type = list(string)
}
variable "k0s_version" {
  type = string
  default = "1.22.2+k0s.2"
}
variable "externalAddress" {
  type = string
}
variable "publicAddress" {
  type = string
}
