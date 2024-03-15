FROM docker-registry.ebrains.eu/nest/nest-simulator:nest-simulator-build-base as builder
LABEL maintainer="s.graber@fz-juelich.de"

ARG NEST_VERSION=3.6
ARG SRC_PATH=/tmp
ARG CMAKE_C_COMPILER_LAUNCHER=ccache
ARG CMAKE_CXX_COMPILER_LAUNCHER=ccache
ARG CXXFLAGS="-O2 -lrt"


# Install NEST and NESTML
RUN wget "https://github.com/nest/nest-simulator/archive/refs/tags/v${NEST_VERSION}.tar.gz" -P ${SRC_PATH} && \
    cd ${SRC_PATH} && tar -xzf v${NEST_VERSION}.tar.gz && ls -l && \
    python3 -m pip install -r ${SRC_PATH}/nest-simulator-${NEST_VERSION}/doc/requirements.txt && \
    python3 -m pip install sphinx_gallery==0.10.1

RUN mkdir nest-build && cd nest-build && \
    cmake -DCMAKE_INSTALL_PREFIX:PATH=/opt/nest \
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

RUN python3 -m pip install --upgrade pip && \
    python3 -m pip install nest-desktop && \
    python3 -m pip install nestml

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

COPY test-nest.sh /opt/test-nest.sh
RUN chmod +x /opt/test-nest.sh

EXPOSE 8080 52425 54286
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
