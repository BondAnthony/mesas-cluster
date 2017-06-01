[dcos_pub]
${dcos_master_public}
${dcos_worker_public}

[dcos_master_private]
${dcos_master_private}

[dcos_worker_private]
${dcos_worker_private}

[boot_host]
${dcos_boot_public}

[dcos_cluster:children]
dcos_pub
boot_host

[dcos_cluster:vars]
${dcos_ssh_key}