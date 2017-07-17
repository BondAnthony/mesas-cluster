# DCOS Cluster

Quick deployment of a full DCOS cluster on Digital Ocean using Terraform and Ansible.

### Requirements

* You need to create a default ssh key under `./ssh` called mesos.pem
* Terraform needs to be installed on the same system you will be running this project from. [terraform.io](http://www.terraform.io)
* Ansible also needs to be installed on the same system. [Ansible](http://www.ansible.com)
* Create a DigitalOcean API key, [docs](https://www.digitalocean.com/help/api/).

*You can run this project from your local machine or a VPS*

## Terraform to Deploy

*DCOS requires a lot of resources so this will deploy 16GB VPS*

Use Terraform to build a cluster of servers on Digital Ocean.
1. Change directory to the terraform directory
2. Run `terraform plan` and inspect the output of what will be created.
3. Run `terraform apply` to create the Digital Ocean droplets.

## Ansible to Config

1. Generate the Ansible inventory file for your deployed cluster `terraform output ansible_inventory > ../ansible/inventory`
2. Switch to the Ansible directory and run the Ansible playbook `dcos_system_requirements.yml` to configure docker and a number of other dependencies. Since the deployment of DCOS uses the GUI installer we will not be configuring docker on the master and agent nodes.

## Bootstrap Node

Terraform will create a bootstrap node to run the DC/OS install gui from.

1. Login to the bootstrap node via ssh `ssh root@bootstrapIP -i ../terraform/ssh/mesos.pem`.
2. Start the DCOS GUI installer `/tmp/dcos_generate_config.sh --web`, add a `-v` for verbose output.
3. Open a web browser and navigate to your bootstrap node port `9000`. 

### Additional Details

* DC/OS GUI Installer `curl -O https://downloads.dcos.io/dcos/stable/dcos_generate_config.sh`
* [DC/OS GUI Docs](https://dcos.io/docs/1.9/installing/custom/gui/)
* Must have a Digital Ocean account and API key with read/write permissions

