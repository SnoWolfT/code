#!/bin/bash
if (( $# < 1 ))
then
    printf "%b" "Error. Not enough arguments.\n" >&2
    printf "%b" "usage: accessNode.sh <node_name>\n" >&2
    exit 1
fi

script_path=$(readlink -f "$0")
script_dir=$(dirname "$script_path")

sed  "s|destinationNode|${1}|g" ${script_dir}/debugtemplate > ${script_dir}/debugpod.yaml
kubectl apply -f ${script_dir}/debugpod.yaml

sleep 5

kubectl get pod -o wide | grep debugger-${1}

kubectl exec debugger-${1} -it -- /bin/bash
