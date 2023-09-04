#!/usr/bin/env bash

# Space Engineers Dedicated Server Docker Image.
# Copyright (C) 2022-2022 Renegade-Master [renegade.master.dev@protonmail.com]
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
#   Description: Install, update, and start a Space Engineers Dedicated
#     Server instance.
#   License: GNU General Public License v3.0 (see LICENSE)
#######################################################################

# Set to `-x` for Debug logging
set +x -u -o pipefail

# Apply Winetricks
Xvfb :5 -screen 0 1024x768x16 &

wineboot --init /nogui

./winetricks corefonts
./winetricks -q vcrun2013
./winetricks -q vcrun2019
./winetricks -q --force dotnet48
./winetricks sound=disabled
