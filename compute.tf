locals {
  instance_shape = "VM.Standard.A1.Flex"
}

data "oci_core_images" "oracle_linux_8" {
  compartment_id           = data.oci_identity_compartment.app.id
  operating_system         = "Oracle Linux"
  operating_system_version = "8"
  shape                    = local.instance_shape
}

data "oci_core_image" "latest_oracle_linux_8" {
  image_id = try(data.oci_core_images.oracle_linux_8.images[0].id)
}

data "cloudinit_config" "app_compute" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "cloud-config.yaml"
    content_type = "text/cloud-config"
    content      = templatefile("${path.module}/scripts/cloud-init.yaml", {})
  }
}

resource "oci_core_instance_configuration" "app" {
  compartment_id = data.oci_identity_compartment.app.id
  display_name   = var.project_name

  instance_details {
    instance_type = "compute"

    launch_details {
      compartment_id = data.oci_identity_compartment.app.id

      create_vnic_details {
        assign_public_ip = true
        nsg_ids          = [oci_core_network_security_group.compute.id]
      }

      display_name = var.project_name

      metadata = {
        user_data = data.cloudinit_config.app_compute.rendered
      }

      shape = local.instance_shape
      shape_config {
        ocpus         = 1
        memory_in_gbs = 6
      }

      source_details {
        source_type = "image"
        image_id    = data.oci_core_image.latest_oracle_linux_8.image_id
      }
    }

  }
}

resource "oci_core_instance_pool" "app" {
  compartment_id = data.oci_identity_compartment.app.id

  display_name              = var.project_name
  instance_configuration_id = oci_core_instance_configuration.app.id
  size                      = var.number_of_instances
  placement_configurations {
    availability_domain = data.oci_identity_availability_domain.main.name
    primary_subnet_id   = oci_core_subnet.app_compute.id
  }
  load_balancers {
    backend_set_name = oci_load_balancer_backend_set.app.name
    load_balancer_id = oci_load_balancer_load_balancer.public.id
    port             = 80
    vnic_selection   = "PrimaryVnic"
  }
}
