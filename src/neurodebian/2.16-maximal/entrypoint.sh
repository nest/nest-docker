#!/bin/bash
set -e

# NEST environment
source /opt/nest/bin/nest_vars.sh


if [ "$1" = 'notebook' ]; then
    exec jupyter notebook --ip="*" --port=8080 --no-browser
fi

if [ "$1" = 'interactive' ]; then
    read -p "Your python script: " name
	echo Starting: $name

	# Start
	exec python3 /home/nest/data/$name
fi

exec "$@"
