# Application on Oracle Cloud Always Free resources

Attempt to provide a simple way to deploy an infrastructure with a running application within Oracle Cloud Infrastructure (OCI) using only Always Free resources.
And the infrastucture is managed by terraform through OCI Resource Manager, no other backend considered.

This is not production ready, for small non-sensitive projects only, or for proof-of-concepts.

## What can I do?

Due to Always Free limitations:
 - Instances has to stay in a public subnet to reach out to the internet. Otherwise they should be in the private subnet with a NAT gateway.

This configuration will create and manage:
 - Networking (virtual cloud network, subnets, internet gateway)
 - Compute (instances, load balancing)
 - Access (routing, network security groups)
 - [Not yet] Database? Parameter store? Certificates?
 - [Not yet] Alerting? Logging? Monitoring?

The configuration will intentially avoid:
 - Users and user policies 
   (relies a lot on specific needs)
 - Correct tagging of resources 
   (no cost management for Always Free resources, no tag-based authorisation)
 - Terraform state management 
   (assumption is to use Resource Manager, without other backends configured)
 - How to securily deploy the application on the instances 
   (relies a lot on the artifact source)
 - Resources autoscaling (instance autoscaling is possible with the Always Free tier, 
   but makes little sense to do it in the generic way withotu tuning it for a specific application)

## Reuse compartment or VCN

This repo will create a new VCN in the new compartment, but it is easy to make it work for existing VCN - ping me (or create an issue) if you need help to make it configurable. It will require changes in `identity.tf` and `network.tf`, but probably that's it.