data "template_cloudinit_config" "bastion_config" {
  gzip = true
  base64_encode = true
  part {
    content_type = "text/cloud-config"
    content = templatefile(
      "${path.module}/cloud_config.yaml", 
      {
        public_key = var.internal_public_key, 
        private_key = var.internal_private_key 
      }
    )
  }
}

resource "openstack_compute_instance_v2" "bastion" {
  name            = var.namespace == "" ? "bastion" : "bastion_${var.namespace}"
  image_id        = var.image_id
  flavor_id       = var.flavor_id
  key_pair        = var.external_keypair_name
  security_groups = var.security_groups
  user_data = data.template_cloudinit_config.bastion_config.rendered

  network {
    name = var.internal_network_name
  }
}