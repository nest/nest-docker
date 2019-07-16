FROM buildpack-deps:bionic AS builderslim216
LABEL maintainer="s.graber@fz-juelich.de"

ENV TERM=xterm \
    TZ=Europe/Berlin \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    cython3 \
    libgsl0-dev \
    libltdl-dev \
    libncurses5-dev \
    libreadline6-dev \
    python3.6-dev \
    python3-numpy \
    python3-scipy \
    python3-matplotlib \
    python3-ipython \
    python3-nose \
    python3-tk \
    wget

RUN wget https://github.com/nest/nest-simulator/archive/v2.16.0.tar.gz && \
  mkdir nest-build && \
  tar zxf v2.16.0.tar.gz && \
  cd  nest-build && \
  cmake -DCMAKE_INSTALL_PREFIX:PATH=/opt/nest/ \
        -Dwith-python=3 \
        ../nest-simulator-2.16.0 && \
  make && \
  make install

##############################################################################

FROM ubuntu:18.04
LABEL maintainer="s.graber@fz-juelich.de"

ENV TERM=xterm \
    TZ=Europe/Berlin \
    DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends \
      jupyter-notebook \
      libgsl-dev  \
      libltdl7 \
      libpython3.6 \
      python3-matplotlib \
      python3-numpy \
      python3-scipy \
      python3-tk && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    ln -s /usr/bin/python3 /usr/bin/python

COPY --from=buildermaster /opt/nest /opt/nest

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
