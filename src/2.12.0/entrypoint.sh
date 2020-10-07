#!/bin/bash
set -e

IP_ADDRESS=$(hostname --ip-address)
USER_ID=${LOCAL_USER_ID:-9001}

if [[ ! $(id -u nest) = $USER_ID ]]; then
	echo "UID : $USER_ID"
	adduser --disabled-login --gecos 'NEST' --uid $USER_ID --home /home/nest nest
	export HOME=/home/nest
fi
echo '. /opt/nest/bin/nest_vars.sh' >> /home/nest/.bashrc

# NEST environment
source /opt/nest/bin/nest_vars.sh

# Running NEST to test and to copy the .nestrc into /home/nest
nest --help
chown nest:nest /home/nest/.nestrc

if [[ ! -d /opt/data ]]; then
	mkdir /opt/data
	chown -R nest:nest /opt/data
fi

if [[ "$1" = 'notebook' ]]; then
    cd /opt/data
    exec gosu nest jupyter-notebook --ip="${IP_ADDRESS}" --port=8080 --no-browser
fi

if [[ "$1" = 'interactive' ]]; then
    read -p "Your python script: " name
	echo Starting: $name
	cd /opt/data
	# Start
	exec gosu nest python /opt/data/$name
fi

exec gosu nest "$@"
