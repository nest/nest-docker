FROM buildpack-deps:bionic AS builder2142
LABEL maintainer="s.graber@fz-juelich.de"

ARG WITH_MPI=ON
ARG WITH_OMP=ON
ARG WITH_GSL=ON
ARG WITH_MUSIC=ON
ARG WITH_LIBNEUROSIM=OFF

ENV TERM=xterm \
    TZ=Europe/Berlin \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    cmake \
    cython3 \
    gosu \
    jq \
    libboost-all-dev \
	libgomp1 \
    libgsl-dev \
    libltdl7 \
    libltdl-dev \
    libmusic1v5 \
    libmusic-dev \
    libncurses5-dev \
    libopenmpi-dev \
    libomp-dev \
    libpcre3 \
    libpcre3-dev \
    llvm-3.9-dev \
    music-bin \
    openmpi-bin \
    pep8 \
    python3.6-dev \
    python3-ipython \
    python3-jupyter-core \
    python3-matplotlib \
    python3-mpi4py \
    python3-nose \
    python3-numpy \
    python3-pandas \
    python3-path \
    python3-scipy \
    python3-setuptools \
    python3-statsmodels \
    python3-tk \
    python-dev \
    vera++ \
    wget  && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3 10

# locales setting needed for NEST 2.14.0 - see issue #830
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends locales \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# RUN cd /tmp && \
#    git clone https://github.com/INCF/libneurosim.git libneurosim && \
#    cd /tmp/libneurosim && \
#    chmod +x autogen.sh && \
#    ./autogen.sh && \
#    chmod +x configure && \
#    ./configure --with-python=3 && make &&  make install &&\
#    rm -rf /tmp/*
###############################################################################
##
## If you want libneurosim you need to install it in the min-image below, too
##
###############################################################################
RUN git clone https://github.com/nest/nest-simulator.git && \
    cd nest-simulator && \
    git checkout v2.14.2-rc1 && \
    mkdir ../nest-build && \
    cd ../nest-build && \
    cmake -DCMAKE_INSTALL_PREFIX:PATH=/opt/nest/ \
  		# -Dwith-optimize=ON \
		-Dwith-warning=ON \
		-Dwith-boost=ON \
        -Dwith-python=3 \
        -Dwith-ltdl:BOOL=ON /usr/lib \
        -Dwith-mpi:BOOL=$WITH_MPI \
        -Dwith-openmp=$WITH_OMP \
        -Dwith-gsl:BOOL=$WITH_GSL /usr/local/lib \
        -DPYNEUROSIM_LIBRARY=/usr/local/lib \
        -Dwith-libneurosim:BOOL=$WITH_LIBNEUROSIM /usr/local/lib \
        -Dwith-music:BOOL=$WITH_MUSIC /usr/lib \
        ../nest-simulator && \
  make && \
  make install


###############################################################################

FROM ubuntu:bionic
LABEL maintainer="s.graber@fz-juelich.de"

ENV TERM=xterm \
    TZ=Europe/Berlin \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
        gosu \
        jupyter-notebook \
        less \
        libgomp1 \
        libgsl-dev  \
        libltdl7 \
        libmusic1v5 \
        libopenmpi-dev \
        libomp-dev \
        libpython3.6 \
        locales \
        music-bin \
        nano \
        openmpi-bin \
        openssh-client \
        python3-matplotlib \
        python3-mpi4py \
        python3-numpy \
        python3-pip \
        python3-scipy \
        python3-setuptools \
        python3-pandas \
        python3-sympy \
        python3-tk && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3 10 && \
    update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 10 && \
    locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# RUN pip install quantities lazyarray neo && \
#    pip install --no-binary :all: PyNN

COPY --from=builder2142 /opt/nest /opt/nest

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
