# Docker image for the NEST simulator

## What is it for?

If you know how to use docker, you know how to use NEST.

Currently the following docker images are provided

    - nestsim/nest:latest (~1,09GB)
    - nestsim/nest:2.12.0 (~535MB)
    - nestsim/nest:2.14.0 (~537MB)
    - nestsim/nest:2.16.0 (~539MB)
    - nestsim/nest:2.18.0 (~543MB)
    - nestsim/nest:2.20.0 (~634MB)
    - nestsim/nest:3.0 (~1,07GB)
    - nestsim/nest:3.1 (~)

All are build with these environment variable:

    - 'WITH_MPI=ON'
    - 'WITH_OMP=ON'
    - 'WITH_GSL=ON'
    - 'WITH_MUSIC=ON'
    - 'WITH_LIBNEUROSIM=OFF'

You can change this on top of every 'dockerfile'.


## Usage

You can use the docker images direct out of docker hub like this:

### On Linux and MacOsx

    docker run -it --rm -e LOCAL_USER_ID=`id -u $USER` --name my_app  \
               -v $(pwd):/opt/data  \
               -p 8080:8080 nestsim/nest:<version> <args>


    [<args>]    can be either 'notebook', 'nest-server', interactice' or '/bin/bash'
    [<version>] kind of docker image (e.g. 'latest', '2.12.0', '2.14.0',
                '2.16.0', '2.18.0', '3.0', '3.1')

    eg.
    docker run -it --rm -e LOCAL_USER_ID=`id -u $USER` --name my_app \
               -v $(pwd):/opt/data  \
               -p 8080:8080 nestsim/nest:latest notebook

    or for starting nest-server in background (only 'latest')
    docker run -d --rm -e LOCAL_USER_ID=`id -u $USER` -p 5000:5000 nestsim/nest:latest nest-server

If you want to work with a container for a longer time, you should remove the '--rm':

    docker run -it -e LOCAL_USER_ID=`id -u $USER` --name my_app  \
               -v $(pwd):/opt/data  \
               -p 8080:8080 nestsim/nest:<version> <args>

After you stop the container, it still exists ('docker ps -a'). To restart simply use:

    docker start -i my_app
### On Windows

    docker run -it --rm -v %cd%:/opt/data -p 8080:8080 nestsim/nest:<version> <args>

In Powershell, '%cd%' might not work for the current directory. Then
you should explicitly specify a folder with existing write permissions.

In any case, this will download the docker image with the pre-installed
NEST master form docker hub and start it. After booting an URL is presented.
Click on it or copy it to your browser. Voilá jupyter notebook starts from
the docker image.

You can update the image with:

    docker pull nestsim/nest:<version>

## Usage of the local build system

You can clone this repository and use the shell script:                        

    sh run.sh [--help] <command> [<args>] [<version>]

    --help      print this usage information.
    <command>   can be either 'provision', 'run' or 'clean'.
    [<args>]    can be either 'notebook', 'interactice' or 'virtual'.
    [<version>] kind of docker image (e.g. 'latest', '2.12.0', '2.14.0',
                '2.16.0', '2.18.0', '3.0', '3.1' or 'all').

    Example:    sh run.sh provision latest
                sh run.sh run notebook latest

## Using NEST server and NEST desktop (since v3.1)

### NEST server only

    docker run -it --rm -e LOCAL_USER_ID=`id -u $USER` -p 5000:5000 nestsim/nest:3.1 nest-server
    curl localhost:5000/api

### NEST desktop including NEST server    

    docker run -it --rm -e LOCAL_USER_ID=`id -u $USER` -p 5000:5000 nestsim/nest:3.1 nest-server
    docker run -it --rm -e LOCAL_USER_ID=`id -u $USER` -p 8000:8000 nestsim/nest:3.1 nest-desktop

Open <http://localhost:8000>.

### The easy way with `docker-compose` (only v3.1)

    docker pull nestsim/nest:3.1

