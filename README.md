# Docker image for the NEST simulator

## What is it for?

If you know how to use docker, you know how to use NEST.

Currently the following docker images are provided

    - nestsim/nest:master (~884MB)
    - nestsim/nest:2.12.0 (~875MB)
    - nestsim/nest:2.14.0 (~877MB)
    - nestsim/nest:2.16.0 (~879MB)
    - nestsim/nest:2.18.0 (~881MB)
   
All are build with these environment variable:

	- 'WITH_MPI=ON'
	- 'WITH_OMP=ON'
	- 'WITH_GSL=ON'
	- 'WITH_MUSIC=ON'
	- 'WITH_LIBNEUROSIM=OFF'

You can change this on top of every 'dockerfile'.

   
## Usage

    sh run.sh [--help] <command> [<args>] [<version>]

    --help      print this usage information.
    <command>   can be either 'provision', 'run' or 'clean'.
    [<args>]    can be either 'notebook', 'interactice' or 'virtual'.
    [<version>] kind of docker image (e.g. 'master', '2.12.0', '2.14.0',
                '2.16.0', '2.18.0' or 'all').

    Example:    sh run.sh provision master
                sh run.sh run notebook master

## 1 - 2 (- 3)

In the following, VERSION is the kind of docker image you want to use

    - 'master' - complete install of latest NEST release
    - '2.12.0' - complete install of NEST 2.12.0
    - '2.14.0' - complete install of NEST 2.14.0
    - '2.16.0' - complete install of NEST 2.16.0
    - '2.18.0' - complete install of NEST 2.18.0
    - 'all' - with 'all' you get all

Two little steps to get started

### 1 - Provisioning

This step is only necessary if you want to build the images directly from the docker files.

    sh run.sh provision VERSION
    
Be careful with the version 'all'. This really takes a long time. 
    
After every build of a NEST docker image, there are two more images - the one 
with the name of the NEST version (e.g. 'nest/nest-docker:master') and 
another without any name. The last one you can delete.
More information about this so called 'multi-stage build' here: 
<https://docs.docker.com/develop/develop-images/multistage-build/>

### 2 - Run

-   with Jupyter Notebook

        sh run.sh run notebook VERSION
        
    or 
        
        docker run -it --rm --user nest --name my_app \
                        -v $(pwd):/home/nest/data \
                        -p 8080:8080 nestsim/nest:VESRION notebook
    
    (For VERSION see above)

    Open the displayed URL in your browser and have fun with Jupyter
    Notebook and NEST.

-   in interactive mode

        sh run.sh run interactive VERSION
        
    or 
        
        docker run -it --rm --user nest --name my_app \
                        -v $(pwd):/home/nest/data \
                        -p 8080:8080 nestsim/nest:VESRION interactive
    
    (For VERSION see above)

    After the prompt 'Your python script:' enter the filename of the script
    you want to start. Only the filename without any path. The file has to
    be in the path where you start the script.

-   as virtual image

         sh run.sh run virtual VERSION
         
     or 
        
        docker run -it --rm --user nest --name my_app \
                        -v $(pwd):/home/nest/data \
                        -p 8080:8080 nestsim/nest:VESRION /bin/bash
    
    (For VERSION see above)

    You are logged in as user 'nest'. Enter 'python' and in the
    python-shell 'import nest'. A 'nest.help()' should display the main
    help page.

### (3) - Delete the NEST Images

    sh run.sh clean

Be careful. This stops EVERY container and delete then EVERY NEST Images.

## Useful Docker commands

-   Delete ALL(!) images (USE WITH CAUTION!)

        docker system prune -fa --volumes

-   Export a docker image

        docker save nestsim/nest:2.12.0 | gzip -c > nest-docker.tar.gz

-   Import a docker image

        gunzip -c nest-docker.tar.gz | docker load
