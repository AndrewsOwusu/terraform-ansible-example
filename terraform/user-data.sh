#!/bin/bash
#
# Install Ansible and use `ansible-pull` to run the playbook for this instance.

# Some sane options.
set -e # Exit on first error.
set -x # Print expanded commands to stdout.

function main {
  # Set our named arguments.
  declare -r url=$1 playbook=$2

  # Ensure the instance is up-to-date.
  sudo apt-get update -y

  # Install required packages.
  sudo apt-get install -y git

  # Install Ansible! We use pip as the EPEL package runs on Python 2.6...
  sudo apt-get install ansible -y

  # Download our Ansible repository and run the given playbook. Pip installs
  # executables into a directory not in the root users $PATH.
  /usr/local/bin/ansible-pull --accept-host-key --verbose \
    --url "$url" --directory /var/local/src/instance-bootstrap "$playbook"
}

# 🚀
main \
  'https://github.com/AndrewsOwusu/terraform-ansible-example.git' \
  'ansible/local.yml'

