data "oci_core_images" "ubuntu" {
  compartment_id           = var.compartment_ocid
  operating_system         = var.image_operating_system
  operating_system_version = var.image_operating_system_version
  shape                    = var.instance_shape

  sort_by    = "TIMECREATED"
  sort_order = "DESC"
}

resource "oci_core_instance" "app" {
  compartment_id      = var.compartment_ocid
  availability_domain = var.availability_domain
  display_name        = "${var.name_prefix}-app"
  shape               = var.instance_shape

  shape_config {
    ocpus         = var.instance_ocpus
    memory_in_gbs = var.instance_memory_gb
  }

  create_vnic_details {
    subnet_id        = var.subnet_id
    assign_public_ip = true
    display_name     = "${var.name_prefix}-app-vnic"
    hostname_label   = "app"
  }

  source_details {
    source_type             = "image"
    source_id               = data.oci_core_images.ubuntu.images[0].id
    boot_volume_size_in_gbs = var.boot_volume_size_gb
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data           = base64encode(file("${path.root}/cloud-init.yaml"))
  }

  freeform_tags = var.common_tags
}
