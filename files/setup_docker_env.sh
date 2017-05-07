#!/usr/bin/env bash
echo "Setup Docker Environment"
relver=`hostnamectl | grep CPE | cut -d":" -f 6`

tee /etc/modules-load.d/overlay.conf <<-EOF
overlay
EOF

tee /etc/yum.repos.d/docker.repo <<-EOF
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/$relver
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF

mkdir -p /etc/systemd/system/docker.service.d && tee /etc/systemd/system/docker.service.d/override.conf <<-EOF
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd --storage-driver=overlay
EOF

yum install -y docker-engine-1.13.1 docker-engine-selinux-1.13.1 && \
  systemctl start docker && \
  systemctl enable docker