#!/bin/bash

# load NEST environment (cannot pickup the nest module otherwise)
source /opt/nest/bin/nest_vars.sh

# start NEST Server in debug mode
USER=nest nest-server start -h 0.0.0.0 -o
