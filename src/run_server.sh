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

# Start the Server
function start_server() {
    printf "\n### Starting Space Engineers Server...\n"
    timeout "$TIMEOUT" "$BASE_GAME_DIR"/start-server.sh \
        -adminusername "$ADMIN_USERNAME" \
        -adminpassword "$ADMIN_PASSWORD" \
        -ip "$BIND_IP" -port "$QUERY_PORT" \
        -servername "$SERVER_NAME"
}


function apply_postinstall_config() {
    printf "\n### Applying Post Install Configuration...\n"

    # Set the Max Players
    sed -i "s/MaxPlayers=.*/MaxPlayers=$MAX_PLAYERS/g" "$SERVER_CONFIG"

    # Set the maximum amount of RAM for the JVM
    sed -i "s/-Xmx.*/-Xmx$MAX_RAM\",/g" "$SERVER_VM_CONFIG"

    # Set the Mod names
    sed -i "s/Mods=.*/Mods=$MOD_NAMES/g" "$SERVER_CONFIG"

    # Set the Server Publicity status
    sed -i "s/Open=.*/Open=$PUBLIC_SERVER/g" "$SERVER_CONFIG"

    # Set the Server query Port
    sed -i "s/DefaultPort=.*/DefaultPort=$QUERY_PORT/g" "$SERVER_CONFIG"

    # Set the Server Name
    sed -i "s/PublicName=.*/PublicName=$SERVER_NAME/g" "$SERVER_CONFIG"

    # Set the Server Password
    sed -i "s/Password=.*/Password=$SERVER_PASSWORD/g" "$SERVER_CONFIG"

    printf "\n### Post Install Configuration applied.\n"
}


# Test if this is the the first time the server has run
function test_first_run() {
    printf "\n### Checking if this is the first run...\n"

    if [[ ! -f "$SERVER_CONFIG" ]] || [[ ! -f "$SERVER_RULES_CONFIG" ]]; then
        printf "\n### This is the first run.\nStarting server for %s seconds\n" "$TIMEOUT"
        start_server
        TIMEOUT=0
    else
        printf "\n### This is not the first run.\n"
        TIMEOUT=0
    fi

    printf "\n### First run check complete.\n"
}


# Update the server
function update_server() {
    printf "\n### Updating Space Engineers Server...\n"

    install_success=1
    retries=0

    # Try at most MAX_RETRIES times to install the server
    while [[ "$install_success" -ne 0 ]] && [[ "$retries" -lt "$MAX_RETRIES" ]]; do
        printf "\n### Attempt %s to update Space Engineers Server...\n" "$((retries + 1))"

        # Redirect subshell output to STDOUT using a File Descriptor
        exec 3>&1

        # Attempt to update the server
        steam_output=$(steamcmd.sh +runscript "$STEAM_INSTALL_FILE" | tee /dev/fd/3)

        # Close the File Descriptor
        exec 3>&-

        install_success=0

        # Check if the update was successful
#        if [[ $steam_output == *"<placeholder_initialisation_text>"* ]]; then
#            install_success=0
#        else
#            retries=$((retries + 1))
#        fi
    done

    # Exit is the installation was unsuccessful
    if [[ "$install_success" -ne 0 ]]; then
        printf "\n### Failed to update Space Engineers Server.\n"
        exit 1
    fi

    printf "\n### Space Engineers Server updated.\n"
}


# Apply user configuration to the server
function apply_preinstall_config() {
    printf "\n### Applying Pre Install Configuration...\n"

    # Set the selected game version
    sed -i "s/beta .* /beta $GAME_VERSION /g" "$STEAM_INSTALL_FILE"

    printf "\n### Pre Install Configuration applied.\n"
}


# Set variables for use in the script
function set_variables() {
    printf "\n### Setting variables...\n"

    TIMEOUT="60"
    MAX_RETRIES="5"
    STEAM_INSTALL_FILE="/home/steam/install_server.scmd"
    BASE_GAME_DIR="/home/steam/se_install"
    CONFIG_DIR="/home/steam/REPLACE_ME_CONFIG"

    # Set the Server Admin Password variable
    ADMIN_USERNAME=${ADMIN_USERNAME:-"admin"}

    # Set the Server Admin Password variable
    ADMIN_PASSWORD=${ADMIN_PASSWORD:-"changeme"}

    # Set the IP address variable
    BIND_IP=${BIND_IP:-"0.0.0.0"}

    # Set the IP Game Port variable
    GAME_PORT=${GAME_PORT:-"8766"}

    # Set the game version variable
    GAME_VERSION=${GAME_VERSION:-"public"}

    # Set the Max Players variable
    MAX_PLAYERS=${MAX_PLAYERS:-"16"}

    # Set the Maximum RAM variable
    MAX_RAM=${MAX_RAM:-"4096m"}

    # Set the Mods to use from workshop
    MOD_NAMES=${MOD_NAMES:-""}

    # Set the Server Publicity variable
    PUBLIC_SERVER=${PUBLIC_SERVER:-"true"}

    # Set the IP Query Port variable
    QUERY_PORT=${QUERY_PORT:-"16261"}

    # Set the Server name variable
    SERVER_NAME=${SERVER_NAME:-"DedicatedServer"}

    # Set the Server Password variable
    SERVER_PASSWORD=${SERVER_PASSWORD:-""}

    SERVER_CONFIG="$CONFIG_DIR/Server/Config.ini"
    SERVER_RULES_CONFIG="$CONFIG_DIR/Server/GameRules.ini"
}


## Main
set_variables
apply_preinstall_config
update_server
#test_first_run
#apply_postinstall_config
#start_server
