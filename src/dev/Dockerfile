FROM docker-registry.ebrains.eu/nest/nest-simulator:nest-simulator-build-base as builder
LABEL maintainer="s.graber@fz-juelich.de"

ARG NEST_VERSION=master
ARG SRC_PATH=/tmp
ARG CMAKE_C_COMPILER_LAUNCHER=ccache
ARG CMAKE_CXX_COMPILER_LAUNCHER=ccache
ARG CXXFLAGS="-O2 -lrt"


RUN apt-get update && apt-get install -y --no-install-recommends pandoc \
    libgsl0-dev libboost-filesystem-dev libboost-regex-dev libboost-wave-dev \
    libboost-python-dev libboost-program-options-dev libboost-test-dev pkg-config
RUN python3 -m pip install --force-reinstall --upgrade --no-binary=h5py h5py 
RUN ldconfig


# Install NEST and NESTML
RUN wget https://github.com/nest/nest-simulator/archive/refs/heads/${NEST_VERSION}.tar.gz -P ${SRC_PATH} && \
    cd ${SRC_PATH} && tar -xzf ${NEST_VERSION}.tar.gz && ls -l && \
    python3 -m pip install -r ${SRC_PATH}/nest-simulator-${NEST_VERSION}/doc/requirements.txt && \
    python3 -m pip install sphinx_gallery==0.10.1

RUN apt-get update && apt-get install -y --no-install-recommends libhdf5-dev 
RUN python3 -m pip install --force-reinstall --upgrade --no-binary=h5py h5py

RUN mkdir nest-build && cd nest-build
RUN cmake -DCMAKE_INSTALL_PREFIX:PATH=/opt/nest \
          -Dwith-optimize=ON \
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
          -Dwith-music=ON \ 
          -Dwith-hdf5=ON \
          ${SRC_PATH}/nest-simulator-${NEST_VERSION}
RUN make -j $(nproc)
# RUN make docs
RUN make install



###############################################################################
# DEPLOY

FROM docker-registry.ebrains.eu/nest/nest-simulator:nest-simulator-deploy-base
LABEL maintainer="s.graber@fz-juelich.de"

COPY --from=builder /opt/nest /opt/nest
COPY --from=builder /opt/music-install /opt/music-install
# COPY --from=builder /opt/hdf5 /opt/hdf5

RUN python3 -m pip install --upgrade pip && \
    python3 -m pip install nest-desktop --pre && \
    python3 -m pip uninstall nestml -y && \
    python3 -m pip install --upgrade https://github.com/nest/nestml/archive/refs/heads/master.zip 

RUN python3 -m pip install --force-reinstall --upgrade scipy

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

COPY test-nest.sh /opt/test-nest.sh
RUN chmod +x /opt/test-nest.sh

EXPOSE 8080 52425 54286
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
