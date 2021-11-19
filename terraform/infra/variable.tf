variable "name" {
  description = "A general name to be added to the resources"
  type        = string

  default = "josa-demo"
}

variable "az_location" {
  description = "The azure location on which resources are deployed"
  type        = string

  default = "westeurope"
}

variable "vnet_address_space" {
  description = "The CIDR block for the vnet address"
  type        = string

  default = "10.0.0.0/16"
}

variable "subnets" {
  description = "A list of subnets"
  type        = list(object({ name : string, cidr : string }))

  default = [{
    name = "snet1"
    cidr = "10.0.0.0/19"
  }]
}

variable "public_dns_zone_name" {
  description = "The public dns zone name"
  type        = string

  default = "kubechamp.gq"
}

variable "k8s_default_node_count" {
  description = "The default number of workers"
  type        = number

  default = 5
}

variable "tags" {
  description = "A map of tags"
  type        = map(string)

  default = {}
}