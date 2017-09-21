# Pull base image.
FROM ubuntu:16.04

ARG WITH_MPI
ARG WITH_GSL
ARG WITH_MUSIC
ARG WITH_LIBNEUROSIM

RUN apt-get update
# RUN apt-get upgrade -y

# install basics
RUN apt-get install -y software-properties-common \
  git \
  wget \
  gcc \
  python3 \
  python3-dev \
  python \
  python-dev \
   \clang-format
  autoconf

RUN apt-get install -y build-essential \
  cmake \
  libltdl7-dev \
  libreadline6-dev \
  libncurses5-dev \
  libgsl0-dev \
  python3-all-dev \
  python3-numpy \
  python3-scipy \
  python3-matplotlib \
  python3-sympy \
  python-statsmodels \
  ipython3

RUN apt-get autoremove

# Install pip and Cython.
WORKDIR /tmp
RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python get-pip.py
RUN pip install setuptools
RUN pip install path.py
RUN pip install pandas
RUN pip install cython==0.23.4

# Install OpenMPI.
# TODO: conditional install
RUN apt-get install -y openmpi-bin libopenmpi-dev

# Install nose framework for the Python testsuite.
RUN apt-get install -y python3-nose

#Install VERA++ and pep8 for static code analysis.
RUN apt-get install -y vera++ pep8

# Required for building cppcheck-1.69.
RUN apt-get install -y libpcre3 libpcre3-dev

# Install jq to process JSON output from GitHub API.
RUN apt-get install -y jq

# Install current MUSIC version  (/usr/local/lib)
# TODO: conditional install
WORKDIR /tmp
RUN apt-get install -y python-mpi4py
RUN git clone https://github.com/INCF/MUSIC.git music
WORKDIR /tmp/music
RUN chmod +x autogen.sh
RUN ./autogen.sh
RUN chmod +x configure
RUN ./configure
RUN make
RUN make install

# Install libneurosim (/usr/local/lib)
# TODO: conditional install
WORKDIR /tmp
RUN git clone https://github.com/INCF/libneurosim.git libneurosim
WORKDIR /tmp/libneurosim
RUN chmod +x autogen.sh
RUN ./autogen.sh
RUN chmod +x configure
RUN ./configure
RUN make
RUN make install

# add user 'nest'
RUN adduser --disabled-login --gecos 'NEST' nest
WORKDIR /home/nest/
RUN mkdir data
RUN chown -R nest:nest data/