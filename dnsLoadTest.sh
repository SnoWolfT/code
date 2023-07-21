#!/bin/bash
# Example: ./dnsLoadTest.sh www.bing.com 168.63.129.16

dnsname=$1
dnsserver=$2

while true
do
  result=$(nslookup -timeout=2 -retry=1 ${dnsname} ${dnsserver} | awk '!a[$0]++' | tr '\n' '|' | tr '\t' ' ')  # remove duplicate line, remove \n and \t for JSON format
  echo "$(date -u +'%F %H:%M:%S.%3N'),${dnsname},${result}" | grep "timed out"
done
