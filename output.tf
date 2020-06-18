output id {
    value = openstack_compute_instance_v2.bastion.id
}

output internal_ip {
    value = openstack_compute_instance_v2.bastion.network.0.fixed_ip_v4
}