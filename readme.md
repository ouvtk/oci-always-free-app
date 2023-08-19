# Application on Oracle Cloud Always Free resources

Attempt to provide a simple way to deploy an infrastructure with a running application within Oracle Cloud Infrastructure (OCI) using only Always Free resources.
And the infrastucture is managed by terraform through OCI Resource Manager, no other backend considered.

This is not production ready, for small non-sensitive projects only, or for proof-of-concepts.

```
Add note about creation of the new compartment or reusing existing one with the VCN.

Add what this infrastructure aims to manage (group by networking, compute etc):
 - compartment
 - VCN
 - subnets
 - internet gateway
 - load balancer
 - database
 - network security groups

Database?
Parameter storage?
Certificates?

What about alerting, logging and monitoring?

Due to Always Free limitations:
 - Instances has to stay in the public subnet, otherwise they should be Private subnet with NAT gateway.

Add what this infrastructure intentionally avoids:
 - users and user policies
 - correct tagging of resources
 - terraform state management (assumption is that resource manager is used)
 - how to securely deploy application into the instance
```