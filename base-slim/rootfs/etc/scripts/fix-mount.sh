#!/usr/bin/env sh

workspace_dir=""

if [[ -d "/workspaces/" ]]; then
    workspace_dir="/workspaces/"
else
    if [[ -d "/IdeaProjects/" ]]; then
        workspace_dir="/IdeaProjects/"
    else
        echo "Cannot find workspace directory"
        exit 0
    fi
fi


files_in_workspace=$(ls "$workspace_dir")

project_dir=""

for file in $files_in_workspace; do
    if [[ -d "${workspace_dir}${file}" ]]; then
        project_dir="${workspace_dir}${file}"
    fi
done

if [[ -z "${project_dir}" ]]; then
    echo "Cannot find project directory in /workspaces/"
    exit 0
fi

files_in_public=$(ls -l /var/www/html/ | grep -v "^total" | wc -l)

if [[ $files_in_public == 0 ]]; then
    rm -rf /var/www/html
    ln -s $project_dir /var/www/html
else
    echo "Found files in /var/www/html/public, skipping linking"
fi
