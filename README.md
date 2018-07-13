# Docker image for the NEST simulator

Currently the following docker images are provided

-   Minimal install

    -   nest/docker-nest-latest (~970MB)
        Installs the latest stable release (ppa:nest-simulator/nest).

    -   nest/docker-nest-nightly (~970MB)
        Installs the latest nightly build (ppa:nest-simulator/nest-nightly).

-   Complete install from scratch
    'WITH_MPI=On', 'WITH_GSL=On', 'WITH_MUSIC=On' and 'WITH_LIBNEUROSIM=On'

    -   nest/docker-nest-2.12.0 (~3.4GB)
    -   nest/docker-nest-2.14.0 (~3.4GB)

    NOTE: For building both an extra docker image (~3,2GB) is created. It can be deleted later.

## Usage

    nest_docker.sh [--help] <command> [<args>] [<version>]

    --help      print this usage information.
    <command>   can be either 'provision', 'run' or ''.
    [<args>]    can be either 'notebook', 'interactice' or 'virtual'.
    [<version>] kind of docker image (e.g. 'latest', 'nightly', '2.12.0' or
                2.14.0').

    Example:    sh nest-docker.sh provision latest
                sh nest-docker.sh run notebook latest

## 1 - 2 (- 3)

In the following, VESRION is the kind of docker image you want to use
(right now 'latest', 'nightly', '2.12.0' or 2.14.0').

Two little steps to get started

### 1 - Provisioning

    sh nest-docker.sh provision VERSION

(You can adapt some configuration options in nest-docker.sh. For other/more
configuration options please change the 'Dockerfile'. See:
<https://github.com/nest/nest-simulator/blob/v2.12.0/README.md>)

### 2 - Run

-   with Jupyter Notebook

        sh nest-docker.sh run notebook VERSION  

    VESRION is 2.12.0, 2.14.0 or all.               
    Open the displayed URL in your browser and have fun with Jupyter
    Notebook and NEST.

-   in interactive mode

        sh nest-docker.sh run interactive VERSION

    After the prompt 'Your python script:' enter the filename of the script
    you want to start. Only the filename without any path. The file has to
    be in the path where you start the script.

-   as virtual image

        sh nest-docker.sh run virtual VERSION

    You are logged in as user 'nest'. Enter 'python' and in the
    python-shell 'import nest'. A 'nest.help()' should display the main
    help page.

### (3) - Delete the NEST Images

    sh nest-docker.sh

Be careful. This stops EVERY container and delete the EVERY NEST Images.

## Useful Docker commands

-   Delete ALL images (USE WITH CAUTION!)

        docker system prune -fa --volumes

-   Export a docker image

        docker save nest/docker-nest-2.12.0 | gzip -c > nest-docker.tar.gz

-   Import a docker image

        gunzip -c nest-docker.tar.gz | docker load
