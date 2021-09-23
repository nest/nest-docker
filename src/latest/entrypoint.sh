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
export NEST_SERVER_RESTRICTION_OFF=true
export NEST_SERVER_MODULES=nest,numpy

if [[ ! -d /opt/data ]]; then
    mkdir /opt/data
fi

if [[ "$1" = 'notebook' ]]; then
    cd /opt/data
    exec jupyter-notebook --ip="${IP_ADDRESS}" --port=8080 --no-browser --allow-root
fi

if [[ "$1" = 'nest-server' ]]; then
    cd /opt/data
    exec nest-server start -o -h 0.0.0.0 -p 5000 -u 65534
fi

if [[ "$1" = 'nest-desktop' ]]; then
    cd /opt/data
    exec /root/.local/bin/nest-desktop start
fi

if [[ "$1" = 'interactive' ]]; then
    read -p "Your python script: " name
    echo Starting: $name
    cd /opt/data
    # Start
    exec python3 /opt/data/$name
fi

cd /opt/data
exec "$@"
