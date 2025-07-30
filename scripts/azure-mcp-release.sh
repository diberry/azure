#!/bin/bash

now=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
since=$(date -u -d "24 hours ago" +"%Y-%m-%dT%H:%M:%SZ")
curl -s https://api.github.com/repos/Azure/azure-mcp/releases | \
  jq -r --arg since "$since" '
    [ .[] | select(.published_at >= $since) ] |
    if length == 0 then
      "" 
    else
      (["| Tag | Published At | Zipball URL |", "|---|---|---|"] + 
      (map("| \(.tag_name) | \(.published_at) | [zip](\(.zipball_url)) |"))) | 
      .[] 
    end
  ' > ../.github/mcp-release.md

# Output the list of tags found
tags=$(curl -s https://api.github.com/repos/Azure/azure-mcp/releases | jq -r --arg since "$since" '.[] | select(.published_at >= $since) | .tag_name')
tag_list=$(echo "$tags" | grep -v '^$' | sort | uniq | paste -sd ", " -)
echo "$tag_list"