FROM ubuntu:22.04
LABEL maintainer="s.graber@fz-juelich.de"

ARG NEST_VERSION=3.7
ARG SRC_PATH=/tmp
ARG CMAKE_C_COMPILER_LAUNCHER=ccache
ARG CMAKE_CXX_COMPILER_LAUNCHER=ccache
ARG CXX_FLAGS="-pedantic -Wextra -Wno-unknown-pragmas -D_GLIBCXX_ASSERTIONS"

ENV TERM=xterm \
    TZ=Europe/Berlin \
    DEBIAN_FRONTEND=noninteractive \
    PATH=/root/.local/bin:${PATH}

RUN apt-get update && apt-get install -y --no-install-recommends \
    automake \
    autotools-dev \
    build-essential \ 
    ccache \
    cmake \
    curl \
    cython3 \
    freeglut3-dev \
    gosu \
    jq \
    junitparser \
    less \
    libboost-filesystem-dev libboost-regex-dev libboost-wave-dev \
    libboost-python-dev libboost-program-options-dev libboost-test-dev \
    libboost-dev \
    libgomp1 \
    libgsl-dev  \
    libgsl0-dev \
    libhdf5-dev \
    libltdl-dev \
    libltdl7 \
    libmusic1v5 \
    libncurses-dev \
    libomp-dev \
    libopenmpi-dev \
    libpcre3 \
    libpcre3-dev \
    libpython3.10 \
    libreadline-dev \
    libreadline8 \ 
    libtool \
    libzmq3-dev \
    llvm-dev \
    nano \
    openmpi-bin \
    openssh-client \
    openssh-server \
    pandoc \
    pep8 \
    pkg-config \
    python3-dev \
    python3-flask \
    python3-flask-cors \
    python3-h5py \
    python3-ipython \
    python3-junitparser \
    python3-jupyter-core \
    python3-mpi4py \
    python3-nose \
    python3-pandas \    
    python3-path \
    python3-pip \
    python3-pytest \
    python3-pytest-timeout \
    python3-pytest-xdist \    
    python3-restrictedpython \
    python3-scipy \
    python3-setuptools \
    python3-sphinx \
    python3-statsmodels \
    python3-sympy \
    python3-tk \
    python3-tqdm \
    tcl8.6 \
    tcl8.6-dev \
    tk8.6-dev \
    uwsgi \
    vera++ \
    wget && \
    apt-get autoremove && \
    python3 -m pip install --upgrade pip setuptools wheel mock && \
    python3 -m pip install --force-reinstall --upgrade --no-binary=h5py h5py && \
    ldconfig && \
    cd ${SRC_PATH} && \
    wget "https://github.com/nest/nest-simulator/archive/refs/tags/v${NEST_VERSION}.tar.gz" -P ${SRC_PATH} && \
    tar -xzf v${NEST_VERSION}.tar.gz && \
    python3 -m pip install -r ${SRC_PATH}/nest-simulator-${NEST_VERSION}/doc/requirements.txt && \
    python3 -m pip install sphinx_gallery==0.10.1 numpy<2.0dev0 && \
    chmod +x ${SRC_PATH}/nest-simulator-${NEST_VERSION}/build_support/install_music.sh && \
    ${SRC_PATH}/nest-simulator-${NEST_VERSION}/build_support/install_music.sh && \
    mkdir ${SRC_PATH}/nest-build && cd $_ && \
    cmake -DCMAKE_INSTALL_PREFIX:PATH=/opt/nest \
          -Dwith-optimize="-O2" \
          -Dwith-warning=ON \
          -Dwith-userdoc=ON \
          -Dwith-boost=ON \
          -Dwith-ltdl=ON \
          -Dwith-gsl=ON \
          -Dwith-readline=ON \
          -Dwith-python=ON \
          -Dwith-mpi=ON \
          -Dwith-openmp=ON \
          -Dwith-libneurosim=OFF \
          -Dwith-sionlib=OFF \
          -Dwith-music='$HOME/.cache/libneurosim.install' \ 
          -Dwith-hdf5=ON \
          ${SRC_PATH}/nest-simulator-${NEST_VERSION} && \
          make && \
          make install && \
    python3 -m pip install --upgrade pip setuptools wheel && \
    python3 -m pip install -r ${SRC_PATH}/nest-simulator-${NEST_VERSION}/requirements.txt && \
    python3 -m pip install --upgrade numpy<2.0dev0 && \
    python3 -m pip install --upgrade nest-desktop && \
    python3 -m pip install --upgrade nestml && \
    python3 -m pip install --upgrade scipy && \
    python3 -m pip install --upgrade pygsl

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

COPY test-nest.sh /opt/test-nest.sh
RUN chmod +x /opt/test-nest.sh

EXPOSE 8080 52425 54286
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
