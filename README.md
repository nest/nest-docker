# Docker image for the NEST simulator

[![Docker Hub](https://img.shields.io/badge/Docker%20Hub-nest--simulator-blue?logo=docker)](https://hub.docker.com/r/nest/nest-simulator)
[![NEST Simulator](https://img.shields.io/badge/NEST-Simulator-green?logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==)](https://www.nest-simulator.org/)
[![License: GPL v2](https://img.shields.io/badge/License-GPL%20v2-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)
[![Latest Version](https://img.shields.io/badge/Latest-v3.9-brightgreen)](https://github.com/nest/nest-docker)

## Table of Contents

- [What is it for?](#what-is-it-for)
- [Quick Start](#quick-start)
- [Usage](#usage)
  - [NEST 2.20.2](#nest-2202)
  - [NEST 3.9](#nest-39)
  - [NEST dev](#nest-dev)
  - [On Windows](#on-windows)
- [Local Build System (run.sh)](#usage-of-the-local-build-system-runsh)
  - [Quick Reference](#quick-reference)
  - [Step-by-Step Guide](#1---2---3)
- [Using NEST with MUSIC](#using-nest-with-music)
- [Useful Docker commands](#useful-docker-commands)
- [Publishing to Registry](#add-image-to-ebrans-registry)

## What is it for?

**If you know how to use Docker, you know how to use NEST.**

This repository provides Docker images for the [NEST simulator](https://www.nest-simulator.org/), making it easy to run NEST simulations without complex installation procedures. Whether you're a researcher, student, or developer, these Docker images provide:

- ✅ **Zero-installation experience** - No dependency management headaches
- ✅ **Consistent environment** - Same setup across different systems  
- ✅ **Multiple interfaces** - Jupyter notebooks, JupyterLab, or interactive shell
- ✅ **Latest versions** - From legacy 2.x to cutting-edge development builds
- ✅ **NEST Desktop integration** - Full graphical interface support

### Available Docker Images

Currently the following docker images are provided

    - nest/nest-simulator:dev
    - nest/nest-simulator:2.20.2
    - nest/nest-simulator:3.0
    - nest/nest-simulator:3.1
    - nest/nest-simulator:3.2
    - nest/nest-simulator:3.3
    - nest/nest-simulator:3.4
    - nest/nest-simulator:3.5
    - nest/nest-simulator:3.6
    - nest/nest-simulator:3.7
    - nest/nest-simulator:3.8
    - nest/nest-simulator:3.9

## Quick Start

**🚀 Get started in 30 seconds:**

1. **Pull the latest NEST image:**
   ```bash
   docker pull nest/nest-simulator:3.9
   ```

2. **Start Jupyter Notebook:**
   ```bash
   docker run -it --rm -e LOCAL_USER_ID=`id -u $USER` -v $(pwd):/opt/data \
              -e NEST_CONTAINER_MODE=notebook -p 8080:8080 nest/nest-simulator:3.9
   ```

3. **Open your browser** to the displayed URL and start exploring NEST!

**🛠️ For local development with build tools:**

```bash
git clone https://github.com/nest/nest-docker.git
cd nest-docker
./run.sh list                    # See all available options
./run.sh run notebook 3.9        # Start notebook with NEST 3.9
```

## Usage

You can use the docker images directly from docker-registry.ebrains.eu like this:

    docker pull nest/nest-simulator:TAG

TAG is '2.20.2', '3.2', '3.3', '3.4', '3.5', '3.6', '3.7', '3.8', '3.9' or 'dev'.

#### NEST 2.20.2

Jupyter notebook with NEST 2.20.2:

    docker run -it --rm -e LOCAL_USER_ID=`id -u $USER` -v $(pwd):/opt/data -e NEST_CONTAINER_MODE=notebook \
               -p 8080:8080 nest/nest-simulator:2.20.2

JupyterLab with NEST 2.20.2:

    docker run -it --rm -e LOCAL_USER_ID=`id -u $USER` -v $(pwd):/opt/data -e NEST_CONTAINER_MODE=jupyterlab \
               -p 8080:8080 nest/nest-simulator:2.20.2

#### NEST 3.9

To use 'docker-compose' you need the definition file from the git repository. Download it:

    wget https://raw.githubusercontent.com/nest/nest-docker/master/docker-compose.yml

- NEST Server

      docker-compose up nest-server

  or

      docker run -it --rm -e NEST_CONTAINER_MODE=nest-server -p 52425:52425 \
           nest/nest-simulator:3.9

  Starts the NEST API server container and opens the corresponding port 52425. Test it with `curl localhost:52425/api`.

- NEST Desktop

      docker-compose up nest-desktop

  or

      docker run -it --rm -e NEST_CONTAINER_MODE=nest-server -p 52425:52425 \
          nest/nest-simulator:3.9
      docker run -it --rm -e LOCAL_USER_ID=`id -u $USER` -p 54286:54286  \
          -e NEST_CONTAINER_MODE=nest-desktop nest/nest-simulator:3.9

  Starts the NEST server and the NEST desktop web interface. Port 54286 is also made available.
  Open in the web browser: `http://localhost:54286`

- Jupyter notebook with NEST

      docker-compose up nest-notebook

  or

      docker run -it --rm -e LOCAL_USER_ID=`id -u $USER` -v $(pwd):/opt/data -e NEST_CONTAINER_MODE=notebook \
          -p 8080:8080 nest/nest-simulator:3.9

  Starts a notebook server with pre-installed NEST 3.9. The corresponding URL is displayed in the console.

- JupyterLab with NEST

      docker-compose up nest-jupyterlab

  or

      docker run -it --rm -e LOCAL_USER_ID=`id -u $USER` -v $(pwd):/opt/data -e NEST_CONTAINER_MODE=jupyterlab \
          -p 8080:8080 nest/nest-simulator:3.9

  Starts a JupyterLab server with pre-installed NEST 3.9. The corresponding URL is displayed in the console.

To stop and delete running containers use `docker-compose down`.

#### NEST dev

If you want to use the compose configuration for the dev NEST version, use the file option, e.g.:

    wget https://raw.githubusercontent.com/steffengraber/nest-docker/master/docker-compose.yml
    docker-compose -f docker-compose-dev.yml up nest-notebook

### On Windows

e.g.:

    docker run -it --rm -v %cd%:/opt/data -p 8080:8080 -e NEST_CONTAINER_MODE=<args> \
        nest/nest-simulator:<version>

In Powershell, '%cd%' might not work for the current directory. Then
you should explicitly specify a folder with existing write permissions.

In any case, this will download the docker image with the pre-installed
NEST master from docker-registry.ebrains.eu and start it. After booting, a URL is presented.
Click on it or copy it to your browser. Voilà! Jupyter notebook starts from
the docker image.

You can update the image with:

    docker pull nest/nest-simulator:<version>

## Usage of the local build system (run.sh)

You can clone this repository and use the shell script:                        

    sh run.sh [--help] <command> [<args>] [<version>]

    --help      print this usage information.
    <command>   can be either 'provision', 'run', 'clean', or 'list'.
    [<args>]    can be either 'notebook', 'jupyterlab', or 'interactive'.
    [<version>] kind of docker image (e.g. 'dev', '2.12.0', '2.14.0',
                '2.16.0', '2.18.0', '3.0', '3.1', '3.2', '3.3', '3.4', '3.5', 
                '3.6', '3.7', '3.8', '3.9' or 'all').

    Examples:   sh run.sh list
                sh run.sh provision dev
                sh run.sh provision all-parallel
                sh run.sh provision 3.9 --no-cache
                sh run.sh run notebook dev
                sh run.sh run jupyterlab 3.9

### Quick Reference

To see all available versions and commands:

    sh run.sh list

This will display:
- All available NEST versions (categorized by legacy 2.x, NEST 3.x, and special versions)
- Available run modes (notebook, jupyterlab, interactive)
- Available provision commands


## Step-by-Step Guide

In the next steps, `VERSION` is the kind of docker image you want to use (3.9, dev, ...)

**Two simple steps to get started:**

### 1 - Provisioning

This step is only necessary if you want to build the images directly
from the docker files.

    sh run.sh provision VERSION

**Build Options:**

- Build a single version:
  ```
  sh run.sh provision 3.9
  ```

- Build all versions sequentially:
  ```
  sh run.sh provision all
  ```

- Build all versions in parallel (faster, but uses more system resources):
  ```
  sh run.sh provision all-parallel
  ```

- Force rebuild without using Docker cache:
  ```
  sh run.sh provision 3.9 --no-cache
  sh run.sh provision all --no-cache
  ```

Be careful with the version 'all'. This really takes a long time. Use 'all-parallel' for faster builds if your system has sufficient resources.

After every build of a NEST docker image, there are two more images - the one
with the name of the NEST version (e.g. 'nest/nest-simulator:latest') and
another without any name. The last one you can delete.
More information about this so called 'multi-stage build' here:
<https://docs.docker.com/develop/develop-images/multistage-build/>

### 2 - Run

-   with Jupyter Notebook (recommended)

        sh run.sh run notebook VERSION

    (For VERSION see above)

    Open the displayed URL in your browser and have fun with Jupyter
    Notebook and NEST.

-   in interactive mode

        sh run.sh run interactive VERSION

    (For VERSION see above)

    After the prompt 'Your python script:' enter the filename of the script
    you want to start. Only the filename without any path. The file has to
    be in the path where you start the script.


### 3 - Clean Up (Optional)

    sh run.sh clean

⚠️ **Warning:** This stops EVERY container and deletes EVERY NEST image.

## Using NEST with MUSIC

In the folder with your MUSIC scripts run:

    docker run -it --rm -e LOCAL_USER_ID=`id -u $USER`  \
               -v $(pwd):/opt/data  \
               nest/nest-simulator:3.9 /bin/bash

You are now in the container's shell.

    cd /opt/nest/share/doc/nest/examples/music/
    mpirun --allow-run-as-root -np 2 music ./minimalmusicsetup.music

## Useful Docker commands

-   Delete ALL(!) images (USE WITH CAUTION!)

        docker system prune -fa --volumes

-   Export a docker image

        docker save nest/nest-simulator:3.9 | gzip -c > nest-docker.tar.gz  

-   Import a docker image

        gunzip -c nest-docker.tar.gz | docker load

-   Execute an interactive bash shell on a running container.

        docker exec -it <nest_container_name> bash

-   If there is a standard user, use this to login as root:

        docker exec -it --workdir /root --user root <nest_container_name> bash

## Add image to EBRAINS registry

    docker login docker-registry.ebrains.eu
    docker build -t nest-simulator:<VERSION> /path/to/recipe --squash
    docker tag nest/nest-simulator:<VERSION>  nest/nest-simulator:<VERSION>
    docker push nest/nest-simulator:<VERSION>
