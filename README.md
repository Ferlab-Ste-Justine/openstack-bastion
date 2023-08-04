# About

This package is a terraform module to provision a bastion on Openstack

The provisioned bastion is meant to customizable (within the confines of use cases encountered so far) and the module is conservative about the dependant resources it provisions, externalizing many of those concerns in order to provide greater flexibility.

The bastion provision docker as part of its cloud-init logic.

# Usage

## Variables

The module takes the following variables as input:

- **name**: Name to give to the vm
- **image_source**: Source of the image to provision the bastion on. It takes the following keys (only one of the two fields should be used, the other one should be empty):
  - **image_id**: Id of the image to associate with a vm that has local storage
  - **volume_id**: Id of a volume containing the os to associate with the vm
- **flavor_id**: ID of the image to provision the bastion on.
- **network_port**: Resource of type **openstack_networking_port_v2** to assign to the vm for network connectivity
- **external_keypair_name**: Name of the keypair that will be used to ssh to the bastion from outside the network
- **internal_private_key**: Value of the private part of the key the bastion will use to ssh on machines in the network
- **internal_public_key**: Value of the public part of the key the bastion will use to ssh on machines in the network
- **internal_network_name**: Name of the network the bastion will be connected to in order to enable sshing on machines in that network
- security_groups: List of security group names to assign to the bastion. Defaults to `["default]`
- **ssh_user**: User that will be used to ssh on the bastion from the outside. Defaults to **ubuntu**