# Pull base image.
FROM ubuntu:16.04

RUN apt-get update && apt-get install -y \
    apt-utils \
    software-properties-common \
    apt-transport-https \
    ca-certificates  \
    python3 \
    python3-numpy \
    python3-nose \
    python3-pandas \
    python3-h5py \
    python3-pip \
    python3-sphinx \
    python3-wheel \
    pep8 && \
    pip3 install --upgrade setuptools jupyter

# install nest
RUN add-apt-repository "deb http://ppa.launchpad.net/nest-simulator/nest-nightly/ubuntu xenial main" && \
    apt-get update && \
    apt-get install nest -y --allow-unauthenticated && \
    locale-gen en_US.UTF-8

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

# add user 'nest'
RUN adduser --disabled-login --gecos 'NEST' --home /home/nest nest && \
    adduser nest sudo && \
    mkdir /home/nest/data && \
    chown nest:nest /home/nest && \
    chown -R nest:nest /home/nest/data

USER root
WORKDIR /home/nest/data
EXPOSE 8080
COPY ./entrypoint.sh /home/nest/
RUN chown nest:nest /home/nest/entrypoint.sh && \
    chmod +x /home/nest/entrypoint.sh
ENTRYPOINT ["/home/nest/entrypoint.sh"]
