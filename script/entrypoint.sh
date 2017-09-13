#!/bin/bash
set -e

	read -p "Your python script: " name
	echo Starting: $name

	# NEST environment
	source /home/nest/nest-install/bin/nest_vars.sh

	# Start
	/usr/bin/python /home/nest/data/$name

