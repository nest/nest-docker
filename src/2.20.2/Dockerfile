FROM ubuntu:focal
LABEL maintainer="s.graber@fz-juelich.de"

ENV TERM=xterm \
    TZ=Europe/Berlin \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential libtool automake autotools-dev libreadline8 libreadline-dev freeglut3-dev \
    gosu \
    curl \
    cmake \
    cython3 \
    jq \
    jupyter-notebook \
    less \
    libboost-filesystem-dev \
    libboost-regex-dev \
    libboost-wave-dev \
    libboost-program-options-dev \
    libboost-test-dev \
    libgomp1 \
    libgsl-dev \
    libltdl7 \
    libltdl-dev \
    libmusic1v5 \
    libopenmpi-dev \
    libomp-dev \
    libpcre3 \
    libpcre3-dev \
    libpython3.8 \
    llvm-dev \
    nano \
    openmpi-bin \
    openssh-client \
    openssh-server \
    pandoc \
    pep8 \
    python3-dev \
    python3-flask \
    python3-flask-cors \
    python3-restrictedpython \
    python3-ipython \
    python3-matplotlib \
    python3-mpi4py \
    python3-nose \
    python3-numpy \
    python3-pandas \
    python3-path \
    python3-pip \
    python3-scipy \
    python3-setuptools \
    python3-sphinx \
    python3-statsmodels \
    python3-tk \
    python-dev \
    vera++ \
    wget  && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* 

# # Install music
# RUN wget https://github.com/INCF/MUSIC/archive/master.tar.gz && \
#     tar -zxf master.tar.gz && \
#     mkdir music-build music-install && \
#     cd MUSIC-master && \
#     sh ./autogen.sh && \
#     cd ../music-build && \
#     ../MUSIC-master/configure --prefix=/opt/music-install && \
#     make && \
#     make install && \
#     cd / && \
#     rm master.tar.gz

# Install NEST
RUN wget https://github.com/nest/nest-simulator/archive/refs/tags/v2.20.2.tar.gz && \
    mkdir /nest-build && \
    tar zxf v2.20.2.tar.gz && \
    cd  /nest-build && \
    cmake -DCMAKE_INSTALL_PREFIX:PATH=/opt/nest/ \
        -Dwith-python=3 \
        -Dwith-mpi=ON \
        -Dwith-openmp=ON \
        ../nest-simulator-2.20.2 &&\
    make && make install

RUN python3 -m pip install --upgrade pip setuptools wheel mock --user &&\
    python3 -m pip install quantities lazyarray neo --user && \
    python3 -m pip install uwsgi --user &&\
    python3 -m pip install PyNN --user && \
    python3 -m pip install Flask --user && \
    python3 -m pip install Flask-cors --user && \
    python3 -m pip install RestrictedPython --user && \
    python3 -m pip install nest-desktop --user &&\
    python3 -m pip install uwsgi --user &&\
    python3 -m pip install nestml --user

RUN python3 -m pip install jupyterlab --user

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
EXPOSE 5000 8000 8080
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
