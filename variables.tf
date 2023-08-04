variable "name" {
  description = "Name of the vm"
  type        = string
  default     = ""
}

variable "image_source" {
  description = "Source of the vm's image"
  type = object({
    image_id  = string
    volume_id = string
  })
}

variable "flavor_id" {
  description = "ID of the flavor the bastion will run on"
  type        = string
}

variable "network_port" {
  description = "Network port to assign to the node. Should be of type openstack_networking_port_v2"
  type        = any
}

variable "external_keypair_name" {
  description = "Name of the external keypair that will be used to ssh to the bastion"
  type        = string
}

variable "internal_private_key" {
  description = "Value of the private part of the ssh keypair that the bastion will use to ssh on instances"
  type        = string
}

variable "internal_public_key" {
  description = "Value of the public part of the ssh keypair that the bastion will use to ssh on instances"
  type        = string
}

variable "internal_network_name" {
  description = "Name of the internal network the bastion will sit in front of"
  type        = string
}

variable "ssh_user" {
  description = "User that will be used to ssh into the bastion"
  type        = string
  default     = "ubuntu"
}