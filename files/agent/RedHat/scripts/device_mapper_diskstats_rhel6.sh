#!/bin/bash
dm_device=$1
dm_info=$2

if [ -z $dm_device ]; then
	disks=`cat /proc/diskstats | grep "dm-" |awk {'print $3'}`
	disks=( $disks )
	number_of_disks=${#disks[@]}
	disks="${disks[*]}"
else
	device=`echo $dm_device | awk -F"_" {'print $1'}`
	read MAJOR MINOR DMNAME READS_COMPLETED READS_MERGED READS_SECTORS READS_TIME WRITES_COMPLETED WRITES_MERGED WRITES_SECTORS WRITES_TIME IO_QUEUE IO_TIME WIO_TIME < <(cat /proc/diskstats | grep "$device")
fi

if [ -z $dm_info ]; then
	echo -e "{"
	echo -e "\t\"data\":[\n"
	teller=1
	for dm_name in $disks
	do
		mount_name=`ls -l /dev/mapper/ | grep -e "$dm_name$" | awk {'print $9'}`
		dm_name+="_"
		dm_name+=$mount_name
		if [ "$teller" -lt "$number_of_disks" ]; then
			echo -e "\t\t{ \"{#DMNAME}\":\"$dm_name\"\t},"
		else
			echo -e "\t\t{ \"{#DMNAME}\":\"$dm_name\"\t}"
		fi
		let teller+=1
	done
	echo -e "\t]\n}"
else
	echo ${!dm_info}
fi
