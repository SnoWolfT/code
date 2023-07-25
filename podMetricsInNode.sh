#!/bin/bash
#-----------------------------------------------------------------------------------
# podMetricsInNode.sh 
#
# Author: Tom Zhu
# Version: 1.0
#-----------------------------------------------------------------------------------

usage()
{
  echo "usage: podMetricsInNode.sh [-cmCMh] <node_name>"
  echo "-c  print the pod metrics sorted by cpu"
  echo "-m  print the pod metrics sorted by memory"
  echo "-C  calculate the sum of pod cpu"
  echo "-M  calculate the sum of pod memory"
}

parseCommandLine()
{
  argv=`getopt cmCMh: ${*-} 2> /dev/null`
  if [ $? -ne 0 ]; then
    printf "ERROR: Invalid option(s).\n" 
    usage
    exit 1
  fi

  nodeName=$2
  if [ -z "$nodeName" ]; then
    printf "ERROR: No Node specified\n" 
    usage; exit 1
  fi

  set -- $argv
  while [[ $1 != -- ]]; do
    case $1 in
      -c) FLAG="CPUSORT"; break ;;
      -m) FLAG="MEMSORT"; break ;;
      -C) FLAG="CPUSUM"; break  ;;
      -M) FLAG="MEMSUM"; break  ;;      
      -h) usage       ;;
      *) usage        ;;
    esac
  done
}

checkNodeExisting()
{
    script_path=$(readlink -f "$0")
    script_dir=$(dirname "$script_path")

    getPod=${script_dir}/get_pod.txt
    topPod=${script_dir}/top_pod.txt

    nodeList=`kubectl get node -o jsonpath='{range .items[*]}{@.metadata.name}{"\n"}{end}'`
    if echo $nodeList | grep -w $nodeName &> /dev/null ; then
    kubectl get pods -A -o jsonpath='{range .items[?(@.status.phase=="Running")]}{.metadata.name}{"\t"}{.spec.nodeName}{"\n"}{end}'| grep $nodeName > ${getPod}
    kubectl top pod -A | grep -v "MEMORY(bytes)" > ${topPod}
    echo "===== $nodeName exists. Collect pods' metrics."
    else
    echo "ERROR: $nodeName doesn't exist. Please double check. Here is the node list."
    printf "$nodeList\n"
    exit 1
    fi
}

checkPodMetrics()
{
    case $FLAG in
        CPUSORT) awk '{if (NR==FNR) {a[$1]=$1; a[$2]=$2;next} if ($2 in a) {print $0}}' OFS='\t' ${getPod} ${topPod} | sort -n -k 3;;
        MEMSORT) awk '{if (NR==FNR) {a[$1]=$1; a[$2]=$2;next} if ($2 in a) {print $0}}' OFS='\t' ${getPod} ${topPod} | sort -n -k 4;;
        CPUSUM) awk '{if (NR==FNR) {a[$1]=$1; a[$2]=$2;next} if ($2 in a) {print $0}}' OFS='\t' ${getPod} ${topPod} | awk '{sum+=$3} END {print "Total CPU consumption: "sum}';;
        MEMSUM) awk '{if (NR==FNR) {a[$1]=$1; a[$2]=$2;next} if ($2 in a) {print $0}}' OFS='\t' ${getPod} ${topPod} | awk '{sum+=$4} END {print "Total Memory consumption: "sum}';;
    esac
}

#-------------------------------------------------------------------------------
# MAIN
#-------------------------------------------------------------------------------

parseCommandLine $@

checkNodeExisting

checkPodMetrics
