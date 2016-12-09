# ec2cluster-terraform-ansible
This is a framework bootstrapping a cluster of ec2 instances
via terraform and provisioning it using Ansible

The module is under [/terraform](./terraform)
This provides following features and these are configurable via module parameters.

- Bootstrapping a number of ec2 instances
- ELB load balancing among ec2 instances
- Mounting volumes to each instances and setup RAID
- CloudWatch logs configuration
- Alarm configuration
- Name resolution using Route53
- Ansible provisioning in bootstrapping phase 
- Testing with [ansible_spec](https://github.com/volanja/ansible_spec) (Option)



Following parameters are available to determine the spec of the cluster.

## Authentication

| Parameter | Description |
| :--: | :--: |
| account_id  | your account id |
| keypair_name | a name for keypair to create |
| public_key  | the path to the public key to create keypair |
| private_key | the path to the private key of the keypair |


## Placement

| Parameter | Description |
| :--: | :--: |
| region | the region in which created ec2 instances run on |

**NOTE** AvailabilityZones are automatically selected as all zones within the specified region


## Behaviors on destruction

| Parameter | Description |
| :--: | :--: |
| shutdown_behavior | shutdown behavior of ec2 instances. Also applied when `terraform destroy` is called (`stop` or `terminate`) |
| volume_force_detach | whether detatching volumes from ec2 instances when the instance is removed |
| bucket_force_destroy | whether deleting S3 bucket to put ELB logs  when `terraform destroy` is called |
| termination_disable | disable instance termination |


## HostName and domain

| Parameter | Description |
| :--: | :--: |
| host_prefix | prefix of hostname |
| server_role | the role of instances |
| domain | domain name |

Host names become `${host_prefix}-${server_role}${count.index}.domain`  
For example, given `host_prefix = mizuno`, `server_role = web`, `domain = saint.com`, and `instance_count` = 2  
FQDN becomes `mizuno-web001.saint.com`, `mizuno-web002.saint.com` respectively.

**NOTE**
`server_role` also plays an important role in Ansible context.
This module will create inventory assuming all hosts are in the same group.
For example, given `server_role = web` inventory file will look like as follows,

```
[web]
public_ip_of_instance1
public_ip_of_instance2
```

## Spec of each host
| Parameter | Description |
| :--: | :--: |
| ami | The name of Amazon Machine Image |
| instance_type | the type of instances (e.g. t2.micro) |

## Cluster size
| Parameter | Description |
| :--: | :--: |
| instance_count | How many instances  |

