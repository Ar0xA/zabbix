#!/bin/bash
dm_device=$1
dm_info=$2

if [ -z $dm_device ]; then
        disks=`cat /proc/fs/cifs/Stats | grep ")" | grep -v "(" | awk -F'\\' {'print $NF'}`
else
        stats=`cat /proc/fs/cifs/Stats | grep -A10 $dm_device"$"`
        READS=`echo $stats | awk {'print $9'}`
        READBYTES=`echo $stats | awk {'print $11'}`
        WRITES=`echo $stats | awk {'print $13'}`
        WRITEBYTES=`echo $stats | awk {'print $15'}`
fi

if [ -z $dm_info ]; then
        echo -e "{"
        echo -e "\t\"data\":[\n"
        for dm_name in $disks
        do
                echo -e "\t\t{ \"{#CIFNAME}\":\"$dm_name\"\t},"
        done
        echo -e "\t]\n}"
else
        echo ${!dm_info}
fi
