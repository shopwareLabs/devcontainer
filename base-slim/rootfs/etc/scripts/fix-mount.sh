#!/usr/bin/env sh

if [[ ! -d /workspaces/ ]]; then
    echo "Cannot find /workspaces/ directory"
    exit 0
fi

files_in_workspace=$(ls /workspaces/)

project_dir=""

for file in $files_in_workspace; do
    if [[ -d "/workspaces/$file" ]]; then
        project_dir="/workspaces/$file"
    fi
done

if [[ -z "$project_dir" ]]; then
    echo "Cannot find project directory in /workspaces/"
    exit 0
fi

files_in_public=$(ls -l /var/www/html/public | grep -v "^total" | wc -l)

if [[ $files_in_public == 1 ]]; then
    rm -rf /var/www/html
    ln -s $project_dir /var/www/html
else
    echo "Found files in /var/www/html/public, skipping linking"
fi
