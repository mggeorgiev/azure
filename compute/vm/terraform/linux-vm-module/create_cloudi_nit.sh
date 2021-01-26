#!/bin/bash

cat <<EOF > cloud-init.txt
#cloud-config
package_upgrade: true
packages:
- stress
runcmd:
- sudo stress --cpu 1
EOF