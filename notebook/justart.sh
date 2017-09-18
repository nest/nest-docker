#!/usr/bin/env bash

# NEST environment
source /home/nest/nest-install/bin/nest_vars.sh

# Starting jupyter
jupyter notebook --ip="*" --port=8080 --no-browser
