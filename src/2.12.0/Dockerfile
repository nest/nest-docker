FROM buildpack-deps:bionic AS builder212
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
    gosu \
    cmake \
    cython \
    jq \
    libboost-all-dev \
	libomp-dev \
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
    python-dev \
    python-ipython \
    python-jupyter-core \
    python-matplotlib \
    python-mpi4py \
    python-nose \
    python-numpy \
    python-pandas \
    python-path \
    python-scipy \
    python-setuptools \
    python-statsmodels \
    python-tk \
    python-dev \
    vera++ \
    wget  && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

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

RUN wget https://github.com/nest/nest-simulator/archive/v2.12.0.tar.gz && \
	mkdir nest-build && \
	tar -xvzf v2.12.0.tar.gz && \
	cd  nest-build && \
	cmake -DCMAKE_INSTALL_PREFIX:PATH=/opt/nest/ \
		-Dwith-python=2 \
		-Dwith-ltdl:BOOL=ON /usr/lib \
        -Dwith-mpi:BOOL=$WITH_MPI \
        -Dwith-openmp=$WITH_OMP \
        -Dwith-gsl:BOOL=$WITH_GSL /usr/local/lib \
        -Dwith-music:BOOL=$WITH_MUSIC /usr/lib \
		../nest-simulator-2.12.0 && \
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
        libpython2.7 \
        music-bin \
        nano \
        openmpi-bin \
        openssh-client \
        python-matplotlib \
        python-mpi4py \
        python-numpy \
        python-pip \
        python-scipy \
        python-setuptools \
        python-pandas \
        python-sympy \
        python-tk && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    #update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 10 && \
    pip install quantities lazyarray neo && \
    pip install --no-binary :all: PyNN

COPY --from=builder212 /opt/nest /opt/nest

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
