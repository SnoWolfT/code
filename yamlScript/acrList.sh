#!/bin/bash

usage()
{
  echo "usage: acrList.sh <acr_name>"
}

parseCommandLine()
{
  ACR_NAME=$1
  if [ -z "$ACR_NAME" ]; then
    printf "Script ERROR Message: No ACR specified\n"
    usage; exit 1
  fi
}  

collectACRList()
{
exportFile="acrList_$(date +%Y%m%d_%H%M%S).csv"

repos=$(az acr repository list --name $ACR_NAME --output tsv)

if [ -z "$repos" ]; then
    printf "Script ERROR Message: The specified ACR either does not exist or contains no repository. Please double check.\n"
    exit 2
else
    echo -e "Repository | Image Count | Last Modified | Image Tag" >> $exportFile
fi

for repo in $repos; do
    tags_json=$(az acr repository show-tags \
        --name $ACR_NAME \
        --repository $repo \
        --detail \
        --output json)

    image_count=$(echo "$tags_json" | jq '. | length')

    echo "$tags_json" | jq -r --arg repo "$repo" --arg count "$image_count" \
        '.[] | "\($repo) | \($count) | \(.lastUpdateTime) | \(.name)"'
done >> $exportFile
}

#-------------------------------------------------------------------------------
# MAIN
#-------------------------------------------------------------------------------

parseCommandLine $@

collectACRList
