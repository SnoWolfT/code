#!/bin/bash
# Example: ./dnsLoadTest.sh www.bing.com

dnsname=$1

while true
do
  result=$(nslookup -timeout=2 -retry=1 ${dnsname} | awk '!a[$0]++' | tr '\n' '|' | tr '\t' ' ')  # remove duplicate line, remove \n and \t for JSON format
  echo "$(date -u +'%F %H:%M:%S.%3N'),${dnsname},${result}"
done
