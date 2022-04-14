#!/bin/bash
set -e
IP_ADDRESS=$(hostname --ip-address)

# NEST environment
source /opt/nest/bin/nest_vars.sh

# Running NEST to test and to copy the .nestrc into /home/nest
nest --help

export MUSIC_ROOT_DIR=/opt/music-install
export MUSIC_ROOT=${MUSIC_ROOT_DIR}
MUSIC_PATH=${MUSIC_ROOT_DIR}
export LD_LIBRARY_PATH=${MUSIC_PATH}/lib:$LD_LIBRARY_PATH
export PATH=${MUSIC_PATH}/bin:$PATH
export CPATH=${MUSIC_PATH}/include:$CPATH
export PYTHONPATH=${MUSIC_PATH}/lib/python3.8/site-packages:$PYTHONPATH

export PATH="$PATH:/usr/local/bin"

MODE="${NEST_CONTAINER_MODE:-$1}"
if [[ "${MODE}" = 'interactive' ]]; then
    read -p "Your python script: " name
    echo Starting: $name
    # Start
    mkdir -p /opt/data; cd /opt/data
    exec python3 /opt/data/$name

elif [[ "${MODE}" = 'jupyterlab' ]]; then
    mkdir -p /opt/data; cd /opt/data
    exec /usr/local/bin/jupyter-lab --ip="${IP_ADDRESS}" --port=8080 --no-browser --allow-root

elif [[ "${MODE}" = 'nest-desktop' ]]; then
    exec /usr/local/bin/nest-desktop start -h 0.0.0.0 -p 8000

elif [[ "${MODE}" = 'nest-server' ]]; then
    export NEST_SERVER_BUFFER_SIZE="${NEST_SERVER_BUFFER_SIZE:-65535}"
    export NEST_SERVER_HOST="${NEST_SERVER_HOST:-0.0.0.0}"
    export NEST_SERVER_MODULES="${NEST_SERVER_MODULES:-nest,numpy}"
    export NEST_SERVER_RESTRICTION_OFF="${NEST_SERVER_RESTRICTION_OFF:-true}"
    export NEST_SERVER_STDOUT="${NEST_SERVER_STDOUT:-1}"
    exec nest-server start

elif [[ "${MODE}" = 'notebook' ]]; then
    mkdir -p /opt/data; cd /opt/data
    exec jupyter-notebook --ip="${IP_ADDRESS}" --port=8080 --no-browser --allow-root

else
    exec "$@"
fi
