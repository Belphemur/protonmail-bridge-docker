#!/bin/bash

IFS=$'\n' read -d '' -ra lines <<< "$DOCKER_METADATA_OUTPUT_ANNOTATIONS"

# Initialize an empty array to store the annotations
annotations=()

# Loop through each line and extract the key-value pairs
for line in "${lines[@]}"; do
    # Remove leading/trailing whitespace
    line=$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    
    # Extract the key and value
    key=$(echo "$line" | cut -d'=' -f1 | sed 's/^manifest:/index:/')
    value=$(echo "$line" | cut -d'=' -f2-)

    # Append --annotation flag with the key-value pair to the annotations array
    annotations+=("--annotation $key=$value")
done
echo ${annotations[@]}
echo "annotations=${annotations[@]}" >> $GITHUB_OUTPUT
