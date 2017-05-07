resource "digitalocean_tag" "do_tag" {
    name    =   "${var.do_tag}"
}

resource "digitalocean_ssh_key" "default" {
    name            =   "SSH Key for Terraform"
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
    
    provisioner "remote-exec" {
        inline = [
            "yum install -y epel-release",
            "yum update -y"
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
    
    provisioner "remote-exec" {
        inline = [
            "yum install -y epel-release",
            "yum update -y"
        ]
    }
}

