#!/bin/bash

#
# Script to provision a new VM
#

#
# VM configuration, should be saved separately in a different file.
#

name="Ubuntu-22"
title="Ubuntu-22 (.122)"

# Use `virt-install --osinfo list` to get the list of the accepted OS variants.
#
osname="ubuntu22.04"

cdrom="/home/terence/Downloads/ubuntu-22.04.1-live-server-amd64.iso"
path="/var/lib/libvirt/images/$name.qcow2"

# hardware resources
#
sockets=1
cores=2
ram=4096  # 4096 MB
disk=20   # 20 GB

autostart="1"

# Use `virt-install --network=?` to see a list of all available sub options.
#
net_type="direct"
net_source="eno1"  # mode=bridge assumed
net_model="virtio"

network="type=$net_type,source=$net_source,source.mode=bridge,model=$net_model"

#
# unattended installation
#

cloud_init=""

# --cloud-init options:
#  clouduser-ssh-key
#  disable
#  meta-data
#  network-config
#  root-password-file
#  root-password-generate
#  root-ssh-key
#  user-data

ks_cfg="ubuntu22.ks"

# user_login="admin"
# user_password_file="/root/bin/kvm/pass.txt"

product_key=""  # Windows 10

# --------------------------------------------------------------------------------
#
# check if the VM exists (has been provisioned)
#

if [ -e "$path" ]; then
	echo "$path: VM found, exiting.."
	exit 1
fi

#
# 
#

vcpus="sockets=$sockets,cores=$cores"

if [ -n "$autostart" ]; then
	autostart="--autostart"
fi

virt-install \
	--name $name \
	--metadata title="$title" \
	--osinfo detect=on,name="$osname" \
	--disk "path=$path,size=$disk,bus=virtio" \
	--ram=$ram \
	--vcpus=$vcpus \
	--network "$network" \
	--location "$cdrom",initrd=casper/initrd,kernel=casper/vmlinuz \
	--extra-args='net.ifnames=0 biosdevname=0 ip=192.168.1.169::192.168.1.24:255.255.255.0:ubuntu-22:eth0:none:192.168.1.254 autoinstall ds=nocloud-net;s=http://192.168.1.24:3003/' \
	$autostart

	# --location $cdrom \
	# --cdrom $cdrom \
	# --extra-args "autoinstall ks=file:/$ks_cfg" \
	# --initrd-inject="$ks_cfg" --extra-args "ks=file:/$ks_cfg" \
	# --unattended "user-login=$user_login,user-password-file=$user_password_file" \
	# --unattended product-key="product_key"

exit


#
# other 
#

--description "Test VM with RHEL 6" \
--graphics none \
--os-type=Linux \
--os-variant=rhel6 \
