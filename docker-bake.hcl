target "base-slim" {
    name = "base-slim-${replace(phpVersion, ".", "-")}"
    matrix = {
        phpVersion = ["8.2", "8.3"]
    }
    args = {
        PHP_VERSION = phpVersion
    }
    dockerfile = "Dockerfile.base-slim"
    tags = [ "ghcr.io/shopware/devcontainer/base-slim:${phpVersion}" ]
    platforms = ["linux/amd64", "linux/arm64"]
}

target "base-full" {
    name = "base-full-${replace(phpVersion, ".", "-")}"
    matrix = {
        phpVersion = ["8.2", "8.3"]
    }
    args = {
        PHP_VERSION = phpVersion
    }
    dockerfile = "Dockerfile.base-full"
    tags = [ "ghcr.io/shopware/devcontainer/base-full:${phpVersion}" ]
    platforms = ["linux/amd64", "linux/arm64"]
}
