FROM ubuntu:22.04
LABEL maintainer="s.graber@fz-juelich.de"

ARG NEST_VERSION=master
ARG SRC_PATH=/tmp
ARG CMAKE_C_COMPILER_LAUNCHER=ccache
ARG CMAKE_CXX_COMPILER_LAUNCHER=ccache
ARG CXX_FLAGS="-pedantic -Wextra -Wno-unknown-pragmas -D_GLIBCXX_ASSERTIONS"

ENV TERM=xterm \
    TZ=Europe/Berlin \
    DEBIAN_FRONTEND=noninteractive \
    PATH=/root/.local/bin:${PATH}

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential automake autotools-dev ccache gosu libtool \
    cmake \
    gsl-bin \
    ipython3 \
    libboost-dev \
    libgsl-dev \
    libhdf5-dev \
    libopenmpi-dev \
    libreadline-dev \
    openmpi-bin \
    pandoc \
    python3-all-dev \
    python3-future \
    python3-nose \ 
    python3-pip \
    wget && \
    apt-get autoremove

# Download NEST
RUN cd ${SRC_PATH} && \
    wget https://github.com/nest/nest-simulator/archive/refs/heads/${NEST_VERSION}.tar.gz -P ${SRC_PATH} && \
    tar -xzf ${NEST_VERSION}.tar.gz
# Install music
RUN chmod +x ${SRC_PATH}/nest-simulator-${NEST_VERSION}/build_support/install_music.sh && \
    ${SRC_PATH}/nest-simulator-${NEST_VERSION}/build_support/install_music.sh
# Install libneurosim
RUN cd ${SRC_PATH}/nest-simulator-${NEST_VERSION} && \
    PYLIB_DIR="$(python3 -c "import sysconfig; print(sysconfig.get_path('include'))" | sed 's/include/lib/')" && \
    chmod +x ${SRC_PATH}/nest-simulator-${NEST_VERSION}/build_support/install_csa-libneurosim.sh && \
    ${SRC_PATH}/nest-simulator-${NEST_VERSION}/build_support/install_csa-libneurosim.sh $PYLIB_DIR
# Install sionlib
RUN chmod +x ${SRC_PATH}/nest-simulator-${NEST_VERSION}/build_support/install_sionlib.sh && \
    ${SRC_PATH}/nest-simulator-${NEST_VERSION}/build_support/install_sionlib.sh
# Install python requirements
RUN pip install --user -r ${SRC_PATH}/nest-simulator-${NEST_VERSION}/requirements.txt
# Build nest
RUN mkdir ${SRC_PATH}/nest-build && cd $_ && \
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
          -Dwith-libneurosim=${HOME}/.cache/libneurosim.install \
          # -Dwith-sionlib=${HOME}/.cache/sionlib.install\
          -Dwith-music=${HOME}/.cache/music.install \ 
          -Dwith-hdf5=ON \
          ${SRC_PATH}/nest-simulator-${NEST_VERSION} && \
          make && \
          make install

# Install NESTML and more
RUN python3 -m pip install nest-desktop --pre && \
    python3 -m pip install --upgrade https://github.com/nest/nestml/archive/refs/heads/master.zip && \
    python3 -m pip install quantities lazyarray neo && \
    python3 -m pip install PyNN && \
    python3 -m pip install elephant[extras] && \
    python3 -m pip install MarkupSafe==2.0.1

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

COPY test-nest.sh /opt/test-nest.sh
RUN chmod +x /opt/test-nest.sh

EXPOSE 8080 52425 54286
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
