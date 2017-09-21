
    #No MUSIC
    docker build \
        --build-arg WITH_MPI=On \
        --build-arg WITH_GSL=On \
        --build-arg WITH_MUSIC=Off \
        --build-arg WITH_LIBNEUROSIM=On \
        -t nest/docker-nest-2.12-alpine .