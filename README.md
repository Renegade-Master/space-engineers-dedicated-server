# Space Engineers Dedicated Server

## Disclaimer

**Note:** This image is not officially supported by Valve nor by Keen Software
House.

If issues are encountered, please report them on
the [GitHub repository](https://github.com/Renegade-Master/space-engineers-dedicated-server/issues/new/choose)

## Badges

[![Build and Test Server Image](https://github.com/Renegade-Master/space-engineers-dedicated-server/actions/workflows/docker-build.yml/badge.svg?branch=main)](https://github.com/Renegade-Master/space-engineers-dedicated-server/actions/workflows/docker-build.yml)
[![Docker Repository on Quay](https://quay.io/repository/renegade_master/space-engineers-dedicated-server/status "Docker Repository on Quay")](https://quay.io/repository/renegade_master/space-engineers-dedicated-server)

![Docker Image Version (latest by date)](https://img.shields.io/docker/v/renegademaster/space-engineers-dedicated-server?label=Latest%20Version)
![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/renegademaster/space-engineers-dedicated-server?label=Image%20Size)
![DockerHub Pulls](https://img.shields.io/docker/pulls/renegademaster/space-engineers-dedicated-server?label=DockerHub%20Pull%20Count)

## Description

SteamCMD-based Dedicated Server for Space Engineers by Keen Software House.  
Built almost from scratch to be the smallest Space Engineers Dedicated Server
around!

## Links

### Source:

- [GitHub Repository](https://github.com/Renegade-Master/space-engineers-dedicated-server)

### Images:

| Provider                                                                                                                               | Image                                                       | Pull Command                                                                                                                                                     |
|----------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [GitHub Packages](https://github.com/Renegade-Master/space-engineers-dedicated-server/pkgs/container/space-engineers-dedicated-server) | `ghcr.io/renegade-master/space-engineers-dedicated-server`  | `docker pull ghcr.io/renegade-master/space-engineers-dedicated-server:x.y.z`<br/>`docker pull ghcr.io/renegade-master/space-engineers-dedicated-server:latest`   |
| [DockerHub](https://hub.docker.com/r/renegademaster/space-engineers-dedicated-server)                                                  | `docker.io/renegademaster/space-engineers-dedicated-server` | `docker pull docker.io/renegademaster/space-engineers-dedicated-server:x.y.z`<br/>`docker pull docker.io/renegademaster/space-engineers-dedicated-server:latest` |
| [Red Hat Quay](https://quay.io/repository/renegade_master/space-engineers-dedicated-server)                                            | `quay.io/renegade_master/space-engineers-dedicated-server`  | `docker pull quay.io/renegade_master/space-engineers-dedicated-server:x.y.z`<br/>`docker pull quay.io/renegade_master/space-engineers-dedicated-server:latest`   |

### External Resources:

- [SteamCMD Wiki](https://developer.valvesoftware.com/wiki/SteamCMD)
- [Dedicated Server Wiki](https://www.spaceengineersgame.com/dedicated-servers/)
- [Fan Dedicated Server Wiki](https://spaceengineers.fandom.com/wiki/Setting_up_a_Space_Engineers_Dedicated_Server)

## Prerequisites

You must have the following resources available on the host selected to run this
Container:

* 4 GiB RAM
* 2x+ x86 Cores

You must have the following software available on the host selected to run this
Container:

* [Podman](https://podman.io/docs/installation)
  or [Docker](https://docs.docker.com/engine/install/)

**_Note_**: Podman and Docker can be used interchangeably for this image. I will
use Podman for the commands here, but they are the exact same for Docker. Simply
substitute the word `docker` where I have `podman` if you would rather use
Docker and Docker-Compose.

## Instructions

The server can be run using plain Docker, or using Docker-Compose. The
end-result is the same, but Docker-Compose is recommended for ease of
configuration.

_Optional arguments table_:

| Argument         | Description                                  | Values       | Default  |
|------------------|----------------------------------------------|--------------|----------|
| `NONE_YET_KNOWN` | THERE ARE CURRENTLY NO CONFIGURATION OPTIONS | [a-zA-Z0-9]+ | changeme |

### Podman

The following are instructions for running the server using the image.

1. Acquire the image locally:

    - Pull the image from DockerHub:

      ```shell
      podman pull docker.io/renegademaster/space-engineers-dedicated-server:<tag>
      ```

    - Or alternatively, build the image locally:

       ```shell
       git clone https://github.com/Renegade-Master/space-engineers-dedicated-server.git \
           && cd space-engineers-dedicated-server

       buildah bud --tag docker.io/renegademaster/space-engineers-dedicated-server:<tag> \
           --file docker/space-engineers-dedicated-server.Containerfile .
       ```

2. Run the container:

   ***Note**: Arguments inside square brackets are optional. If the default
   ports are to be overridden, then the
   `published` ports below must also be changed*

   ```shell
   podman volume create space-engineers-volume

   podman run --detach \
       --volume space-engineers-volume:/home/steam/se_install/ \
       --publish 27016:27016/udp \
       --name se-dedicated-server \
       [--env=NONE_YET_KNOWN=<value>] \
       docker.io/renegademaster/space-engineers-dedicated-server[:<tag>]
   ```

3. Optionally, reattach the terminal to the log output (***Note**: this
   is **not**
   an Interactive Terminal*)

   ```shell
   podman logs --follow se-dedicated-server
   ```

4. Once you see `<placeholder_initialisation_text>` in the console, people can
   start to join the server.
