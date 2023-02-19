#!/bin/bash

# [2023021601]
#
# Script to provision a new VM

#
# VM configuration, should be saved separately in a different file.
#

vm_n=2
vm_i=171

ip='192.168.1.%d'
netmask='255.255.255.0'
gateway='192.168.1.254'
nameserver='1.1.1.1'
hostname="centos-%3d"

root_pw='password'
user_name='admin'
user_pw='password'

#
# VM settings

name="CentOS-%d"
title="CentOS-%d (.%d)"

#
# Common settings of all VM's
#

# Use `virt-install --osinfo list` to get the list of the accepted OS variants.
#
osname="centos7"

cdrom="/home/terence/Downloads/CentOS-7-x86_64-DVD-2009.iso"
path="/var/lib/libvirt/images/%s.qcow2"

# hardware resources
#
sockets=1
cores=1
ram=1024  # 2048 MB
disk=10   # 20 GB

autostart="1"

# Use `virt-install --network=?` to see a list of all available sub options.
#
net_type="direct"
net_source="eno2"  # mode=bridge assumed
net_model="virtio"

if [ ! -e /sys/class/net/$net_source ]; then
	echo "$net_source: host interface not found, exiting.."
	exit 1
fi

network="type=$net_type,source=$net_source,source.mode=bridge,model=$net_model"

#
# unattended installation
#

ks_dir="ks_cfg"
ks_file="centos7-%3d.ks"
ks_template="centos7.ks"

# user_login="admin"
# user_password_file="/root/bin/kvm/pass.txt"

product_key=""  # Windows 10

# -------------------------------------------------------------------------------- 
#

vcpus="sockets=$sockets,cores=$cores"

if [ -n "$autostart" ]; then
	autostart="--autostart"
fi

vm_id=$vm_i

for ((i = 0; i < $vm_n; i++)); do

	vm_name=`printf "$name" $vm_id`
	vm_title=`printf "$title" $vm_id $vm_id`
	vm_path=`printf "$path" $vm_name`
	vm_ks_file=`printf "$ks_file" $vm_id`
	vm_ks_path="$ks_dir/$vm_ks_file"

	vm_hostname=`printf "$hostname" $vm_id`
	vm_ip=`printf "$ip" $vm_id`

	# check if the VM file exists (has been provisioned)
	#
	if [ -e "$vm_path" ]; then
		echo "$vm_path: VM found, skipping to the next one.."
		continue
	fi

	if [ ! -e "$ks_template" ]; then
		echo "$ks_template: KS template not found, exiting.."
		exit 1
	fi

	# generate the ks file
	#
	cat $ks_template > $vm_ks_path
	cat <<EOF >> $vm_ks_path
rootpw --plaintext $root_pw

user --name=$user_name --shell=/bin/bash --homedir=/home/$user_name --password=$user_pw --plaintext

# Network information
network --bootproto=static --device=eth0 --gateway=$gateway --ip=$vm_ip --nameserver=$nameserver --netmask=$netmask --hostname=$vm_hostname
EOF

	echo --------------------------------------------------------------------------------
	date
	echo

	virt-install \
		--name $vm_name \
		--metadata title="$vm_title" \
		--osinfo detect=on,name="$osname" \
		--cdrom $cdrom \
		--location $cdrom \
		--disk "path=$vm_path,size=$disk,bus=virtio" \
		--ram=$ram \
		--vcpus=$vcpus \
		--network "$network" \
		--initrd-inject="$vm_ks_path" --extra-args "ks=file:/$vm_ks_file" \
		$autostart

	# --unattended "user-login=$user_login,user-password-file=$user_password_file" \
	# --unattended product-key="product_key"

	if [ "$debug" = "yes" ]; then
		break
	fi

	((vm_id++))
done

exit

#
# End
#

--description "Test VM with RHEL 6" \
--graphics none \
--os-type=Linux \
--os-variant=rhel6 \
