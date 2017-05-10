# mesos-cluster

Quick deployment of a full Mesosphere cluster to Digital Ocean.

You need to create a default ssh key under ./ssh called mesos.pem.

## Terraform to Deploy

Use Terraform to build a cluster of servers on Digital Ocean.
1. Change directory to the terraform directory
2. Run `terraform plan` and inspect the output of what will be created.
3. Run `terraform apply` to create the Digital Ocean droplets.

## Ansible to Config

1. Gather list of public and private ip addresses from terraform.tfstate and create an Ansible inventory file.
2. Run the Ansible playbook `dcos_system_requirements.yml` to configure docker and shut off firewalld on each host.

## Bootstrap Node

Terraform will create a bootstrap node to run the DC/OS install gui from.

More infomation so come...

### Additional Details

* DC/OS GUI Installer `curl -O https://downloads.dcos.io/dcos/stable/dcos_generate_config.sh`
* [DC/OS GUI Docs](https://dcos.io/docs/1.9/installing/custom/gui/)
* Must have a Digital Ocean account and API key with read/write permissions

