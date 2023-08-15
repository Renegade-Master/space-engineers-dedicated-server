# Space Engineers Dedicated Server Docker Image.
# Copyright (C) 2022-2023 Renegade-Master [renegade.master.dev@protonmail.com]
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#

#######################################################################
#   Author: Renegade-Master
#   Description: Base image for running a Space Engineers Dedicated
#       Server instance.
#   License: GNU General Public License v3.0 (see LICENSE)
#######################################################################

ARG BASE_IMAGE_PATH="docker.io/fedora"
ARG BASE_IMAGE_VERSION="38"
ARG BASE_IMAGE="${BASE_IMAGE_PATH}:${BASE_IMAGE_VERSION}"

ARG GO_IMAGE_PATH="docker.io/golang"
ARG GO_IMAGE_VERSION="1.21.0"
ARG GO_IMAGE="${GO_IMAGE_PATH}:${GO_IMAGE_VERSION}"

FROM ${BASE_IMAGE} AS INSTALL_WINE
ARG BASE_IMAGE_VERSION

ARG INSTALL_DIR="/tmp/packages/"

RUN dnf install --assumeyes 'dnf-command(config-manager)'
RUN dnf config-manager \
    --add-repo "https://dl.winehq.org/wine-builds/fedora/${BASE_IMAGE_VERSION}/winehq.repo"

RUN dnf install --assumeyes --releasever ${BASE_IMAGE_VERSION} --installroot "${INSTALL_DIR}" \
    filesystem bash winehq-stable

FROM ${BASE_IMAGE} AS INSTALL_STEAM_DEPS
ARG BASE_IMAGE_VERSION

ARG INSTALL_DIR="/tmp/packages/"

RUN dnf install --assumeyes --releasever ${BASE_IMAGE_VERSION} --installroot "${INSTALL_DIR}" \
     glibc.i686 libstdc++.i686

FROM ${BASE_IMAGE} AS INSTALL_STEAM

ARG INSTALL_DIR="/tmp/packages/"

WORKDIR ${INSTALL_DIR}

RUN dnf install --assumeyes \
      wget

RUN wget "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" \
    && tar -zxf steamcmd_linux.tar.gz \
    && rm steamcmd_linux.tar.gz

FROM ${GO_IMAGE} AS GO_BUILD

ARG INSTALL_DIR="/tmp/packages/"

WORKDIR ${INSTALL_DIR}

COPY src/run_server.go .

RUN go build \
        -o build/ \
        run_server.go

FROM scratch AS RUNTIME

ENV STEAMDIR="/usr/local/games"
ENV PATH="$STEAMDIR:$PATH"

COPY --from=INSTALL_WINE /tmp/packages/ /
COPY --from=INSTALL_STEAM_DEPS /tmp/packages/ /
COPY --from=INSTALL_STEAM /tmp/packages/ ${STEAMDIR}
COPY --from=GO_BUILD /tmp/packages/build/ /usr/local/bin/

ENTRYPOINT [ "steamcmd.sh", "--help" ]