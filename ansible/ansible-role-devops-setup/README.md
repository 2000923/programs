[![Docs badge](https://img.shields.io/badge/docs-latest-brightgreen.svg)](https://docs.ansible.com/ansible/latest/)
[![Chat badge](https://img.shields.io/badge/chat-IRC-brightgreen.svg)](https://docs.ansible.com/ansible/latest/community/communication.html)
[![Ansible Code of Conduct](https://img.shields.io/badge/code%20of%20conduct-Ansible-silver.svg)](https://docs.ansible.com/ansible/latest/community/code_of_conduct.html)
[![Ansible mailing lists](https://img.shields.io/badge/mailing%20lists-Ansible-orange.svg)](https://docs.ansible.com/ansible/latest/community/communication.html#mailing-list-information)
[![Repository License](https://img.shields.io/badge/license-GPL%20v3.0-brightgreen.svg)](https://www.gnu.org/licenses/gpl-3.0.html)
[![Ansible CII Best Practices certification](https://bestpractices.coreinfrastructure.org/projects/2372/badge)](https://bestpractices.coreinfrastructure.org/projects/2372)

# Configurar una laptop/Pc de escritorio para un entorno devops

### Problema

Cada vez que formateo una maquina debo configurar mi entorno de escritorio para desarrollar tecnologías en devops,
esto no es seguido, pero entiendase que configurar todo tu equipo toma al menos unas cuantas horas por ende decidí
crear un playbook que me permita configurar mi equipo con todo lo que necesito, soportado tanto para wsl como para

- Ubuntu/Xubuntu Desktop
- Ubuntu/Xubuntu por vagrant
- Windows con WSL 2.0

### Requisitos previos

    - Validar tu acceso a internet para la descarga de paquetes
    - En caso de haber generado tus propias llaves privadas/publicas sacarlas backup

### Estructura de directorios

```mermaid
graph TD
    program_devops --> install_sw
    program_devops --> Readme.md
    program_devops --> site.yml

    install_sw --> defaults
    install_sw --> handlers
    install_sw --> tasks
    install_sw --> templates
    install_sw --> vars

    defaults --> main_yml1[main.yml]
    handlers --> main_yml2[main.yml]
    tasks --> configure_firewall.yml[configure_firewall.yml]
    tasks --> configure_programs_yml[configure_programs.yml]
    tasks --> configure_repo_yml[configure_repo.yml]
    tasks --> get_temp_url_yml[get_temp_url.yml]
    tasks --> install_programs_yml[install_programs.yml]
    tasks --> main_yml3[main.yml]
    templates --> config-linux_j2[config-linux.j2]
    templates --> docker-ce_j2[docker-ce.j2]
    templates --> hashicorp_j2[hashicorp.j2]
    templates --> init_j2[init.j2]
    templates --> nodejs_j2[nodejs.j2]
    templates --> virtualbox_j2[virtualbox.j2]
    vars --> main_yml4[main.yml]
    vars --> private.yml
```

a. _program_devops_: Directorio en donde se define el projecto.

b. _install_sw_: Directorio que contiene los roles

1. defaults: Directorio donde se declara los nombres de paquetes a instalar por ejemplo: samba, samba-utils, code, etc...

2. handlers: Directorio que contiene el archivo main.yml para reiniciar el servicio, en este caso el ssh u otro demonio

3. tasks: Directorio que contiene los playbooks a desplegar

4. templates: Plantillas donde se configura los archivos jinja2 donde se personaliza el entorno a configurar

5. vars: Define las variables de nuestro proyecto con las url de los pquetes y configuración de usuario.

6. defaults: Contiene la configuración por defecto para el ansible.

# Alcance

- **[Ubuntu 22.04](https://www.ubuntu.com)**
- **[Xubuntu 22.04](https://xubuntu.org/)**
- **[WSL Ubuntu](https://learn.microsoft.com/en-us/windows/wsl/about)**

## Procedimiento de instalacion

Para comenzar debes poder tener un SO ubuntu/xubuntu en tu maquina (ver video):

a. [Instalar Ubuntu destkop](https://www.youtube.com/watch?v=8MRibUo9VAA)

    a.1 En caso de trabajar sobre windows con WLS debes asegurarte tener instalado la versión 2, te adjunto
        el procedimiento de validación e instalación

```PowerShell
# Verificar la versión actual de WSL
wsl -l -v

# En caso de tener la versión 1, continuar:
# Habilitar WSL y la plataforma de máquina virtual
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# Descargar e instalar el kernel de WSL 2 desde: https://aka.ms/wsl2kernel

# Establecer WSL 2 como predeterminado
wsl --set-default-version 2

# Convertir una distribución específica a WSL 2
wsl --set-version <distro_name> 2

# Verificar la conversión
wsl -l -v
```

b. Instalar ansible, lo puedes realizar con el siguiente script que se ubica en files/intall_prerequisites.sh o ejecutar paso por paso

```shell
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
```

d. Ejecutar el playbook
d.1. Debes copiar el proyecto de mi repositorio con el comando

```shell
    git clone https://github.com/2000923/programs.git
    cd programs/ansible/
```

La estructura del directorio del proyecto sería como sigue:

```mermaid
graph TD
    programs --> ansible --> setup_development.yml
```

```shell
# El párametro -k es para ingresar la clave de sudo, para omitir este párametro puede añadir su usuario al archivo /etc/sudoers con el contenido "<usuario> ALL=(ALL) NOPASSWD: ALL"
ansible-playbook -ilocalhost, setup_development.yml -k
```

## Observaciones:

En caso de ser usuario, que estas reinstalando el SO por algun inconveniente, puedes copiar las llaves que tenias anteriormente,

## Contacts

- **Autor:** [Edwin Enrique Flores Bautista](https://www.linkedin.com/in/edwin-enrique-flores-bautista/)
- **Email:** 2000923@unmsm.edu.pe
