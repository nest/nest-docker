#!/bin/bash
set -e

USER_ID=${LOCAL_USER_ID:-9001}

echo "UID : $USER_ID"
adduser --disabled-login --gecos 'NEST' --uid $USER_ID --home /home/nest nest
export HOME=/home/nest

echo '. /opt/nest/bin/nest_vars.sh' >> /home/nest/.bashrc


# NEST environment
source /opt/nest/bin/nest_vars.sh
if [[ ! -d /opt/data ]]; then
	mkdir /opt/data
	chown -R nest:nest /opt/data
fi

if [[ "$1" = 'notebook' ]]; then
    cd /opt/data
    exec gosu nest jupyter-notebook --ip="*" --port=8080 --no-browser
fi

if [[ "$1" = 'interactive' ]]; then
    read -p "Your python script: " name
	echo Starting: $name
	cd /opt/data
	# Start
	exec gosu nest python3 /opt/data/$name
fi

cd /opt/data
exec gosu nest "$@"
