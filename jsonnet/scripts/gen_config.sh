#!/bin/bash -e

for dir in ../config/*/; do
    project="$(basename /"${dir}/")"
    mkdir -p "../generated/${project}"
    jsonnet "../config/${project}/envs/main.jsonnet" -m "../generated/${project}"
    if [ $? -ne 0 ]; then 
        echo "Failed due to errors in configs..."
        exit 1
    fi
done
