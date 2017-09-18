# NEST Notebook

Jupyter Notebook with Python3 and Nest 2.12.0.


## Getting the repository

    git clone https://github.com/steffengraber/nest-docker.git


## Build the image with variables (On|Off)

    cd nest-docker/notebook
    
    docker build \
        --build-arg WITH_MPI=On \
        --build-arg WITH_GSL=On \
        --build-arg WITH_MUSIC=On \
        --build-arg WITH_LIBNEUROSIM=On \
        -t nest/docker-nest-2.12-py3juno .
  
## Use it interactive
    
    docker run --user nest -it --rm \
        -v YOURPYFOLDER:/home/nest/data \
        -p 8080:8080 \
        nest/docker-nest-2.12-py3juno

Copy the displayed link into your browser and have fun with Jupyter Notebook 
and NEST.
