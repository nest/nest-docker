FROM ubuntu:24.04
LABEL maintainer="s.graber@fz-juelich.de"

ARG NEST_VERSION=master
ARG SRC_PATH=/tmp

ENV TERM=xterm \
    TZ=Europe/Berlin \
    DEBIAN_FRONTEND=noninteractive \
    OMPI_ALLOW_RUN_AS_ROOT=1 \
    OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1 \
    PATH=/root/.local/bin:$PATH

# Install all dependencies and clean up
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates locales tzdata \
        python3 python3-venv python3-pip python3-dev \
        git cmake ccache make gcc g++ \
        libgsl-dev libboost-dev libltdl-dev libreadline-dev \
        libopenmpi-dev pkg-config wget nano \
        libhdf5-dev \
        pandoc \
        libtool \
    && rm -rf /var/lib/apt/lists/*

WORKDIR ${SRC_PATH}

# Clone only the required branch and minimal history for speed
RUN git clone --branch ${NEST_VERSION} --depth 1 https://github.com/nest/nest-simulator.git

# Install MUSIC (Dwith-music="$HOME/.cache/music.install" \)
# RUN chmod +x ${SRC_PATH}/nest-simulator/build_support/install_music.sh && \
#    ${SRC_PATH}/nest-simulator/build_support/install_music.sh

# Set up Python virtual environment and install Python dependencies
RUN python3 -m venv /root/.env && \
    . /root/.env/bin/activate && \
    echo "source /root/.env/bin/activate" >> /root/.bashrc && \
    cd nest-simulator && \
    pip install --upgrade pip wheel && \
    pip install --no-cache-dir Cython numpy boost setuptools gsl meson-python ninja && \
    pip install -v --no-cache-dir --no-build-isolation --force-reinstall --check-build-dependencies --no-binary pygsl pygsl && \
    pip install --no-cache-dir -r requirements.txt


# Build and install NEST
RUN . /root/.env/bin/activate && \
    mkdir ${SRC_PATH}/nest-build && cd ${SRC_PATH}/nest-build && \
    cmake -Dwith-optimize="-O2" \
          -Dwith-warning=ON \
          -Dwith-userdoc=ON \
          -Dwith-boost=ON \
          -Dwith-ltdl=ON \
          -Dwith-gsl=ON \
          -Dwith-readline=ON \
          -Dwith-python=ON \
          -DPYTHON_EXECUTABLE=/root/.env/bin/python3 \
          -Dwith-mpi=OFF \
          -Dwith-openmp=ON \
          -Dwith-libneurosim=OFF \
          -Dwith-sionlib=OFF \
          -Dwith-music=OFF \
          -Dwith-hdf5=OFF \
          ${SRC_PATH}/nest-simulator && \
    make -j"$(nproc)" && \
    make install && \
    cd / && rm -rf ${SRC_PATH}/nest-build ${SRC_PATH}/nest-simulator

# Upgrade and install additional Python tools in the venv
RUN . /root/.env/bin/activate && \
    pip install --no-cache-dir --upgrade nestml nest-desktop pandas jupyterlab notebook && \
    find /root/.cache -type f -delete

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

COPY test-nest.sh /opt/test-nest.sh
RUN chmod +x /opt/test-nest.sh

EXPOSE 8080 52425 52426 54286
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
