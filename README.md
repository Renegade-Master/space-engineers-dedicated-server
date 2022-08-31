# SteamCMD Dedicated Server Template

## Disclaimer

**Note:** This image is not officially supported by Valve.

If issues are encountered, please report them on
the [GitHub repository](https://github.com/Renegade-Master/steamcmd-dedicated-server-template/issues/new/choose)

## Badges

[![Build and Test Server Image](https://github.com/Renegade-Master/steamcmd-dedicated-server-template/actions/workflows/docker-build.yml/badge.svg?branch=main)](https://github.com/Renegade-Master/steamcmd-dedicated-server-template/actions/workflows/docker-build.yml)
[![Docker Repository on Quay](https://quay.io/repository/renegade_master/steamcmd-dedicated-server-template/status "Docker Repository on Quay")](https://quay.io/repository/renegade_master/steamcmd-dedicated-server-template)

![Docker Image Version (latest by date)](https://img.shields.io/docker/v/renegademaster/steamcmd-dedicated-server-template?label=Latest%20Version)
![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/renegademaster/steamcmd-dedicated-server-template?label=Image%20Size)
![DockerHub Pulls](https://img.shields.io/docker/pulls/renegademaster/steamcmd-dedicated-server-template?label=DockerHub%20Pull%20Count)

## Description

Template for creating SteamCMD Dedicated Servers using Docker, and optionally Docker-Compose.  
Built almost from scratch to be the smallest SteamCMD Dedicated Server around!

This template was constructed based on
the [Steamcmd Dedicated Server Template](https://github.com/Renegade-Master/steamcmd-dedicated-server-template)
image, and there may be some holdovers specific to that implementation.

## Links

### Source:

- [GitHub Repository](https://github.com/Renegade-Master/steamcmd-dedicated-server-template)

### Images:

| Provider                                                                                                                                   | Image                                                         | Pull Command                                                                                                                                                         |
|--------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [GitHub Packages](https://github.com/Renegade-Master/steamcmd-dedicated-server-template/pkgs/container/steamcmd-dedicated-server-template) | `ghcr.io/renegade-master/steamcmd-dedicated-server-template`  | `docker pull ghcr.io/renegade-master/steamcmd-dedicated-server-template:x.y.z`<br/>`docker pull ghcr.io/renegade-master/steamcmd-dedicated-server-template:latest`   |
| [DockerHub](https://hub.docker.com/r/renegademaster/steamcmd-dedicated-server-template)                                                    | `docker.io/renegademaster/steamcmd-dedicated-server-template` | `docker pull docker.io/renegademaster/steamcmd-dedicated-server-template:x.y.z`<br/>`docker pull docker.io/renegademaster/steamcmd-dedicated-server-template:latest` |
| [Red Hat Quay](https://quay.io/repository/renegade_master/steamcmd-dedicated-server-template)                                              | `quay.io/renegade_master/steamcmd-dedicated-server-template`  | `docker pull quay.io/renegade_master/steamcmd-dedicated-server-template:x.y.z`<br/>`docker pull quay.io/renegade_master/steamcmd-dedicated-server-template:latest`   |

### External Resources:

- [Dedicated Server Wiki](https://developer.valvesoftware.com/wiki/SteamCMD)

## Prerequisites

## Instructions

The server can be run using plain Docker, or using Docker-Compose. The end-result is the same, but Docker-Compose is
recommended for ease of configuration.

_Optional arguments table_:

| Argument          | Description                                                            | Values            | Default         |
|-------------------|------------------------------------------------------------------------|-------------------|-----------------|
| `ADMIN_PASSWORD`  | Server Admin account password                                          | [a-zA-Z0-9]+      | changeme        |
| `ADMIN_USERNAME`  | Server Admin account username                                          | [a-zA-Z0-9]+      | superuser       |
| `BIND_IP`         | IP to bind the server to                                               | 0.0.0.0           | 0.0.0.0         |
| `GAME_PORT`       | Port for sending game data to clients                                  | 1000 - 65535      | 8766            |
| `GAME_VERSION`    | Game version to serve                                                  | [a-zA-Z0-9_]+     | `public`        |
| `MAX_PLAYERS`     | Maximum players allowed in the Server                                  | [0-9]+            | 16              |
| `MAX_RAM`         | Maximum amount of RAM to be used                                       | ([0-9]+)m         | 4096m           |
| `PUBLIC_SERVER`   | If set to `true` only Pre-Approved/Allowed players can join the server | (true&vert;false) | true            |
| `QUERY_PORT`      | Port for other players to connect to                                   | 1000 - 65535      | 16261           |
| `RCON_PASSWORD`   | Password for authenticating incoming RCON commands                     | [a-zA-Z0-9]+      | changeme_rcon   |
| `RCON_PORT`       | Port to listen on for RCON commands                                    | (true&vert;false) | 27015           |
| `SERVER_NAME`     | Publicly visible Server Name                                           | [a-zA-Z0-9]+      | DedicatedServer |
| `SERVER_PASSWORD` | Server password                                                        | [a-zA-Z0-9]+      |                 |

### Docker

The following are instructions for running the server using the Docker image.

1. Acquire the image locally:

    - Pull the image from DockerHub:

      ```shell
      docker pull renegademaster/steamcmd-dedicated-server-template:<tagname>
      ```

    - Or alternatively, build the image:

       ```shell
       git clone https://github.com/Renegade-Master/steamcmd-dedicated-server-template.git \
           && cd steamcmd-dedicated-server-template
  
       docker build -t docker.io/renegademaster/steamcmd-dedicated-server-template:<tag> -f docker/steamcmd-dedicated-server-template.Dockerfile .
       ```

2. Run the container:

   ***Note**: Arguments inside square brackets are optional. If the default ports are to be overridden, then the
   `published` ports below must also be changed*

   ```shell
   mkdir REPLACE_ME_CONFIG REPLACE_ME_INSTALL

   docker run --detach \
       --mount type=bind,source="$(pwd)/REPLACE_ME_INSTALL",target=/home/steam/REPLACE_ME_INSTALL \
       --mount type=bind,source="$(pwd)/REPLACE_ME_CONFIG",target=/home/steam/REPLACE_ME_CONFIG \
       --publish 16261:16261/udp --publish 8766:8766/udp \
       --name dedicated-server \
       [--env=ADMIN_PASSWORD=<value>] \
       [--env=ADMIN_USERNAME=<value>] \
       [--env=BIND_IP=<value>] \
       [--env=GAME_PORT=<value>] \
       [--env=GAME_VERSION=<value>] \
       [--env=MAX_PLAYERS=<value>] \
       [--env=MAX_RAM=<value>] \
       [--env=PUBLIC_SERVER=<value>] \
       [--env=QUERY_PORT=<value>] \
       [--env=RCON_PASSWORD=<value>] \
       [--env=RCON_PORT=<value>] \
       [--env=SERVER_NAME=<value>] \
       [--env=SERVER_PASSWORD=<value>] \
       docker.io/renegademaster/steamcmd-dedicated-server-template[:<tagname>]
   ```

3. Optionally, reattach the terminal to the log output (***Note**: this is not an Interactive Terminal*)

   ```shell
   docker logs --follow dedicated-server
   ```

4. Once you see `<placeholder_initialisation_text>` in the console, people can start to join the server.

### Docker-Compose

The following are instructions for running the server using Docker-Compose.

1. Download the repository:

   ```shell
   git clone https://github.com/Renegade-Master/steamcmd-dedicated-server-template.git \
       && cd steamcmd-dedicated-server-template
   ```

2. Make any configuration changes you want to in the `docker-compose.yaml` file. In
   the `services.server.environment` section, you can change values for the server configuration.

   ***Note**: If the default ports are to be overridden, then the `published` ports must also be changed*

3. Run the following commands:

    - Make the data and configuration directories:

      ```shell
      mkdir REPLACE_ME_CONFIG REPLACE_ME_INSTALL
      ```

    - Pull the image from DockerHub:

      ```shell
      docker-compose up --detach
      ```

    - Or alternatively, build the image:

      ```shell
      docker-compose up --build --detach
      ```

4. Optionally, reattach the terminal to the log output (***Note**: this is not an Interactive Terminal*)

   ```shell
   docker-compose logs --follow
   ```

5. Once you see `<placeholder_initialisation_text>` in the console, people can start to join the server.
