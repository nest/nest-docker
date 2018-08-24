# Pull base image.
FROM ubuntu:18.04

MAINTAINER "Steffen Graber" <s.graber@fz-juelich.de>

ENV TERM=xterm \
    TZ=Europe/Berlin \
    DEBIAN_FRONTEND=noninteractive


RUN apt-get update && apt-get install -y \
    apt-utils \
    software-properties-common \
    apt-transport-https \
    ca-certificates  \
    tzdata \
    pep8 \
    python3 \
    python3-numpy \
    python3-nose \
    python3-pandas \
    python3-h5py \
    python3-pip \
    python3-sphinx \
    python3-wheel  && \
    pip3 install --upgrade setuptools jupyter   && \
    add-apt-repository "deb http://ppa.launchpad.net/nest-simulator/nest/ubuntu xenial main" && \
    apt-get update && \
    apt-get install nest -y --allow-unauthenticated && \
    locale-gen en_US.UTF-8

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

# add user 'nest'
RUN adduser --disabled-login --gecos 'NEST' --home /home/nest nest && \
    adduser nest sudo && \
    mkdir /home/nest/data && \
    chown nest:nest /home/nest

COPY ./entrypoint.sh /home/nest/
RUN chown nest:nest /home/nest/entrypoint.sh && \
    chmod +x /home/nest/entrypoint.sh

EXPOSE 8080
WORKDIR /home/nest/data
ENTRYPOINT ["/home/nest/entrypoint.sh"]
