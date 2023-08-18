// Always free only allows up to 2 virtual cloud networks.
// You may want to use an existing one instead.
resource "oci_core_vcn" "app" {
  compartment_id = data.oci_identity_compartment.app.id

  cidr_blocks = ["10.0.0.0/16"]
}

data "oci_core_vcn" "app" {
  vcn_id = oci_core_vcn.app.id
}

resource "oci_core_internet_gateway" "internet_gw" {
  compartment_id = data.oci_identity_compartment.app.id
  vcn_id         = data.oci_core_vcn.app.id

  display_name = var.project_name
}

// TODO: What to do with subnets if existing VCN is used?
resource "oci_core_subnet" "app_load_balancer" {
  compartment_id = data.oci_identity_compartment.app.id
  vcn_id         = data.oci_core_vcn.app.id

  cidr_block     = "10.0.1.0/24"
  display_name   = "${var.project_name}-lb"
  route_table_id = oci_core_route_table.app_load_balancer.id
}

// Instances subnet is meant to be private, but Always Free tier doesn't allow any NAT, only Internet Gateways.
resource "oci_core_subnet" "app_compute" {
  compartment_id = data.oci_identity_compartment.app.id
  vcn_id         = data.oci_core_vcn.app.id

  cidr_block     = "10.0.2.0/24"
  display_name   = "${var.project_name}-compute"
  route_table_id = oci_core_route_table.app_compute.id
}

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
