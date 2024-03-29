# BUILD

FROM docker-registry.ebrains.eu/nest/nest-simulator:nest-simulator-build-base as builder
LABEL maintainer="s.graber@fz-juelich.de"

ARG NEST_VERSION=3.2
ARG SRC_PATH=/tmp

# Install NEST
COPY pathlib-nest-3.2.patch  ${SRC_PATH}
RUN wget https://github.com/nest/nest-simulator/archive/refs/tags/v${NEST_VERSION}.tar.gz -P ${SRC_PATH} && \
    cd ${SRC_PATH}  && tar -xzf v${NEST_VERSION}.tar.gz && ls -l && \
    wget https://github.com/nest/nest-simulator/releases/download/v3.2/nest-simulator-3.2-p1-VersionNumber.patch && \
    cp pathlib-nest-3.2.patch ${SRC_PATH}/nest-simulator-${NEST_VERSION}/ && \
    cd ${SRC_PATH}/nest-simulator-${NEST_VERSION}/ && patch -p1 < ${SRC_PATH}/nest-simulator-3.2-p1-VersionNumber.patch && \
    patch -p1 < pathlib-nest-3.2.patch && \
    python3 -m pip install -r ${SRC_PATH}/nest-simulator-${NEST_VERSION}/doc/requirements.txt && \
    python3 -m pip install sphinx_gallery==0.10.1 && \
    python3 -m pip install MarkupSafe==2.0.1

RUN mkdir nest-build && cd nest-build && \
    cmake -DCMAKE_INSTALL_PREFIX:PATH=/opt/nest \
          -Dwith-warning=ON \
          -Dwith-boost=ON \
          -Dwith-ltdl=ON \
          -Dwith-gsl=ON \
          -Dwith-readline=ON \
          -Dwith-python=ON \
          -Dwith-mpi=ON \
          -Dwith-openmp=ON \
          -Dwith-libneurosim=OFF \
          -Dwith-music=/opt/music-install \
          ${SRC_PATH}/nest-simulator-${NEST_VERSION} && \
    make -j 8 && \
    make html && \
    make install


###############################################################################
# DEPLOY

FROM docker-registry.ebrains.eu/nest/nest-simulator:nest-simulator-deploy-base
LABEL maintainer="s.graber@fz-juelich.de"

COPY --from=builder /opt/nest /opt/nest
COPY --from=builder /opt/music-install /opt/music-install

RUN python3 -m pip install --upgrade pip && \
    python3 -m pip install nest-desktop==3.1.* && \
    python3 -m pip install uwsgi

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 5000 8000 8080
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
