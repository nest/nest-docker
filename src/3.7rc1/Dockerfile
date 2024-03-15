FROM docker-registry.ebrains.eu/nest/nest-simulator:nest-simulator-build-base as builder
LABEL maintainer="s.graber@fz-juelich.de"

ARG NEST_VERSION=3.6
ARG SRC_PATH=/tmp
ARG CMAKE_C_COMPILER_LAUNCHER=ccache
ARG CMAKE_CXX_COMPILER_LAUNCHER=ccache
ARG CXX_FLAGS="-pedantic -Wextra -Wno-unknown-pragmas -D_GLIBCXX_ASSERTIONS"

ENV TERM=xterm \
    TZ=Europe/Berlin \
    DEBIAN_FRONTEND=noninteractive \
    PATH=/root/.local/bin:${PATH}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install NEST and NESTML
RUN wget "https://github.com/nest/nest-simulator/archive/refs/tags/v${NEST_VERSION}.tar.gz" -P ${SRC_PATH} && \
    cd ${SRC_PATH} && tar -xzf v${NEST_VERSION}.tar.gz && ls -l && \
    apt-get remove -y python3-numpy && \
    python3 -m pip install -r ${SRC_PATH}/nest-simulator-${NEST_VERSION}/doc/requirements.txt && \
    python3 -m pip install sphinx_gallery==0.10.1 numpy>=1.17.3,1.25.0 && \
    mkdir nest-build && cd nest-build && \
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
          -Dwith-music=/opt/music-install \
          -Dwith-hdf5=ON \
          ${SRC_PATH}/nest-simulator-${NEST_VERSION} && \
    make -j $(nproc) && \
    make docs && \
    make install

###############################################################################
# DEPLOY

FROM docker-registry.ebrains.eu/nest/nest-simulator:nest-simulator-deploy-base
LABEL maintainer="s.graber@fz-juelich.de"

COPY --from=builder /opt/nest /opt/nest
COPY --from=builder /opt/music-install /opt/music-install
COPY entrypoint.sh /usr/local/bin/
COPY test-nest.sh /opt/

RUN python3 -m pip install nest-desktop && \
    python3 -m pip install nestml && \
    apt-get remove -y python3-scipy && \
    python3 -m pip install scipy numpy && \
    chmod +x /usr/local/bin/entrypoint.sh && \
    chmod +x /opt/test-nest.sh

EXPOSE 8080 52425 54286
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
