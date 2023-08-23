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

ARG INSTALL_DIR="/tmp/packages/"
ARG WINEPREFIX="/usr/local/wineprefix/"

FROM ${BASE_IMAGE} AS INSTALL_WINE
ARG BASE_IMAGE_VERSION
ARG INSTALL_DIR

RUN dnf install --assumeyes 'dnf-command(config-manager)'
RUN dnf config-manager \
    --add-repo "https://dl.winehq.org/wine-builds/fedora/${BASE_IMAGE_VERSION}/winehq.repo"

RUN dnf install --assumeyes --releasever ${BASE_IMAGE_VERSION} --installroot "${INSTALL_DIR}" \
    filesystem bash winehq-stable

FROM ${BASE_IMAGE} AS INSTALL_WINETRICKS
ARG INSTALL_DIR
ARG WINEPREFIX

ENV WINEARCH="win64"
ENV WINEPREFIX="$WINEPREFIX"

WORKDIR ${INSTALL_DIR}

RUN dnf install --assumeyes \
      wget cabextract

RUN wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks \
    && chmod +x winetricks

COPY --from=INSTALL_WINE $INSTALL_DIR/ /

# Apply Winetricks
RUN ./winetricks -q vcrun2017
RUN ./winetricks -q vcrun2013
RUN ./winetricks -q --force dotnet48
RUN ./winetricks sound=disabled

FROM ${BASE_IMAGE} AS INSTALL_STEAM_DEPS
ARG BASE_IMAGE_VERSION
ARG INSTALL_DIR

RUN dnf install --assumeyes --releasever ${BASE_IMAGE_VERSION} --installroot "${INSTALL_DIR}" \
     glibc.i686 libstdc++.i686

FROM ${BASE_IMAGE} AS INSTALL_STEAM
ARG INSTALL_DIR

WORKDIR ${INSTALL_DIR}

RUN dnf install --assumeyes \
      wget

RUN wget "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" \
    && tar -zxf steamcmd_linux.tar.gz \
    && rm steamcmd_linux.tar.gz

FROM ${GO_IMAGE} AS GO_BUILD
ARG INSTALL_DIR

WORKDIR ${INSTALL_DIR}

COPY src/run_server.go .

RUN go build \
        -o build/ \
        run_server.go

FROM scratch AS RUNTIME
ARG INSTALL_DIR
ARG WINEPREFIX

ENV STEAM_DIR="/usr/local/games"
ENV WINTRICKS_DIR="/usr/local/winetricks"
ENV PATH="$STEAM_DIR:$WINTRICKS_DIR:$PATH"

ENV WINEARCH="win64"
ENV WINEPREFIX="$WINEPREFIX"

COPY --from=INSTALL_WINE       $INSTALL_DIR/       /
COPY --from=INSTALL_WINETRICKS $WINEPREFIX/        ${WINEPREFIX}
COPY --from=INSTALL_STEAM_DEPS $INSTALL_DIR/       /
COPY --from=INSTALL_STEAM      $INSTALL_DIR/       ${STEAM_DIR}
COPY --from=GO_BUILD           $INSTALL_DIR/build/ /usr/local/bin/

COPY src/install_server.scmd /app/

ENTRYPOINT [ "run_server" ]
