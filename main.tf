// Do not do:
// - Tagging
// - Permissions (assumption is that there is a single admin that applies this project)
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

data "oci_identity_compartment" "parent" {
  id = var.parent_compartment_id
}

resource "oci_identity_compartment" "app" {
  compartment_id = data.oci_identity_compartment.parent.id

  name        = var.new_compartment_name
  description = "The compartment to contain all infrastructure for the always free application."

  enable_delete = true
}

// Used to decouple from the resource creation in case existing compartment will be reused.
data "oci_identity_compartment" "app" {
  id = oci_identity_compartment.app.id
}

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

  cidr_block   = "10.0.1.0/24"
  display_name = "${var.project_name}-lb"
}

// Instances subnet is meant to be private, but Always Free tier doesn't allow any NAT, only Internet Gateways.
resource "oci_core_subnet" "app_compute" {
  compartment_id = data.oci_identity_compartment.app.id
  vcn_id         = data.oci_core_vcn.app.id

  cidr_block   = "10.0.2.0/24"
  display_name = "${var.project_name}-compute"
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

resource "oci_load_balancer_load_balancer" "public" {
  compartment_id = data.oci_identity_compartment.app.id
  display_name   = "${var.project_name}-public-lb"

  // TODO:
  // network_security_group_ids = []

  is_private = false
  shape      = "Flexible"
  shape_details {
    maximum_bandwidth_in_mbps = 10
    minimum_bandwidth_in_mbps = 10
  }
  subnet_ids = [oci_core_subnet.app_load_balancer.id]
}
