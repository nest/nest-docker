#!/bin/bash
set -e
IP_ADDRESS=$(hostname --ip-address)

# NEST environment
source /opt/nest/bin/nest_vars.sh

MODE="${NEST_CONTAINER_MODE:-$1}"
if [[ "${MODE}" = 'interactive' ]]; then
    read -p "Your python script: " name
    echo Starting: $name
    mkdir -p /opt/data; cd /opt/data
    exec python3 /opt/data/$name

elif [[ "${MODE}" = 'notebook' ]]; then
    mkdir -p /opt/data; cd /opt/data
    exec jupyter notebook --ip="${IP_ADDRESS}" --port=8080 --no-browser --allow-root

else
    exec "$@"
fi
