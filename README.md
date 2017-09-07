# Docker image for the NEST simulator (v2.12.0)

The dockerfile builds an image with a basic shell environment with 
Python 2.7 and [NEST 2.12.0](https://github.com/nest/nest-simulator) with 
OpenMPI, matplotlib, Scipy, MUSIC and libneurosim.

## Getting the repository

    git clone https://github.com/steffengraber/nest-docker.git

## Creating the docker image

    cd nest-docker
    docker build -t nest/docker-nest-2.12 .

## Starting

    docker run --user nest -it nest/docker-nest-2.12 /bin/bash
    
## Sharing files with host machine

    # Replace YOURPYFOLDER with the folder on our host.
    # /home/nest/data is the folder in the docker
    
    docker run --user nest -v ~/YOURPYFOLDER:/home/nest/data \
      -it nest/docker-nest-2.12 /bin/bash

    
## First steps

    python
    >>> import nest
    >>> nest.help()


