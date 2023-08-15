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
  shape      = "Flexible"
  shape_details {
    maximum_bandwidth_in_mbps = 10
    minimum_bandwidth_in_mbps = 10
  }
  subnet_ids = [oci_core_subnet.app_load_balancer.id]
}

resource "oci_load_balancer_backend_set" "app" {
  // TODO: Health checker
  load_balancer_id = oci_load_balancer_load_balancer.public.id

  name   = "${var.project_name}-compute"
  policy = "IP_HASH"

  health_checker {
    protocol = "HTTP"
    port     = 80
  }
}
