variable "image" {
    default = "ghcr.io/shopwarelabs/devcontainer"
}

variable "currentPHPVersion" {
    default = "8.2"
}

variable "currentShopwareVersion" {
    default = "6.6.4.1"
}

target "base-slim" {
    name = "base-slim-${replace(php, ".", "-")}"
    matrix = {
        php = ["8.2", "8.3", "8.4"]
    }
    args = {
        PHP_VERSION = php
    }
    context = "base-slim"
    tags = [ "${image}/base-slim:${php}" ]
    platforms = ["linux/amd64", "linux/arm64"]
}

target "base-full" {
    name = "base-full-${replace(php, ".", "-")}"
    matrix = {
        php = ["8.2", "8.3", "8.4"]
    }
    args = {
        PHP_VERSION = php
    }
    contexts = {
        base = "docker-image://${image}/base-slim:${php}"
    }
    context = "base-full"
    tags = [ "${image}/base-full:${php}" ]
    platforms = ["linux/amd64", "linux/arm64"]
}

target "symfony-flex" {
    args = {
        PHP_VERSION = currentPHPVersion
        SHOPWARE_VERSION = currentShopwareVersion
    }
    contexts = {
        base = "docker-image://${image}/base-full:${currentPHPVersion}"
        shopware-cli = "docker-image://shopware/shopware-cli:latest-php-${currentPHPVersion}"
    }
    context = "symfony-flex"
    tags = [ "${image}/symfony-flex:${regex("^[0-9]+\\.[0-9]+\\.[0-9]+", currentShopwareVersion)}-${currentPHPVersion}" ]
    platforms = ["linux/amd64", "linux/arm64"]
}

target "dev" {
    args = {
        PHP_VERSION = currentPHPVersion
        SHOPWARE_VERSION = currentShopwareVersion
    }
    contexts = {
        base = "docker-image://${image}/base-full:${currentPHPVersion}"
        shopware-cli = "docker-image://shopware/shopware-cli:latest-php-${currentPHPVersion}"
    }
    context = "dev"
    tags = [ "${image}/contribute:${regex("^[0-9]+\\.[0-9]+\\.[0-9]+", currentShopwareVersion)}-${currentPHPVersion}" ]
    platforms = ["linux/amd64", "linux/arm64"]
}
