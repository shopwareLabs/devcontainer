# Devcontainer Image

> [!NOTE]
> This is an experiment and may be discontinued based on user feedbacks

Devcontainers are a feature of Visual Studio Code that allow you to define a development environment in a container. This allows you to have a consistent development environment across different machines and operating systems. This is adapted also to different other edtitors like PhpStorm.

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
