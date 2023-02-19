#!/bin/bash

virsh list --all

autostart_list="
CentOS-01
Ubuntu-01
Win10-01
"

for vm in $autostart_list; do
        virsh autostart $vm
done

exit

#
#
#

root@vm4:~/bin/kvm# bash vm_autostart.sh 
 Id   Name           State
-------------------------------
 1    Ubuntu-01      running
 2    Win10-01       running
 4    CentOS-01      running
 8    Win2K12R2-01   running
 -    CentOS-41      shut off
 -    CentOS-42      shut off
 -    CentOS-43      shut off
 -    CentOS-44      shut off
 -    PA-VM-05       shut off
 -    PA-VM-06       shut off
 -    Win7-01        shut off

Domain 'CentOS-01' marked as autostarted

Domain 'Ubuntu-01' marked as autostarted

Domain 'Win10-01' marked as autostarted

root@vm4:~/bin/kvm# 
