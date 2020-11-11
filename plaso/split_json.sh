#!/bin/bash

# Split a JSON into multiple files. Uses jq.

# Usage
# ./split_json.sh /path/to/json/file

file="$1"

jq -cr 'keys[] as $k | "\($k)\t\(.[$k])"' "$file"  | awk -F\\t '{ file=$1".json"; print $2 > file; close(file); }'