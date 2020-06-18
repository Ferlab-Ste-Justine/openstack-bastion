variable "namespace" {
  description = "Namespace to isolate all resources created in the module"
  type = string
  default = ""
}

variable "image_id" {
  description = "ID of the image the bastion will run on"
  type = string
}

variable "flavor_id" {
  description = "ID of the flavor the bastion will run on"
  type = string
}

variable "external_keypair_name" {
  description = "Name of the external keypair that will be used to ssh to the bastion"
  type = string
}

variable "internal_private_key" {
  description = "Value of the private part of the ssh keypair that the bastion will use to ssh on instances"
  type = string
}

variable "internal_public_key" {
  description = "Value of the public part of the ssh keypair that the bastion will use to ssh on instances"
  type = string
}

variable "internal_network_name" {
  description = "Name of the internal network the bastion will sit in front of"
  type = string
}

variable "security_groups" {
  description = "Security groups of the bastion"
  type = list(string)
  default = ["default"]
}