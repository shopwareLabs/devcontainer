#!/usr/bin/env sh

workspace_dir=""

if [[ -d "/workspaces/" ]]; then
    workspace_dir="/workspaces/"
else
    if [[ -d "/IdeaProjects/" ]]; then
        workspace_dir="/IdeaProjects/"
    else
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

type=$(jq -r .type "${project_dir}/composer.json")
name=$(jq -r .name "${project_dir}/composer.json" | sed 's/\/t/T/' | sed 's/^f/F/')

if [[ $type == "shopware-platform-plugin" || $type == "shopware-bundle" ]]; then
    rm -rf "/var/www/html/custom/plugins/$name"
    ln -s $project_dir "/var/www/html/custom/plugins/$name"
else
    files_in_public=$(ls -l /var/www/html/ | grep -v "^total" | wc -l)

    if [[ $files_in_public == 0 ]]; then
        rm -rf /var/www/html
        ln -s $project_dir /var/www/html
    else
        echo "Found files in /var/www/html/public, skipping linking"
    fi
fi
