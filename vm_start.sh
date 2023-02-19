#!/bin/bash

#
# [2022120301]
#

autostart_list=`virsh list --autostart --all --name`

for i in 1 2 3; do
	count=0
	for vm in $autostart_list; do
		state=`virsh domstate $vm | head -1`
		if [ "$state" = "running" ]; then
			echo $vm: already $state..
		else
			echo $vm: being started..
			virsh start $vm
			((count++))
		fi
	done
	if [ $count -eq 0 ]; then
		break
	fi
	sleep 5
done

exit

