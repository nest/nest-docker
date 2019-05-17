FROM buildpack-deps:bionic as builderslim216
MAINTAINER "Steffen Graber" <s.graber@fz-juelich.de>

ENV TERM=xterm \
    TZ=Europe/Berlin \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
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
MAINTAINER "Steffen Graber" <s.graber@fz-juelich.de>

ENV TERM=xterm \
    TZ=Europe/Berlin \
    DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8

RUN apt-get update && apt-get install -y \
      jupyter-notebook \
      libgsl-dev  \
      libltdl7 \
      libpython3.6 \
      python3-matplotlib \
      python3-numpy \
      python3-scipy && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    ln -s /usr/bin/python3 /usr/bin/python

# add user 'nest'
RUN adduser --disabled-login --gecos 'NEST' --home /home/nest nest && \
    adduser nest sudo && \
    mkdir /home/nest/data && \
    chown nest:nest /home/nest

WORKDIR /home/nest

COPY --from=builderslim216 /opt/nest /opt/nest

COPY ./entrypoint.sh /home/nest/
RUN chown nest:nest /home/nest/entrypoint.sh && \
    chmod +x /home/nest/entrypoint.sh && \
    echo '. /opt/nest/bin/nest_vars.sh' >> /home/nest/.bashrc

EXPOSE 8080
WORKDIR /home/nest
ENTRYPOINT ["/home/nest/entrypoint.sh"]
