FROM buildpack-deps:focal as buildermaster
LABEL maintainer="s.graber@fz-juelich.de"

ARG WITH_MPI=ON
ARG WITH_OMP=ON
ARG WITH_GSL=ON
#ARG WITH_MUSIC=ON
ARG WITH_LIBNEUROSIM=OFF

ENV TERM=xterm \
    TZ=Europe/Berlin \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential libtool automake autotools-dev libreadline8 libreadline-dev freeglut3-dev \
    gosu \
    cmake \
    cython3 \
    mpich \
    libmpich-dev \
    jq \
    libboost1.67-dev \
    libgomp1 \
    libgsl-dev \
    libltdl7 \
    libltdl-dev \
    libmusic1v5 \
    libomp-dev \
    libpcre3 \
    libpcre3-dev \
    libpython3.8 \
    llvm-dev \
    pep8 \
    python3-dev \
    python3-ipython \
    python3-jupyter-core \
    python3-matplotlib \
    python3-nose \
    python3-numpy \
    python3-pandas \
    python3-path \
    python3-pip \
    python3-scipy \
    python3-setuptools \
    python3-statsmodels \
    python3-tk \
    python-dev \
    vera++ \
    wget  && \
#    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    # update-alternatives --remove-all python && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3 10 && \
    update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 10

RUN pip3 install mpi4py
RUN pip3 install docopt

## Install music
#RUN wget https://github.com/INCF/MUSIC/archive/master.tar.gz && \
#	tar -zxf master.tar.gz && \
#	mkdir music-build music-install && \
#	cd MUSIC-master && \
#	sh ./autogen.sh && \
#	cd ../music-build && \
#	../MUSIC-master/configure --prefix=/opt/music-install && \
#	make && \
#	make install && \
#	cd / && \
#    rm master.tar.gz

# Install libneurosim
# RUN git clone https://github.com/INCF/libneurosim.git libneurosim && \
#    cd libneurosim && \
#    chmod +x autogen.sh && \
#    ./autogen.sh && \
#    chmod +x configure && \
#    ./configure --prefix=/opt/libneurosim-install --with-python=3 && \
#    make && \
#    make install

# Install NEST
#RUN git clone https://github.com/nest/nest-simulator.git && \
RUN git clone https://github.com/jougs/nest-simulator.git && \
  cd nest-simulator && \
  git checkout --track origin/nest-server-mpi && \
  cd .. && \
  mkdir nest-build && \
  ls -l && \
  cd  nest-build && \
  cmake -DCMAKE_INSTALL_PREFIX:PATH=/opt/nest/ \
        # -Dwith-optimize=ON \
		# -Dwith-warning=ON \
		-Dwith-ltdl=ON \
	    -Dwith-gsl=$WITH_GSL \
	    -Dwith-readline=ON \
        -Dwith-python=ON \
        -DPYTHON_LIBRARY=/usr/lib/x86_64-linux-gnu/libpython3.8.so \
	    -DPYTHON_INCLUDE_DIR=/usr/include/python3.8 \
        -Dwith-mpi=/usr \
        -Dwith-openmp=$WITH_OMP \
        -Dwith-libneurosim=$WITH_LIBNEUROSIM \
        ../nest-simulator && \
  make && \
  make install
#-Dwith-music=/opt/music-install \


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
        mpich \
        libmpich-dev \
        less \
        libgomp1 \
        libgsl-dev  \
        libltdl7 \
        libomp-dev \
        libpython3.8 \
        nano \
        openssh-client \
        openssh-server \
        python3-dev \
        python3-flask \
        python3-flask-cors \
        python3-restrictedpython \
        python3-matplotlib \
        python3-numpy \
        python3-pip \
        python3-scipy \
        python3-setuptools \
        python3-pandas \
        python3-sympy \
        python3-tk \
        wget  && \
#    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3 10 && \
    update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 10 && \
    pip install quantities lazyarray neo  && \
    pip install uwsgi &&\
    # wget https://github.com/NeuralEnsemble/PyNN/archive/nest-dev.tar.gz && \
    # tar -xzf nest-dev.tar.gz && \
    # cd PyNN-nest-dev && \
    # python3 setup.py install && \
    # cd .. && rm -rf PyNN-nest-dev && rm nest-dev.tar.gz
    pip install --no-binary :all: PyNN

RUN pip3 install mpi4py
RUN pip3 install docopt

COPY --from=buildermaster /opt/nest /opt/nest
#COPY --from=buildermaster /opt/music-install /opt/music-install

RUN adduser --disabled-login --gecos 'NEST' --home /home/nest nest && \
    chown nest:nest /home/nest

# copy entrypoint to nest home folder
COPY entrypoint.sh /home/nest
RUN chown nest:nest /home/nest/entrypoint.sh && \
    chmod +x /home/nest/entrypoint.sh && \
    echo '. /opt/nest/bin/nest_vars.sh' >> /home/nest/.bashrc

WORKDIR /home/nest
USER nest
#ENTRYPOINT ["/home/nest/entrypoint.sh"]


#COPY entrypoint.sh /usr/local/bin/entrypoint.sh
#RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 5000 8080
#ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