Heads up: If the docker image is not pre-installed, "docker-compose ..." will start building the docker image from the local Docker files.

-   `docker-compose up  nest-server`
    
    Starts the NEST API server container and opens the corresponding port 5000. Test it with `curl localhost:5000/api`.

-   `docker-compose up nest-desktop`
    
    Starts the NEST server and the NEST desktop web interface. Port 8000 is also made available.
    Open in the web browser: `http://localhost:8000`

-  `docker-compose up nest-notebook`

    Starts a notebook server with pre-installed NEST 3.1. The corresponding URL is displayed in the console.

-   `docker-compose run server bash`
    
    Starts the api server conntainer and runs bash as its command.

-   `docker-compose up`

    Starts everything.

## 1 - 2 (- 3)

In the next steps, VERSION is the kind of docker image you want to use

    - 'latest' - complete install of latest NEST release
    - '2.12.0' - complete install of NEST 2.12.0
    - '2.14.0' - complete install of NEST 2.14.0
    - '2.16.0' - complete install of NEST 2.16.0
    - '2.18.0' - complete install of NEST 2.18.0
    - '3.0' - complete install of NEST 3.0
    - '3.1' - complete install of NEST 3.1
    - 'all' - with 'all' you get all

Two little steps to get started

### 1 - Provisioning

This step is only necessary if you want to build the images directly
from the docker files.

    sh run.sh provision VERSION

Be careful with the version 'all'. This really takes a long time.

After every build of a NEST docker image, there are two more images - the one
with the name of the NEST version (e.g. 'nestsim/nest:master') and
another without any name. The last one you can delete.
More information about this so called 'multi-stage build' here:
<https://docs.docker.com/develop/develop-images/multistage-build/>

### 2 - Run

-   with Jupyter Notebook (recommended)

        sh run.sh run notebook VERSION

    or

        docker run -it --rm -e LOCAL_USER_ID=`id -u $USER` --name my_app \
               -v $(pwd):/opt/data  \
               -p 8080:8080 nestsim/nest:VERSION notebook

    (For VERSION see above)

    Open the displayed URL in your browser and have fun with Jupyter
    Notebook and NEST.

-   in interactive mode

        sh run.sh run interactive VERSION

    or

        docker run -it --rm -e LOCAL_USER_ID=`id -u $USER` --name my_app \
               -v $(pwd):/opt/data  \
               -p 8080:8080 nestsim/nest:VERSION interactive

    (For VERSION see above)

    After the prompt 'Your python script:' enter the filename of the script
    you want to start. Only the filename without any path. The file has to
    be in the path where you start the script.

-   as virtual image

        sh run.sh run virtual VERSION

     or

        docker run -it --rm -e LOCAL_USER_ID=`id -u $USER` --name my_app \
               -v $(pwd):/opt/data  \
               -p 8080:8080 nestsim/nest:VERSION /bin/bash

    (For VERSION see above)

    You are logged in as user 'nest'. Enter 'python' and in the
    python-shell 'import nest'. A 'nest.help()' should display the main
    help page.

### (3) - Delete the NEST Images

    sh run.sh clean

Be careful. This stops EVERY container and delete then EVERY NEST Images.

## Using NEST with music

In the folder with your music scripts run:

    docker run -it --rm -e LOCAL_USER_ID=`id -u $USER`  \
               -v $(pwd):/opt/data  \
               nestsim/nest:3.1 /bin/bash

You are now on container's shell, but can use the programs on your local machine

    mpirun -np 2 music /opt/data/minimalmusicsetup.music

## Useful Docker commands

-   Delete ALL(!) images (USE WITH CAUTION!)

        docker system prune -fa --volumes

-   Export a docker image

        docker save nestsim/nest:2.18.0 | gzip -c > nest-docker.tar.gz  

-   Import a docker image

        gunzip -c nest-docker.tar.gz | docker load
       
-   Execute an interactive bash shell on a container.

        docker exec -it nest-notebook_container_name bash
