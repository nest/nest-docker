# Docker image for the NEST simulator (v2.12.0)

The dockerfile builds an image with a basic shell environment with 
Python 2.7 and [NEST 2.12.0](https://github.com/nest/nest-simulator) with 
OpenMPI, matplotlib, Scipy, MUSIC and libneurosim.

(If you want to use NEST with Jupyter Notebooks see: 
[./notebook/README.md]())

## Getting the repository

    git clone https://github.com/steffengraber/nest-docker.git

## Creating the docker image

    cd nest-docker
    
    # Build the image with variables (On|Off)
        
    docker build \
        --build-arg WITH_MPI=On \
        --build-arg WITH_GSL=On \
        --build-arg WITH_MUSIC=On \
        --build-arg WITH_LIBNEUROSIM=On \
        -t nest/docker-nest-2.12 .
    
For other configuration options please change the 'Dockerfile'.
See: <https://github.com/nest/nest-simulator/blob/master/README.md> 

## Use it interactive

	# Replace YOURPYFOLDER with the folder on our host.
	# YOURFOLDER is the folder with your python scripts.
    # /home/nest/data is the folder in the docker.
    
    docker run -it --rm --user nest --name my_app  \
      -v YOURPYFOLDER:/home/nest/data \
      nest/docker-nest-2.12

After the prompt 'Your python script:' enter the filename of the script 
you want to start. Only the filename without any path. Be sure to enter 
the right 'YOURFOLDER'.
