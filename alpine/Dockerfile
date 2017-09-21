FROM alpine:edge


RUN	apk add --update alpine-sdk wget make g++ autoconf automake cmake gcc \
	python python-dev \
	clang libltdl libtool readline ncurses ncurses-dev \
	python3 python3-dev \
	freetype freetype-dev libpng libjpeg-turbo imagemagick graphviz \
	py3-numpy py-numpy-dev


# We do not need really need git -> using wget for downloas
#	apk add git

RUN apk add openblas --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/community/ --allow-untrusted
RUN apk add openblas-dev --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/community/ --allow-untrusted
RUN apk add lapack --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/community/ --allow-untrusted
#RUN apk add lapack-dev --update-cache --repository http://dl-3.alpinelinux
#.org/alpine/edge/community/ --allow-untrusted



# pip3 is installed with python3
# Do we need pip?
RUN	apk --update add py-pip
RUN pip install setuptools
RUN pip install path.py
RUN pip install pandas
RUN pip install cython==0.23.4

RUN pip3 install --upgrade pip

RUN pip3 install jupyter

RUN pip3 install sympy


#RUN pip3 install matplotlib
# RUN pip3 install scipy


RUN apk add py-scipy --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted

RUN apk add py-matplotlib --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted

RUN apk add openmpi --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted

RUN apk add openmpi-dev --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted

# Only for installcheck
# RUN pip3 install nose

RUN pip3 install statsmodels

WORKDIR /tmp

# GSL

RUN apk add --update gsl

	# wget http://ftp.halifax.rwth-aachen.de/gnu/gsl/gsl-latest.tar.gz
	# tar -xvzf gsl-latest.tar.gz
	# cd gsl-*
	# ./configure
	# make && sudo make install

# libneurosim (/usr/local/lib)
WORKDIR /tmp
RUN wget  https://github.com/INCF/libneurosim/archive/master.zip -O libneurosim.zip
RUN unzip libneurosim.zip
WORKDIR /tmp/libneurosim-master
RUN chmod +x autogen.sh
RUN ./autogen.sh
RUN chmod +x configure
RUN ./configure
RUN make
RUN make install


# music
# TODO: MAKE crashes
# WORKDIR /tmp
# RUN pip install mpi4py
# RUN wget https://github.com/INCF/MUSIC/archive/master.zip -O music.zip
# RUN unzip music.zip
# WORKDIR /tmp/MUSIC-master
# RUN chmod +x autogen.sh
# RUN ./autogen.sh
# RUN chmod +x configure
# RUN ./configure
# RUN make

# add user 'nest'
RUN adduser -D -h /home/nest -g 'NEST' nest

WORKDIR /home/nest/

RUN mkdir data

RUN chown -R nest:nest data/

# NEST
RUN echo 'BEGIN NEST'
RUN su nest -c 'wget https://github.com/nest/nest-simulator/releases/download/v2.12.0/nest-2.12.0.tar.gz -O nest.tar.gz'
RUN su nest -c 'tar -xvzf nest.tar.gz'
RUN su nest -c 'mkdir /home/nest/nest-build'
RUN su nest -c 'mkdir /home/nest/nest-install'
WORKDIR /home/nest/nest-build

# RUN su nest -c 'cmake -DCMAKE_INSTALL_PREFIX:PATH=/home/nest/nest-install \
#
#     -Dwith-python=3 \
#     -Dwith-mpi:BOOL=$WITH_MPI \
#     -Dwith-gsl:BOOL=$WITH_GSL /usr/local/lib \
#     -Dwith-libneurosim:BOOL=$WITH_LIBNEUROSIM /usr/local/lib \
#     -Dwith-music=$WITH_MUSIC /usr/local/lib ../nest-2.12.0'

RUN su nest -c 'cmake -DCMAKE_INSTALL_PREFIX:PATH=/home/nest/nest-install \
    -Dwith-python:=2 ../nest-2.12.0'

RUN su nest -c 'make'

RUN su nest -c 'make install'
# RUN su nest -c 'make installcheck'

# Load NEST with every start.

RUN su nest -c "echo '. /home/nest/nest-install/bin/nest_vars.sh' >> /home/nest/.bashrc"

WORKDIR /home/nest/data
