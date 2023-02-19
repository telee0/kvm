#!/bin/bash

#
# [2022120301]
#

echo
echo virsh list
virsh list

for i in 1 2 3; do
	vm_list=`virsh list --name`
	count=0
	for vm in $vm_list; do
		state=`virsh domstate $vm | head -1`
		if [ "$state" = "running" ]; then
			echo $vm: $state..
			virsh shutdown $vm
			((count++))
		else
			echo $vm: not running..
		fi
	done
	if [ $count -eq 0 ]; then
		break
	fi
	sleep 5
done

exit

