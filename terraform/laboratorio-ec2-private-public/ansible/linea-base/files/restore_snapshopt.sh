#!/bin/bash
_vms_01="monitoreo"
_vms_02="bastion"
vboxmanage controlvm ${_vms_01} poweroff
vboxmanage controlvm ${_vms_02} poweroff
vboxmanage snapshot ${_vms_01} restore "${_vms_01}_origen"
vboxmanage snapshot ${_vms_02} restore "${_vms_02}_origen"
vboxmanage startvm ${_vms_01} --type=headless
vboxmanage startvm ${_vms_02} --type=headless
