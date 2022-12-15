#!/bin/bash
# fetches config from arena-services-docker and calls docker-compose
# usage: ./compose-from-arena-services.sh [docker-compose SUBCOMMAND: up, down, ...]

# read path to arena-services-docker from arena-services-folder.env if exists
[ -f "arena-services-folder.env" ] && source arena-services-folder.env

if [ -z "$ARENA_SERVICES_FOLDER" ]
then
    # assumes arena-services-folder is inside parent folder
    SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
    ARENA_SERVICES_FOLDER="$(dirname $SCRIPTPATH)/arena-services-docker"
fi 

# make sure arena-services-docker folder exists
if [ ! -d "$ARENA_SERVICES_FOLDER" ] || [ ! -f "$ARENA_SERVICES_FOLDER/.env" ] || [ ! -f "$ARENA_SERVICES_FOLDER/secret.env" ]
then
    echo "Could not find $ARENA_SERVICES_FOLDER (nor .env and secret.env inside)."
    echo "Please edit arena-services-folder.env with the full path to arena-services-docker."
    echo 'ARENA_SERVICES_FOLDER="full-path-to-arena-services-docker"' > arena-services-folder.env
    exit 1
fi 

# save path to arena-services-docker
echo "ARENA_SERVICES_FOLDER=$ARENA_SERVICES_FOLDER" > arena-services-folder.env

# load arena-services-docker env and secrets
source  $ARENA_SERVICES_FOLDER/.env 
source  $ARENA_SERVICES_FOLDER/secret.env

# define env based on config in arena-services-docker
# NOTE: values defined in shell take precedence over values in .env
export MQTT_SERVER=${MQTT_HOSTNAME}
export MQTT_SERVER_PORT=${MQTT_PORT}
export MQTT_WEBHOST=${HOSTNAME}
export MQTT_USER=arena_arts
export MQTT_PWD=${SERVICE_ARENA_ARTS_JWT}

docker-compose $@
