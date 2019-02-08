# What to do

## Build

    docker build  -t steffengraber/nest-docker:2.16-min  .  --force-rm

## Run

     docker run -it --rm --user nest --name my_app \
                -v $LOCALDIR:/home/nest/data \
                 steffengraber/nest-docker:2.16-min \
                 /bin/bash
