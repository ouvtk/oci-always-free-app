data "oci_objectstorage_namespace" "app" {
  compartment_id = data.oci_identity_compartment.app.id
}

resource "oci_objectstorage_bucket" "deploy" {
  compartment_id = data.oci_identity_compartment.app.id
  namespace      = data.oci_objectstorage_namespace.app.namespace

  access_type = "NoPublicAccess"
  name        = "${var.project_name}-deploy"

  // TODO: kms_key_id?
}

// Assumes that application is pre-built at this point. TODO autobuild?
resource "oci_objectstorage_object" "app" {
  bucket    = oci_objectstorage_bucket.deploy.name
  namespace = oci_objectstorage_bucket.deploy.namespace

  object = "app/${local.executable_name}"
  source = "${path.module}/app/_build/${local.executable_name}"
}

resource "oci_objectstorage_preauthrequest" "app_deploy" {
  depends_on = [oci_objectstorage_object.app]

  bucket    = oci_objectstorage_bucket.deploy.name
  namespace = oci_objectstorage_bucket.deploy.namespace

  name        = "${var.project_name}-app-deploy-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  access_type = "ObjectRead"
  object_name = oci_objectstorage_object.app.object

  // How to deploy the real application is a task outside of this excersise - find your own way.
  // Not a bullet proof solution, and if set to 88000 hours, will be stopping working after 10-ish years.
  // If it worked that way without revisiting for that long, it is nice to pay it at least a courtesy visit.
  time_expires = timeadd(timestamp(), "88000h")
}
