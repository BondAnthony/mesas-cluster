variable digital_ocean_key {
    description     =   "Digital Ocean API key"
}

variable region {
    description     =   "Datacenter to Launch in"
    default         =   "nyc2"
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
    default         =   "1gb"
}

variable bootstrap_node {
    description     =   "Number of Mesos Master Nodes"
    default         =   1
}

variable master_node {
    description     =   "Number of Mesos Master Nodes"
    default         =   1
}

variable worker_node {
    description     = "Number of  Mesos Worker Nodes"
    default         = 1
}