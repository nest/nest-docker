#!/bin/bash
set -e
IP_ADDRESS=$(hostname --ip-address)

# Python environment
source /root/.env/bin/activate

# NEST environment
#source /opt/nest/bin/nest_vars.sh

# Running NEST to test and to copy the .nestrc into /home/nest
nest --help
echo "NEST version: "
python3 -c "import nest" | grep "Version:"

export MUSIC_ROOT_DIR='$HOME/.cache/music.install'
export MUSIC_ROOT=${MUSIC_ROOT_DIR}
MUSIC_PATH=${MUSIC_ROOT_DIR}
export PATH=${MUSIC_PATH}/bin:$PATH
export CPATH=${MUSIC_PATH}/include:$CPATH
export PYTHONPATH=${MUSIC_PATH}/lib/python3.12/site-packages:$PYTHONPATH

export NESTML_MODULES_PATH=${NESTML_MODULES_PATH:-/tmp/nestmlmodules}

# Set LD_LIBRARY_PATH for music and nestml modules
export LD_LIBRARY_PATH=${MUSIC_PATH}/lib:${NESTML_MODULES_PATH}:$LD_LIBRARY_PATH

MODE="${NEST_CONTAINER_MODE:-$1}"
if [[ "${MODE}" = 'interactive' ]]; then
    read -p "Your python script: " name
    echo Starting: $name
    # Start
    mkdir -p /opt/data; cd /opt/data
    exec python3 /opt/data/$name

elif [[ "${MODE}" = 'jupyterlab' ]]; then
    mkdir -p /opt/data; cd /opt/data
    exec /root/.env/bin/jupyter-lab --ip="${IP_ADDRESS}" --port=8080 --no-browser --allow-root

elif [[ "${MODE}" = 'nest-desktop' ]]; then
    export NEST_DESKTOP_HOST="${NEST_DESKTOP_HOST:-0.0.0.0}"
    export NEST_DESKTOP_PORT="${NEST_DESKTOP_PORT:-54286}"
    exec nest-desktop start

elif [[ "${MODE}" = 'nest-server' ]]; then
    export NEST_SERVER_HOST="${NEST_SERVER_HOST:-0.0.0.0}"
    export NEST_SERVER_PORT="${NEST_SERVER_PORT:-52425}"
    export NEST_SERVER_STDOUT="${NEST_SERVER_STDOUT:-1}"

    export NEST_SERVER_ACCESS_TOKEN="${NEST_SERVER_ACCESS_TOKEN}"
    export NEST_SERVER_CORS_ORIGINS="${NEST_SERVER_CORS_ORIGINS:-*}"
    export NEST_SERVER_DISABLE_AUTH="${NEST_SERVER_DISABLE_AUTH:-1}"
    export NEST_SERVER_DISABLE_RESTRICTION="${NEST_SERVER_DISABLE_RESTRICTION:-1}"
    export NEST_SERVER_ENABLE_EXEC_CALL="${NEST_SERVER_ENABLE_EXEC_CALL:-1}"
    export NEST_SERVER_MODULES="${NEST_SERVER_MODULES:-import nest; import numpy; import numpy as np}"
    exec nest-server start

elif [[ "${MODE}" = 'nest-server-mpi' ]]; then
    export NEST_SERVER_HOST="${NEST_SERVER_HOST:-0.0.0.0}"
    export NEST_SERVER_PORT="${NEST_SERVER_PORT:-52425}"

    export NEST_SERVER_ACCESS_TOKEN="${NEST_SERVER_ACCESS_TOKEN}"
    export NEST_SERVER_CORS_ORIGINS="${NEST_SERVER_CORS_ORIGINS:-*}"
    export NEST_SERVER_DISABLE_AUTH="${NEST_SERVER_DISABLE_AUTH:-1}"
    export NEST_SERVER_DISABLE_RESTRICTION="${NEST_SERVER_DISABLE_RESTRICTION:-1}"
    export NEST_SERVER_ENABLE_EXEC_CALL="${NEST_SERVER_ENABLE_EXEC_CALL:-1}"
    export NEST_SERVER_MODULES="${NEST_SERVER_MODULES:-import nest; import numpy; import numpy as np}"
    exec mpirun -np "${NEST_SERVER_MPI_NUM:-1}" nest-server-mpi --host "${NEST_SERVER_HOST}" --port "${NEST_SERVER_PORT}"


elif [[ "${MODE}" = 'nestml-server' ]]; then
    export NESTML_SERVER_HOST="${NESTML_SERVER_HOST:-0.0.0.0}"
    export NESTML_SERVER_PORT="${NESTML_SERVER_PORT:-52426}"
    export NESTML_SERVER_STDOUT="${NESTML_SERVER_STDOUT:-1}"
    exec nestml-server start

elif [[ "${MODE}" = 'notebook' ]]; then
    mkdir -p /opt/data; cd /opt/data
    exec /root/.env/bin/jupyter-notebook --ip="${IP_ADDRESS}" --port=8080 --no-browser --allow-root

else
    exec "$@"
fi
