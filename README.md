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

| Parameter | Description |
| :--: | :--: |
| account_id  | AWS account id (use this for logging on ELB)  |