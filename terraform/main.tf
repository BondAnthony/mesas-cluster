resource "digitalocean_tag" "do_tag" {
    name    =   "${var.do_tag}"
}

resource "digitalocean_ssh_key" "default" {
    name            =   "Terraform1"
    public_key      =   "${file("${path.module}/ssh/mesos.pem.pub")}"
}

resource "digitalocean_droplet" "master_node" {
    count               =   "${var.master_node}"
    image               =   "${var.image}"
    name                =   "${format("master%1d", count.index + 1)}"
    region              =   "${var.region}"
    size                =   "${var.droplet_size}"
    ssh_keys            =   ["${digitalocean_ssh_key.default.id}"]
    tags                =   ["${digitalocean_tag.do_tag.id}"]
    private_networking  =   true

    connection {
        type            =   "ssh"
        private_key     =   "${file("${path.module}/ssh/mesos.pem")}"
        user            =   "root"
        timeout         =   "2m"
    }
}

resource "digitalocean_droplet" "worker_node" {
  count              = "${var.worker_node}"
  image              = "${var.image}"
  name               = "${format("worker%1d", count.index + 1)}"
  region             = "${var.region}"
  size               = "${var.droplet_size}"
  ssh_keys           = ["${digitalocean_ssh_key.default.id}"]
  tags               = ["${digitalocean_tag.do_tag.id}"]
  private_networking = true

      connection {
        type            =   "ssh"
        private_key     =   "${file("${path.module}/ssh/mesos.pem")}"
        user            =   "root"
        timeout         =   "2m"
    }
}

resource "digitalocean_droplet" "bootstrap_node" {
    count               =   "${var.bootstrap_node}"
    image               =   "${var.image}"
    name                =   "${format("Bootstrap%1d", count.index + 1)}"
    region              =   "${var.region}"
    size                =   "${var.droplet_size}"
    ssh_keys            =   ["${digitalocean_ssh_key.default.id}"]
    tags                =   ["${digitalocean_tag.do_tag.id}"]
    private_networking  =   true

    connection {
        type            =   "ssh"
        private_key     =   "${file("${path.module}/ssh/mesos.pem")}"
        user            =   "root"
        timeout         =   "2m"
    }
    
    provisioner "file" {
        source          = "ssh/mesos.pem"
        destination     = "/root/.ssh/mesos.pem" 
    }
}

data "template_file" "ansible_inventory" {
  template = "${file("${path.module}/files/ansible_inventory.tpl")}"
 vars {
        dcos_worker_name = "${join("\n",digitalocean_droplet.worker_node.*.name)}",
        dcos_worker_public = "${join("\n",digitalocean_droplet.worker_node.*.ipv4_address)}",
        dcos_worker_private = "${join("\n",digitalocean_droplet.worker_node.*.ipv4_address_private)}",
        dcos_master_name = "${join("\n",digitalocean_droplet.master_node.*.name)}",
        dcos_master_public = "${join("\n",digitalocean_droplet.master_node.*.ipv4_address)}",
        dcos_master_private = "${join("\n",digitalocean_droplet.master_node.*.ipv4_address_private)}",
        dcos_boot_name = "${digitalocean_droplet.bootstrap_node.name}",
        dcos_boot_public = "${digitalocean_droplet.bootstrap_node.ipv4_address}"
        dcos_ssh_key = "ansible_ssh_private_key_file=../terraform/ssh/mesos.pem"
    }
}

output "ansible_inventory" {
    value = "${data.template_file.ansible_inventory.rendered}"
}