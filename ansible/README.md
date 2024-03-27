[![PyPI version](https://img.shields.io/pypi/v/ansible-core.svg)](https://pypi.org/project/ansible-core)
[![Docs badge](https://img.shields.io/badge/docs-latest-brightgreen.svg)](https://docs.ansible.com/ansible/latest/)
[![Chat badge](https://img.shields.io/badge/chat-IRC-brightgreen.svg)](https://docs.ansible.com/ansible/latest/community/communication.html)
[![Build Status](https://dev.azure.com/ansible/ansible/_apis/build/status/CI?branchName=devel)](https://dev.azure.com/ansible/ansible/_build/latest?definitionId=20&branchName=devel)
[![Ansible Code of Conduct](https://img.shields.io/badge/code%20of%20conduct-Ansible-silver.svg)](https://docs.ansible.com/ansible/latest/community/code_of_conduct.html)
[![Ansible mailing lists](https://img.shields.io/badge/mailing%20lists-Ansible-orange.svg)](https://docs.ansible.com/ansible/latest/community/communication.html#mailing-list-information)
[![Repository License](https://img.shields.io/badge/license-GPL%20v3.0-brightgreen.svg)](COPYING)
[![Ansible CII Best Practices certification](https://bestpractices.coreinfrastructure.org/projects/2372/badge)](https://bestpractices.coreinfrastructure.org/projects/2372)

# Repositorio

En este entorno de trabajo, encontraras varios proyectos, algunos desordenados, perdon por ello pero poco a poco lo corregiremos.

# Proyectos

## Devops:

### Monta tu entorno para trabajar en GNU-Linux

    Nota: Cansado de instalar manualmente tu entorno de desarrollo en ambientes GNU/LINUX ( por el momento soporta UBUNTU family), ejecuta este playbook y instala todos los programas que necesitas
    Lista:
    a. Personalizacion de tu SO, todo ello puedes ver en el apartado defaults/main.yml
        1. Instalacion de herramientas de administracion, tale como htop; nmon; etc.
        2. Instalacion de tools para desarrollo, tales como python3 python3.pip, etc.
        3. Herramientas de red tales como nmap, utilitarios.
    b. Configuracion de vim basado en el trabajo de ! [cratzydog](https://github.com/craftzdog/dotfiles-public)
    c. Instalacion de virtualbox
        1. Instalacion de Oracle Extension Pack
        2. Configuracion de vboxnet0 con la red 192.168.56.0/22
    d. Instalacion de cli, tales como azure, aws y otros.
    e. Instalacion de docker
    f. Instalacion de vagrant
        1. Instalacion de plugins group

    Mayor detalle en Readme

# Ansible for Unix

Scripts en ansible desarrollados para equipos UNIX ( solaris/GNU-Linux/AIX ) requiere

- python
- ansible 2.10
- ansible-galaxy
- Ubuntu 22.04

# Estructura

Dentro del desarrollo se encuentra muchos casos practicos relacionados a anteriores trabajos realizados.

# Developer

2000923@unmsm.edu.pe
