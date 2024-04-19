# Docker image for the NEST simulator

## What is it for?

If you know how to use docker, you know how to use NEST.

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

## Usage

You can use the docker images direct out of docker-registry.ebrains.eu like this:

    docker pull nest/nest-simulator:TAG

TAG is '2.20.2', '3.2', '3.3', '3.4', '3.5', '3.6', '3.7' or 'dev'.

#### NEST 2.20.2

Jupyter notebook with NEST 2.20.2:

    docker run -it --rm -e LOCAL_USER_ID=`id -u $USER` -v $(pwd):/opt/data -e NEST_CONTAINER_MODE=notebook \
               -p 8080:8080 nest/nest-simulator:2.20.2

Jupyter lab with NEST 2.20.2

    docker run -it --rm -e LOCAL_USER_ID=`id -u $USER` -v $(pwd):/opt/data -e NEST_CONTAINER_MODE=jupyterlab \
               -p 8080:8080 nest/nest-simulator:2.20.2

#### NEST 3.7

To use 'docker-compose' you need the definition file from the git repository. Download it:

    wget https://raw.githubusercontent.com/nest/nest-docker/master/docker-compose.yml

- NEST Server

      docker-compose up nest-server

  or

      docker run -it --rm -e NEST_CONTAINER_MODE=nest-server -p 52425:52425 \
           nest/nest-simulator:3.7 

  Starts the NEST API server container and opens the corresponding port 52425. Test it with `curl localhost:52425/api`.

- NEST Desktop

      docker-compose up nest-desktop

  or

      docker run -it --rm -e NEST_CONTAINER_MODE=nest-server -p 52425:52425 \
          nest/nest-simulator:3.7
      docker run -it --rm -e LOCAL_USER_ID=`id -u $USER` -p 54286:54286  \
          -e NEST_CONTAINER_MODE=nest-desktop nest/nest-simulator:3.7

  Starts the NEST server and the NEST desktop web interface. Port 54286 is also made available.
  Open in the web browser: `http://localhost:54286`

- Jupyter notebook with NEST

      docker-compose up nest-notebook

  or

      docker run -it --rm -e LOCAL_USER_ID=`id -u $USER` -v $(pwd):/opt/data -e NEST_CONTAINER_MODE=notebook \
          -p 8080:8080 nest/nest-simulator:3.7

  Starts a notebook server with pre-installed NEST 3.7. The corresponding URL is displayed in the console.

- Jupyter lab with NEST

      docker-compose up nest-jupyterlab

  or

      docker run -it --rm -e LOCAL_USER_ID=`id -u $USER` -v $(pwd):/opt/data -e NEST_CONTAINER_MODE=jupyterlab \
          -p 8080:8080 nest/nest-simulator:3.7

  Starts a jupyter lab server with pre-installed NEST 3.7. The corresponding URL is displayed in the console.

To stop and delete running containers use `docker-compose down`.

#### NEST dev

If you want to use the compose configurtion for the dev NEST version, use the file option, e.g.:

    wget https://raw.githubusercontent.com/steffengraber/nest-docker/master/docker-compose.yml
    docker-compose -f docker-compose-dev.yml up nest-notebook

### On Windows

e.g.:

    docker run -it --rm -v %cd%:/opt/data -p 8080:8080 -e NEST_CONTAINER_MODE=<args> \
        nest/nest-simulator:<version>

In Powershell, '%cd%' might not work for the current directory. Then
you should explicitly specify a folder with existing write permissions.

In any case, this will download the docker image with the pre-installed
NEST master from docker-registry.ebrains.eu and start it. After booting an URL is presented.
Click on it or copy it to your browser. Voilá jupyter notebook starts from
the docker image.

You can update the image with:

    docker pull nest/nest-simulator:<version>

## Usage of the local build system (run.sh)

You can clone this repository and use the shell script:                        

    sh run.sh [--help] <command> [<args>] [<version>]

    --help      print this usage information.
    <command>   can be either 'provision', 'run' or 'clean'.
    [<args>]    can be either 'notebook', 'jupyterlab', or 'interactice'.
    [<version>] kind of docker image (e.g. 'dev', '2.12.0', '2.14.0',
                '2.16.0', '2.18.0', '3.0', '3.1', '3.2', '3.3', '3.4', '3.5', 
                '3.6', '3.7' or 'all').

    Example:    sh run.sh provision dev
                sh run.sh run notebook dev
                sh run.sh run jupyterlab dev


## 1 - 2 (- 3)

In the next steps, VERSION is the kind of docker image you want to use (3.7, dev, ...)

Two little steps to get started

### 1 - Provisioning

This step is only necessary if you want to build the images directly
from the docker files.

    sh run.sh provision VERSION

Be careful with the version 'all'. This really takes a long time.

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


### (3) - Delete the NEST Images

    sh run.sh clean

Be careful. This stops EVERY container and delete then EVERY NEST Images.

## Using NEST with music

In the folder with your music scripts run:

    docker run -it --rm -e LOCAL_USER_ID=`id -u $USER`  \
               -v $(pwd):/opt/data  \
               nest/nest-simulator:3.7 /bin/bash

You are now on container's shell.

    cd /opt/nest/share/doc/nest/examples/music/
    mpirun --allow-run-as-root -np 2 music ./minimalmusicsetup.music

## Useful Docker commands

-   Delete ALL(!) images (USE WITH CAUTION!)

        docker system prune -fa --volumes

-   Export a docker image

        docker save nest/nest-simulator:3.5 | gzip -c > nest-docker.tar.gz  

-   Import a docker image

        gunzip -c nest-docker.tar.gz | docker load

-   Execute an interactive bash shell on a running container.

        docker exec -it <nest_container_name> bash

-   If there is a standard user, use this to login as root:

        docker exec -it --workdir /root --user root <nest_container_name> bash

## Add image to ebrans registry

    docker login docker-registry.ebrains.eu
    docker build -t nest-simulator:<VERSION> /path/to/recipe --squash
    docker tag nest/nest-simulator:<VERSION>  nest/nest-simulator:<VERSION>
    docker push nest/nest-simulator:<VERSION>
