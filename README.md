# Devcontainer Image

This repository contains a Devcontainer Image for Shopware 6.6. 

## Example file for plugin development

```json
{
	"image": "quay.io/friendsofshopware/devcontainer:6.6.3-8.3",
	"workspaceMount": "source=${localWorkspaceFolder}/,target=/var/www/html/custom/plugins/FroshTools,type=bind",
	"workspaceFolder": "/var/www/html",
	"overrideCommand": false,
	"portsAttributes": {
		"8000": {
			"label": "Shopware",
			"onAutoForward": "notify"
		},
		"8080": {
			"label": "Administration Watcher",
			"onAutoForward": "notify"
		}
	},
	"onCreateCommand": "php bin/console plugin:refresh && php bin/console plugin:install --activate FroshTools"
}
```

You can browse https://quay.io/repository/friendsofshopware/devcontainer for all tags.
