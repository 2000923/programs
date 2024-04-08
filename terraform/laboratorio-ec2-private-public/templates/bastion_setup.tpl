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
yum -y install ansible-core telnet squid firewalld net-tools vim
sed -rie "/(^#|^$)/d" /etc/squid/squid.conf
systemctl start squid
systemctl enable squid
systemctl start firewalld
firewall-cmd --permanent --add-port="3128/tcp" --zone="public"
firewall-cmd --reload
sudo -u rocky bash << EOF
ansible-galaxy collection install ansible.posix
ansible-galaxy collection install community.general
EOF
