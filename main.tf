// Do not do:
// - Tagging
// - User's Permissions (assumption is that there is a single admin that applies this project)
//
// TODO: 
// Fetch:
// - Tenancy
//
// Create:
// - compartment
// - VCN
// - subnets
// - internet gateway
// - load balancer
// - database
// - network security groups
// 
// Deploy simple app serving HTTP REST API to get and create a resource a PoC.
//
// Alerting, logging and monitoring.
// Terraform state management by OCI.

resource "oci_load_balancer_load_balancer" "public" {
  compartment_id = data.oci_identity_compartment.app.id
  display_name   = "${var.project_name}-public-lb"

  // TODO:
  // network_security_group_ids = []

  is_private = false
  shape      = "flexible"
  shape_details {
    maximum_bandwidth_in_mbps = 10
    minimum_bandwidth_in_mbps = 10
  }
  subnet_ids                 = [oci_core_subnet.app_load_balancer.id]
  network_security_group_ids = [oci_core_network_security_group.public_lb.id]
}

resource "oci_load_balancer_backend_set" "app" {
  load_balancer_id = oci_load_balancer_load_balancer.public.id

  name   = "${var.project_name}-compute"
  policy = "IP_HASH"

  // TODO: Enable access and error logging?
  // TODO: Make sure health checker works.
  health_checker {
    protocol = "HTTP"
    port     = 80
    url_path = "/"
  }
}

resource "oci_load_balancer_listener" "app" {
  load_balancer_id = oci_load_balancer_load_balancer.public.id

  default_backend_set_name = oci_load_balancer_backend_set.app.name
  name                     = var.project_name
  port                     = 80
  protocol                 = "HTTP"

}

resource "oci_core_network_security_group" "public_lb" {
  compartment_id = data.oci_identity_compartment.app.id
  vcn_id         = oci_core_vcn.app.id

  display_name = "${var.project_name}-lb"
}

resource "oci_core_network_security_group_security_rule" "public_lb_internet_ingress" {
  network_security_group_id = oci_core_network_security_group.public_lb.id

  description = "Allow ingress from anywhere from the internet."
  direction   = "INGRESS"
  protocol    = "6" # 6 is HTTP based of IANA protocol numbers.
  source      = "0.0.0.0/0"
  source_type = "CIDR_BLOCK"
  stateless   = false

  tcp_options {
    destination_port_range {
      max = 80
      min = 80
    }
  }
}

resource "oci_core_network_security_group_security_rule" "public_lb_to_compute" {
  network_security_group_id = oci_core_network_security_group.public_lb.id

  direction        = "EGRESS"
  protocol         = "6"
  destination      = oci_core_network_security_group.compute.id
  destination_type = "NETWORK_SECURITY_GROUP"
  stateless        = false

  tcp_options {
    destination_port_range {
      max = 80
      min = 80
    }
  }
}

resource "oci_core_network_security_group" "compute" {
  compartment_id = data.oci_identity_compartment.app.id
  vcn_id         = oci_core_vcn.app.id

  display_name = "${var.project_name}-compute"
}


resource "oci_core_network_security_group_security_rule" "compute_from_public_lb" {
  network_security_group_id = oci_core_network_security_group.compute.id

  direction   = "INGRESS"
  protocol    = "6"
  stateless   = false
  source      = oci_core_network_security_group.public_lb.id
  source_type = "NETWORK_SECURITY_GROUP"

  tcp_options {
    destination_port_range {
      max = 80
      min = 80
    }
  }
}

// TODO: Add database access to compute NSG.
