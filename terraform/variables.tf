variable digital_ocean_key {
    description     =   "Digital Ocean API key"
}

variable region {
    description     =   "Datacenter to Launch in"
    default         =   "nyc1"
}

variable image {
    description     =   "Distro Type"
    default         =   "centos-7-x64"
}

variable do_tag {
    description     =   "Server tag for deployed hosts"
    default         =   "mesos_cluster"
}

variable droplet_size {
    description     =   "Droplet Size"
    default         =   "512mb"
}

variable bootstrap_node {
    description     =   "Number of Mesos Master Nodes"
    default         =   1
}

variable master_node {
    description     =   "Number of Mesos Master Nodes"
    default         =   3
}

variable worker_node {
    description     = "Number of  Mesos Worker Nodes"
    default         = 2
}