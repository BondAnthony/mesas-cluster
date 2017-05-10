resource "digitalocean_tag" "do_tag" {
    name    =   "${var.do_tag}"
}

resource "digitalocean_ssh_key" "default" {
    name            =   "Terraform"
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
    
    provisioner "file" {
        source          = "files/setup_docker_env.sh"
        destination     = "/tmp/setup_docker_env.sh" 
    }

    provisioner "remote-exec" {
        inline = [
            "echo overlay > /etc/modules-load.d/overlay.conf",
            "reboot"
        ]
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
    provisioner "file" {
        source          = "files/setup_docker_env.sh"
        destination     = "/tmp/setup_docker_env.sh" 
    }

    provisioner "remote-exec" {
        inline = [
            "echo overlay > /etc/modules-load.d/overlay.conf",
            "reboot"
        ]
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
        destination     = "~/.ssh/mesos.pem" 
    }
}