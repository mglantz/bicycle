#!/bin/bash
# Magnus Glantz, sudo@redhat.com, 2018
# Access to server

# SSH key prereqs, creation of users for demo
# Create directory for ssh public key
if [ ! -d /root/.ssh ]; then
  mkdir /root/.ssh
  chmod 600 /root/.ssh
fi

# Create ssh key
cat << 'EOF' >/root/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCR/+C0do9cM9edqeG8y81HQHmPAiviI3s2HDhLPMfSZ9iqxwS/2Cpt1TDfVVh+Qoo3mVgSe6Y7jlX6TNeG2aFQfCG33/3l3OZaACheAzJZ+vsL+OnIMT8sdzkqkYPeE5yeuutsDzdPj9a6nr/HIn6/BV2GFHCqxP7NswW7v1q8n56ucMto+GU2Ih0pIkEOIbjdQ83npRtukeTtPBIBVQJY7XI6bnbf7m6dJ5sAKe94EnOCqR3h7p19+mrmDNXi7vnWBFIu6ctfsUXEHDewGny6b3A/UKk5x1EGsIPuZkbdXBKDF9nw39171jldawiEN3XLQbG2mcrZ6l/cVlV8be0D
EOF
chmod 600 /root/.ssh/authorized_keys
