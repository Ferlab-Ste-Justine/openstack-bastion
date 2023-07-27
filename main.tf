locals {
  block_devices = var.image_source.volume_id != "" ? [{
    uuid                  = var.image_source.volume_id
    source_type           = "volume"
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = false
  }] : []
}

data "template_cloudinit_config" "bastion_config" {
  gzip = true
  base64_encode = true
  part {
    content_type = "text/cloud-config"
    content = templatefile(
      "${path.module}/templates/cloud_config.yaml", 
      {
        public_key  = var.internal_public_key,
        private_key = var.internal_private_key
        ssh_user    = var.ssh_user
      }
    )
  }
}

resource "openstack_compute_instance_v2" "bastion" {
  name            = var.name
  image_id        = var.image_source.image_id != "" ? var.image_source.image_id : null

  flavor_id       = var.flavor_id
  key_pair        = var.external_keypair_name
  user_data = data.template_cloudinit_config.bastion_config.rendered

  network {
    port = var.network_port.id
  }

  dynamic "block_device" {
    for_each = local.block_devices
    content {
      uuid                  = block_device.value["uuid"]
      source_type           = block_device.value["source_type"]
      boot_index            = block_device.value["boot_index"]
      destination_type      = block_device.value["destination_type"]
      delete_on_termination = block_device.value["delete_on_termination"]
    }
  }
}