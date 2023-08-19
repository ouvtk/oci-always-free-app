# Infrastructure for Oracle Cloud Always Free resources
Managed by terraform

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

What about alerting, logging and monitoring?

Due to Always Free limitations:
 - Instances has to stay in the public subnet, otherwise they should be Private subnet with NAT gateway.

Add what this infrastructure intentionally avoids:
 - users and user policies
 - correct tagging of resources
 - terraform state management (assumption is that resource manager is used)
 - how to securely deploy application into the instance
```