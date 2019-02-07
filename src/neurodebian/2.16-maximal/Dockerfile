FROM neurodebian:bionic as builder
MAINTAINER "Steffen Graber" <s.graber@fz-juelich.de>

ENV TERM=xterm \
    TZ=Europe/Berlin \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    cython3 \
    libgsl-dev \
    libltdl7 \
    libltdl-dev \
    libncurses5-dev \
    libreadline6-dev \
    python3.6-dev \
    python3-numpy \
    python3-scipy \
    python3-matplotlib \
    python3-ipython \
    python3-nose \
    wget \
    git \
    unzip \
    build-essential \
    autoconf \
    cmake \
    openmpi-bin \
    libopenmpi-dev \
    vera++ \
    pep8 \
    libpcre3 \
    libpcre3-dev \
    jq \
    libmusic1v5 \
    music-bin \
    libmusic-dev \
    python-dev \
    python3-dev \
    python3-setuptools \
    python3-path \
    python3-statsmodels \
    python3-jupyter-core \
    python3-mpi4py \
    python3-pandas \
    cython3  && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

RUN cd /tmp && \
    git clone https://github.com/INCF/libneurosim.git libneurosim && \
    cd /tmp/libneurosim && \
    chmod +x autogen.sh && \
    ./autogen.sh && \
    chmod +x configure && \
    ./configure --with-python=3 && make &&  make install &&\
    rm -rf /tmp/*
###############################################################################
##
## If you want libneurosim you need to install it in teh end-image, too
##
###############################################################################

RUN wget https://github.com/nest/nest-simulator/archive/v2.16.0.tar.gz && \
  mkdir nest-build && \
  tar zxf v2.16.0.tar.gz && \
  cd  nest-build && \
  cmake -DCMAKE_INSTALL_PREFIX:PATH=/opt/nest/ \
        -Dwith-python=3 \
        -Dwith-ltdl:BOOL=ON /usr/lib \
        -Dwith-mpi:BOOL=ON \
        -Dwith-gsl:BOOL=ON /usr/local/lib \
        -DPYNEUROSIM_LIBRARY=/usr/local/lib \
        -Dwith-libneurosim:BOOL=OFF /usr/local/lib \
        -Dwith-music:BOOL=ON /usr/lib \
        ../nest-simulator-2.16.0 && \
  make && \
  make install


###############################################################################

FROM ubuntu:18.04
MAINTAINER "Steffen Graber" <s.graber@fz-juelich.de>

ENV TERM=xterm \
    TZ=Europe/Berlin \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
        libgsl-dev  \
        libltdl7 \
        libpython3.6 \
        libmusic1v5 \
        music-bin \
        openmpi-bin \
        python3-numpy \
        python3-scipy \
        python3-matplotlib \
        jupyter \
        jupyter-notebook \
        python3-mpi4py  && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    ln -s /usr/bin/python3 /usr/bin/python

# add user 'nest'
RUN adduser --disabled-login --gecos 'NEST' --home /home/nest nest && \
    adduser nest sudo && \
    mkdir data && \
    chown nest:nest /home/nest

# WORKDIR /home/nest

COPY --from=builder /opt/nest /opt/nest

COPY ./entrypoint.sh /home/nest/
RUN chown nest:nest /home/nest/entrypoint.sh && \
    chmod +x /home/nest/entrypoint.sh && \
    echo '. /opt/nest/bin/nest_vars.sh' >> /home/nest/.bashrc
#EXPOSE 8080
#WORKDIR /home/nest
ENTRYPOINT ["/home/nest/entrypoint.sh"]
