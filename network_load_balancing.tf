resource "oci_load_balancer_load_balancer" "public" {
  compartment_id = data.oci_identity_compartment.app.id
  display_name   = "${var.project_name}-public-lb"
  is_private     = false
  shape          = "flexible"
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
  health_checker {
    protocol = "HTTP"
    port     = 80
    url_path = "/health"
  }
}

resource "oci_load_balancer_listener" "app" {
  load_balancer_id = oci_load_balancer_load_balancer.public.id

  default_backend_set_name = oci_load_balancer_backend_set.app.name
  name                     = var.project_name
  port                     = 80
  protocol                 = "HTTP"
}
