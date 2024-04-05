#!/usr/bin/env bash
repo_workdir=/tmp/ansible-setup

# wait for reliable internet connection
failed=1
while [ $failed -ne 0 ]
do
  ping -c 1 8.8.8.8 > /dev/null 2>&1
  failed=$?
  echo "Waiting for Internet connection being ready..."
  sleep 1
done

# Install required OS dependencies
yum -y install ansible telnet
