#!/bin/bash

DATE=`date +"%m%d_%H"`

(echo "++++++++++++++++++++++++++++";date;ps -eo pcpu,pmem,pid,pidns,comm,user,uid --forest | awk 'NR==1 {printf "hostname/podName\t";print $0} NR>1 {cmd="nsenter -t "$3" -u hostname 2>/dev/null"; cmd|getline output; close(cmd); printf "%s\t%s\n", output, $0}';echo "========CPU cores Usage:";mpstat -P ALL 2 1|grep Average) >> /tmp/collect_cpu_${DATE}
