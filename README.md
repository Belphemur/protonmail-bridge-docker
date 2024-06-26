# ProtonMail IMAP/SMTP Bridge Docker Container

![build badge](https://github.com/belphemur/protonmail-bridge-docker/workflows/build%20from%20source/badge.svg)

This is an unofficial Docker container of the [ProtonMail Bridge](https://protonmail.com/bridge/). Some of the scripts are based on [Hendrik Meyer's work](https://gitlab.com/T4cC0re/protonmail-bridge-docker).

GitHub: [https://github.com/belphemur/protonmail-bridge-docker](https://github.com/belphemur/protonmail-bridge-docker)

## Tags

There are two types of images.
 - `build`: Images based on the [source code](https://github.com/ProtonMail/proton-bridge). It supports `amd64` and `arm64`.

tag | description
 -- | --
`latest` | latest image
`[version]` | versionned images

## Ports
Protocol | Port
 -- | --
`smtp` | 1025
`imap` | 1143

## Initialization

To initialize and add account to the bridge, run the following command.

```
docker run --rm -it -v protonmail:/config ghcr.io/belphemur/protonmail-bridge /app/protonmail/init-bridge.sh
```

Wait for the bridge to startup, use `login` command and follow the instructions to add your account into the bridge. Then use `info` to see the configuration information (username and password). After that, use `exit` to exit the bridge. You may need `CTRL+C` to exit the docker entirely.

## Run

To run the container, use the following command.

```
docker run -d --name=protonmail-bridge -v protonmail:/config -p 25:1025/tcp -p 143:1143/tcp --restart=unless-stopped ghcr.io/belphemur/protonmail-bridge
```

## Kubernetes

If you want to run this image in a Kubernetes environment. You can use the [Helm](https://helm.sh/) chart (https://github.com/k8s-at-home/charts/tree/master/charts/stable/protonmail-bridge) created by [@Eagleman7](https://github.com/Eagleman7). More details can be found in [#23](https://github.com/belphemur/protonmail-bridge-docker/issues/23).

If you don't want to use Helm, you can also reference to the guide ([#6](https://github.com/belphemur/protonmail-bridge-docker/issues/6)) written by [@ghudgins](https://github.com/ghudgins).

## Security

Please be aware that running the command above will expose your bridge to the network. Remember to use firewall if you are going to run this in an untrusted network or on a machine that has public IP address. You can also use the following command to publish the port to only localhost, which is the same behavior as the official bridge package.

```
docker run -d --name=protonmail-bridge -v protonmail:/config -p 127.0.0.1:1025:1025/tcp -p 127.0.0.1:1143:1143/tcp --restart=unless-stopped ghcr.io/belphemur/protonmail-bridge
```

Besides, you can publish only port 25 (SMTP) if you don't need to receive any email (e.g. as a email notification service).

## Compatibility

The bridge currently only supports some of the email clients. More details can be found on the official website. I've tested this on a Synology DiskStation and it runs well. However, you may need ssh onto it to run the interactive docker command to add your account. The main reason of using this instead of environment variables is that it seems to be the best way to support two-factor authentication.

## Bridge CLI Guide

The initialization step exposes the bridge CLI so you can do things like switch between combined and split mode, change proxy, etc. The [official guide](https://protonmail.com/support/knowledge-base/bridge-cli-guide/) gives more information on to use the CLI.

## Build

For anyone who want to build this container on your own (for development or security concerns), here is the guide to do so. First, you need to `cd` into the directory (`deb` or `build`, depending on which type of image you want). Then just run the docker build command

