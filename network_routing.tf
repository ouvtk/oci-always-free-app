
# Route tables
resource "oci_core_route_table" "app_load_balancer" {
  compartment_id = data.oci_identity_compartment.app.id
  vcn_id         = data.oci_core_vcn.app.id

  display_name = "${var.project_name}-lb"
  route_rules {
    description       = "Route all egress towards the internet gateway"
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.internet_gw.id
  }
}

resource "oci_core_route_table" "app_compute" {
  compartment_id = data.oci_identity_compartment.app.id
  vcn_id         = data.oci_core_vcn.app.id

  display_name = "${var.project_name}-compute"
  route_rules {
    description       = "Route all egress towards the internet gateway"
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.internet_gw.id
  }
}

# Security groups
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
