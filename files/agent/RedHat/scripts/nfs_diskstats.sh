#!/bin/bash
nfs_stat=$1

if [ -z $nfs_stat ]; then
	echo "ZBX_NOTSUPPORTED"
else
	if [ `find /tmp -name "nfsstats" -mmin 1 -type f | wc -l` -eq 0 ]; then
		cat /proc/net/rpc/nfsd > /tmp/nfsstats
	fi
	#REPLY_CACHE
	read REPLY_CACHE CACHE_HITS CACHE_MISSES NOCACHE < <(cat /tmp/nfsstats | grep "rc")
	#FILE_HANDLERS
	read FILE_HANLDERS STALE TOTAL_LOOKUPS ANONYMOUS_LOOKUPS DIR_NOT_IN_DCACHE NON_DIR_NOT_IN_DCACHE < <(cat /tmp/nfsstats | grep "fh")
	#IO
	read IO BYTES_READ BYTES_WRITTEN < <(cat /tmp/nfsstats | grep "io")
	#THREADS
	read THREADS TOTAL_THREADS ALL_THREADS_USED CPU_1_10 CPU_11_20 CPU_21_30 CPU_31_40 CPU_41_50 CPU_51_60 CPU_61_70 CPU_71_80 CPU_81_90 CPU_91_100 < <(cat /tmp/nfsstats | grep "th")
	#READ_AHEAD_CACHE
	read READ_AHEAD_CACHE READ_AHEAD_CACHE_SIZE CACHE_1_10 CACHE_11_20 CACHE_21_30 CACHE_31_40 CACHE_41_50 CACHE_51_60 CACHE_61_70 CACHE_71_80 CACHE_81_90 CACHE_91_100 NO_CACHE < <(cat /tmp/nfsstats | grep "ra")
	#NET
	read NET PACKETS UDP_PACKETS TCP_PACKETS TCP_CONN < <(cat /tmp/nfsstats | grep "net")
	#RPC
	read RPC CALLS BAD_CALLS BAD_CLIENT BAD_AUTH BAD_XDR_HEAD < <(cat /tmp/nfsstats | grep "rpc")
	#PROC3
	read PROC3 XX NULL GETATTR SETATTR LOOKUP ACCESS READLINK READS WRITES CREATE MKDIR SYMLINK MKNOD REMOVE RMDIR RENAME LINK READDIR READDIRPLUS FSSTAT FSINFO PATHCONF COMMIT < <(cat /tmp/nfsstats | grep "proc3")
	#PROC4OPS
#	read PROC4OPS XX OP0_UNUSED OP1_UNUSED OP2_FUTURE ACCESS CLOSE COMMIT CREATE DELEGPURGE DELEGRETURN GETATTR GETFH LINK LOCK LOCKT LOCKU LOOKUP LOOKUP_ROOT NVERIFY OPEN OPENATTR OPEN_CONF OPEN_DGRD PUTFH PUTPUBFH PUTROOTFH READ READDIR READLINK REMOVE RENAME RENEW RESTOREFH SAVEFH SECINFO SETATTR SETCLTID SETCLTIDCONF VERIFY WRITE RELLOCKOWNER < <(cat /tmp/nfsstats | grep "proc4ops")
	echo ${!nfs_stat}
fi