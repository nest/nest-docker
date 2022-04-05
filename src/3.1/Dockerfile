FROM buildpack-deps:focal as builder31
LABEL maintainer="s.graber@fz-juelich.de"

ENV TERM=xterm \
    TZ=Europe/Berlin \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential libtool automake autotools-dev libreadline8 libreadline-dev freeglut3-dev \
    gosu \
    cmake \
    cython3 \
    jq \
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
    openmpi-bin \
    pandoc \
    pep8 \
    python3-dev \
    python3-ipython \
    python3-jupyter-core \
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
    rm -rf /var/lib/apt/lists/* && \
    # update-alternatives --remove-all python && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3 10 && \
    update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 10 && \
    python3 -m pip install --upgrade pip setuptools wheel mock


# Install music
RUN wget https://github.com/INCF/MUSIC/archive/master.tar.gz && \
    tar -zxf master.tar.gz && \
    mkdir music-build music-install && \
    cd MUSIC-master && \
    sh ./autogen.sh && \
    cd ../music-build && \
    ../MUSIC-master/configure --prefix=/opt/music-install && \
    make && \
    make install && \
    cd / && \
    rm master.tar.gz


# Install NEST \
COPY pathlib-nest-3.1.patch  ./
RUN wget https://github.com/nest/nest-simulator/archive/refs/tags/v3.1.tar.gz && \
    mkdir nest-build && \
    tar zxf v3.1.tar.gz && \
    cp pathlib-nest-3.1.patch ./nest-simulator-3.1 && \
    cd ./nest-simulator-3.1  && patch -p1 --verbose < pathlib-nest-3.1.patch && \
    cd  ../nest-build && \
    cmake -DCMAKE_INSTALL_PREFIX:PATH=/opt/nest/ \
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
        ../nest-simulator-3.1 && \
    make

RUN python3 -m pip install -r ../nest-simulator-3.1/extras/nest-simulator-doc-requirements.txt && \
    python3 -m pip install MarkupSafe==2.0.1 && \
    cd  nest-build && make html && make install


###############################################################################

FROM ubuntu:focal
LABEL maintainer="s.graber@fz-juelich.de"

ENV TERM=xterm \
    TZ=Europe/Berlin \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        libpcre3 \
        libpcre3-dev \
        gosu \
        jupyter-notebook \
        less \
        libgomp1 \
        libgsl-dev  \
        libltdl7 \
        libopenmpi-dev \
        libomp-dev \
        libpython3.8 \
        nano \
        openmpi-bin \
        openssh-client \
        openssh-server \
        python3-dev \
        python3-flask \
        python3-flask-cors \
        python3-restrictedpython \
        python3-matplotlib \
        python3-mpi4py \
        python3-numpy \
        python3-pip \
        python3-scipy \
        python3-setuptools \
        python3-pandas \
        python3-sympy \
        python3-tk \
        wget  && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3 10 && \
    update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 10 && \
    python3 -m pip install quantities lazyarray neo  && \
    python3 -m pip install uwsgi &&\
    # wget https://github.com/NeuralEnsemble/PyNN/archive/nest-dev.tar.gz && \
    # tar -xzf nest-dev.tar.gz && \
    # cd PyNN-nest-dev && \
    # python3 setup.py install && \
    # cd .. && rm -rf PyNN-nest-dev && rm nest-dev.tar.gz
    python3 -m pip install --no-binary :all: PyNN && \
    python3 -m pip install Flask  --user && \
    python3 -m pip install Flask-cors  --user && \
    python3 -m pip install RestrictedPython  --user && \
    python3 -m pip install nest-desktop --user &&\
    python3 -m pip install uwsgi --user &&\
    python3 -m pip install jupyterlab --user &&\
    python3 -m pip install nestml --user

COPY --from=builder31 /opt/nest /opt/nest
COPY --from=builder31 /opt/music-install /opt/music-install

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 5000 8000 8080
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
