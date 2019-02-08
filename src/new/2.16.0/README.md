# What to do

## Build

    docker build -t steffengraber/nest-docker:2.16 . --force-rm

## Run


### Run jupyter notebook

     docker run -it --rm --user nest --name my_app \
                -v $(pwd):/home/nest/data \
                -p 8080:8080 \
                 steffengraber/nest-docker:2.16 \
                 notebook

Open the displayed URL in your browser and have fun with Jupyter Notebook 
and NEST.

## Run 'normal' image version

                 
     docker run -it --rm --user nest --name my_app \
                 steffengraber/nest-docker:2.16 \
                 /bin/bash

You are logged in directly and can use SLI and python version of NEST 


## Delete


### Delete your working image

	docker rmi steffengraber/nest-docker:2.16

### Delete the build image

If you only want to to delete your last build image, you have to find out 
the IMAGE ID.

	docker image 

This give you a list auf all your images. The repository called '<none>' 
right before 'steffengraber/nest-docker:2.16-slim' is the one you are 
searching for. Copy the IMAGE ID and delete the image with:

    docker rmi IMAGE ID

TIP: This removes all '<none>'-images: 

    docker rmi $(docker images -f "dangling=true" -q)
    
 
## Save your working container




## More Tips

### Delete ALL images (USE WITH CAUTION!)

    docker system prune -fa --volumes

### Export a docker image

    docker save steffengraber/nest-docker:2.16 | gzip -c > nest-docker.tar.gz

### Import a docker image

    gunzip -c nest-docker.tar.gz | docker load