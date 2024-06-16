#!/bin/bash
sudo apt update --force-yes
sudo apt install python3 python3-pip curl git ssh sshpass -y
sudo pip3 install ansible-core
# crear el directorio .ssh o las llaves private/public en caso de no tenerlas
mkdir -p ~/.ssh ; if [[ ! -f ~/.ssh/id_rsa && ! -f ~/.ssh/id_rsa.pub ]]; then ssh-keygen -t rsa -b 2048 -N "" -f ~/.ssh/id_rsa; cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys ; fi
# validar si tienes declarado el ^LAN en /etc/environment sino añadirlo.
if ! grep -Ei "^(LAN|LC_ALL).*" /etc/environment; then
    sudo sed -ie "1i LAN=en_US.utf-8" /etc/environment
    sudo sed -ie "2i LC_ALL=en_US.utf-8" /etc/environment
    sudo update-locale
fi
# configurar ansible.cfg para el usuario $(whoami)
remote_user="$(whoami)"
if [ ! -d ~/data ]; then mkdir ~/data ; fi 
cat > ~/data/ansible.cfg<<EOF
[defaults]
host_key_checking = false
remote_user = ${remote_user}
private_key_file = /home/${remote_user}/.ssh/id_rsa
roles_path = /home/${remote_user}/git.personal/programs/ansible/
inventory = inventory
callbacks_enabled = timer, profile_tasks, profile_roles
pipelining = True
timeout=30
host_key_algorithms=ssh-rsa,ssh-ed25519,ecdsa-sha2-nistp256,ecdsa-sha2-nistp384,ecdsa-sha2-nistp521
#%%%%%%%%%%%%%%%%%%%% LOGS %%%%%%%%%%%%%%%%%%%%%%
log_path = /tmp/ansible_log_from_config.log
#stdout_callback=default
#display_skipped_hosts=no        ## To skip logging when task is skipped
#display_ok_hosts=no

[privilege_escalation]
become = true
EOF
export ANSIBLE_CONFIG="~/data/ansible.cfg"
# AL finalizar de ejecutar el paso a paso o el script install_prerequisites.sh instalar los modulos de ansible-galaxy
ansible-galaxy collection install community.general
ansible-galaxy collection install community.vmware
ansible-galaxy collection install ansible.posix
ansible-galaxy collection install ansible.windows
if ! grep -o "alias vim" /etc/profile &>/dev/null; then echo 'alias vim="/snap/bin/nvim"'|sudo tee -a /etc/profile; fi
