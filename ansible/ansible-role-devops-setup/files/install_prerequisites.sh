#!/bin/bash
#
# packages and install
USER=$(whoami)
SSH_HOME="/home/${USER}/.ssh"
sudo apt update --force-yes -y
sudo apt install python3 python3-pip curl git ssh sshpass -y
sleep 1m
sudo pip3 install ansible-core
band=false
if [[ ! -d ${SSH_HOME} ]]; then
  mkdir ~/.ssh && chmod 755 ~/.ssh
fi
if [[ ! -f "/home/${USER}/.ssh/id_rsa" ]]; then
  ssh-keygen -t rsa -b 2048 -N "" -f ~/.ssh/id_rsa
fi
cat ${SSH_HOME}/id_rsa.pub >> ~/.ssh/authorized_keys

if ! grep "^LAN=en_US.utf-8" /etc/environment; then
  sudo sed -ie "1i LAN=en_US.utf-8" /etc/environment
  band=true
fi

if ! grep "^LC_ALL=en_US.utf-8" /etc/environment; then
  sudo sed -ie "2i LC_ALL=en_US.utf-8" /etc/environment
  band=true
fi

if [[ band == true ]]; then 
  sudo update-locale
  sudo shutdown -r now
fi

# ansible-galaxy collection install community.general
# ansible-galaxy collection install ansible.posix

