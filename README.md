# About

This package is a terraform module to provision a bastion on Openstack

The provisioned bastion is meant to customizable (within the confines of use cases encountered so far) and the module is conservative about the dependant resources it provisions, externalizing many of those concerns in order to provide greater flexibility.

The bastion provision some packages as part of its cloud-init logic: ansible, netaddr, jq

# Usage

## Variables

The module takes the following variables as input:

- namespace: A string to append to the bastion name (ie, `bastion-<namespace>`) for namespacing. Can be omitted in which case the name will just be **bastion**.
- image_id: ID of the image to provision the bastion on.
- flavor_id: ID of the image to provision the bastion on.
- external_keypair_name: Name of the keypair that will be used to ssh to the bastion from outside the network
- internal_private_key: Value of the private part of the key the bastion will use to ssh on machines in the network
- internal_public_key: Value of the public part of the key the bastion will use to ssh on machines in the network
- internal_network_name: Name of the network the bastion will be connected to in order to enable sshing on machines in that network
- security_groups: List of security group names to assign to the bastion. Defaults to `["default]`
- ssh_user: User that will be used to ssh on the bastion from the outside. Defaults to **ubuntu**

## Output

The module outputs the following variables as output:
- id: Id of the provisioned bastion
- internal_ip: Ip of the bastion on the network

## Example

Here is an example of how the bastion module might be used:

```
module "reference_infra" {
  source = "./cqdg-reference-infra"
}

#Security groups we create for the various modules
module "security_groups" {
  source = "./security-groups"
}

#Default image we assign to all vms
module "ubuntu_bionic_image" {
  source = "./image"
  name = "Ubuntu-Bionic-2020-06-10"
  url = "https://cloud-images.ubuntu.com/releases/bionic/release-20200610.1/ubuntu-18.04-server-cloudimg-amd64.img"
}

#Ssh key that will be used to open an ssh session on the bastion
resource "openstack_compute_keypair_v2" "bastion_external_keypair" {
  name = "bastion_external_keypair"
}

#Ssh key that will be used to open an ssh session from the bastion to other machines
resource "openstack_compute_keypair_v2" "bastion_internal_keypair" {
  name = "bastion_internal_keypair"
}

#Bastion
resource "openstack_networking_floatingip_v2" "bastion_floating_ip" {
  pool = module.reference_infra.networks.external.name
}

module "bastion" {
  source = "git::https://github.com/Ferlab-Ste-Justine/openstack-bastion.git"
  image_id = module.ubuntu_bionic_image.id
  flavor_id = module.reference_infra.flavors.micro.id
  external_keypair_name = openstack_compute_keypair_v2.bastion_external_keypair.name
  internal_private_key = openstack_compute_keypair_v2.bastion_internal_keypair.private_key
  internal_public_key = openstack_compute_keypair_v2.bastion_internal_keypair.public_key
  internal_network_name = module.reference_infra.networks.internal.name
  security_groups = [
    module.reference_infra.security_groups.default.name,
    module.security_groups.groups.bastion.name,
  ]
  ssh_user = "ubuntu"
}

resource "openstack_compute_floatingip_associate_v2" "bastion_ip" {
  floating_ip = openstack_networking_floatingip_v2.bastion_floating_ip.address
  instance_id = module.bastion.id
}
```