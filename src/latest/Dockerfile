FROM buildpack-deps:bionic as buildermaster
LABEL maintainer="s.graber@fz-juelich.de"

ARG WITH_MPI=ON
ARG WITH_OMP=ON
ARG WITH_GSL=ON
#ARG WITH_MUSIC=ON
ARG WITH_LIBNEUROSIM=OFF

ENV TERM=xterm \
    TZ=Europe/Berlin \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential libtool automake autotools-dev libreadline7 libreadline-dev freeglut3-dev \
    gosu \
    cmake \
    cython3 \
    jq \
    libboost-filesystem-dev \
    libboost-regex-dev \
    libboost-wave-dev \
    # libboost-python-dev \
    libboost-program-options-dev \
	libboost-test-dev \
	libgomp1 \
    libgsl-dev \
    libltdl7 \
    libltdl-dev \
    libmusic1v5 \
    # libmusic-dev \
    # libncurses5-dev \
    libopenmpi-dev \
    libomp-dev \
    libpcre3 \
    libpcre3-dev \
    llvm-3.9-dev \
    # music-bin \
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
    # update-alternatives --remove-all python && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3 10


# Install music
RUN wget https://github.com/INCF/MUSIC/archive/master.tar.gz && \
	tar -zxf master.tar.gz && \
	mkdir music-build music-install && \
	cd MUSIC-master && \
	sh ./autogen.sh && \
	cd ../music-build && \
	../MUSIC-master/configure --prefix=/opt/music-install && \
	make && \
	make install && \
	cd / && \
    rm master.tar.gz

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

RUN wget https://github.com/nest/nest-simulator/archive/master.tar.gz && \
  tar -zxf master.tar.gz && \
  mkdir nest-build && \
  ls -l && \
  cd  nest-build && \
  cmake -DCMAKE_INSTALL_PREFIX:PATH=/opt/nest/ \
        # -Dwith-optimize=ON \
		# -Dwith-warning=ON \
		# -Dwith-boost=ON \
		-Dwith-ltdl=ON \
	    -Dwith-gsl=$WITH_GSL \
	    -Dwith-readline=ON \
        -Dwith-python=3 \
        -DPYTHON_LIBRARY=/usr/lib/x86_64-linux-gnu/libpython3.6m.so \
	    -DPYTHON_INCLUDE_DIR=/usr/include/python3.6m \
        -Dwith-mpi=$WITH_MPI \
        -Dwith-openmp=$WITH_OMP \
        # -DPYNEUROSIM_LIBRARY=/usr/local/lib \
        # -Dwith-libneurosim:BOOL=$WITH_LIBNEUROSIM /usr/local/lib \
        -Dwith-music=/opt/music-install \
        ../nest-simulator-master && \
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
        libgomp1 \
        libgsl-dev  \
        libltdl7 \
        # libmusic1v5 \
        libopenmpi-dev \
        libomp-dev \
        libpython3.6 \
        # music-bin \
        nano \
        openmpi-bin \
        openssh-client \
        python3-matplotlib \
        python3-mpi4py \
        python3-numpy \
        python3-scipy \
        python3-pandas \
        python3-sympy \
        python3-tk && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    ln -s /usr/bin/python3 /usr/bin/python


COPY --from=buildermaster /opt/nest /opt/nest
COPY --from=buildermaster /opt/music-install /opt/music-install

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
