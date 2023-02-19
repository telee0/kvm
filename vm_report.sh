#!/bin/bash

#
# [20230205]
#
# script to report VM states
#

nHours=24
hostname=`hostname`
subj="Anacron job 'cron.daily' on $hostname"
from="From: Anacron <root@$hostname>"

dataDir="/a1/data/temp"

/a1/bin/kvm/vm_check.sh \
	| mail root -a "$from" -s "$subj"

exit

# last $nHours entities from data files
#

find $dataDir -type f -exec \
    stat -c '%Y %n' {} \; \
    | sort -n | tail -3 | cut -d' ' -f2 \
    | xargs cat | tail -$nHours \
    | mail root -a "$from" -s "$subj"

exit

