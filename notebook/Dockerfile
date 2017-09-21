FROM nest/master

USER root
# Install NEST 2.12.0
WORKDIR /home/nest
RUN su nest -c 'wget https://github.com/nest/nest-simulator/releases/download/v2.12.0/nest-2.12.0.tar.gz'
RUN su nest -c 'tar -xvzf nest-2.12.0.tar.gz'
RUN su nest -c 'mkdir /home/nest/nest-build'
RUN su nest -c 'mkdir /home/nest/nest-install'
WORKDIR /home/nest/nest-build
RUN su nest -c 'cmake -DCMAKE_INSTALL_PREFIX:PATH=/home/nest/nest-install \
    -Dwith-python=3 \
    -Dwith-mpi:BOOL=$WITH_MPI \
    -Dwith-gsl:BOOL=$WITH_GSL /usr/local/lib \
    -Dwith-libneurosim:BOOL=$WITH_LIBNEUROSIM /usr/local/lib \
    -Dwith-music=$WITH_MUSIC /usr/local/lib ../nest-2.12.0'
RUN su nest -c 'make'
RUN su nest -c 'make install'
# RUN su nest -c 'make installcheck'

# Install jupyter notebook
WORKDIR /tmp
# RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python3 get-pip.py

RUN pip3 install --upgrade pip
RUN pip3 install jupyter
RUN pip3 install statsmodels
WORKDIR /home/nest/

# Load NEST with every start.
RUN su nest -c "echo '. /home/nest/nest-install/bin/nest_vars.sh' >> /home/nest/.bashrc"

RUN apt-get install nano -y
RUN apt-get autoremove

WORKDIR /home/nest/data

EXPOSE 8080
COPY ./justart.sh /home/nest/
RUN chown nest:nest /home/nest/justart.sh
RUN chmod +x /home/nest/justart.sh
ENTRYPOINT ["/home/nest/justart.sh"]