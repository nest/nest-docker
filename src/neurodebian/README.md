# Examples running and building


    docker build -t neuronest .

    docker build  -t steffengraber/nest-docker:2#.16 -t steffengraber/nest-docker:minmal -t steffengraber/nest-docker:latest  . -f Dockerfile.minimal --force-rm 

    docker run -it neuronest
        ~$ su nest
    docker run -it --rm --user nest --name my_app \
           -v $LOCALDIR:/home/nest/data neuronest /bin/bash


    docker   run -it --rm --user nest --name my_app \
             -v $LOCALDIR:/home/nest/data \
             -p 8080:8080 neuronest /bin/bash
