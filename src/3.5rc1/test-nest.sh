#!/bin/bash

# run mpiexec as root
export OMPI_ALLOW_RUN_AS_ROOT=1
export OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1

# install what is needed
pip3 install pytest-xdist pytest-timeout junitparser


cd /opt/nest/share/nest/testsuite/
bash do_tests.sh --prefix=/opt/nest --report-dir=/opt/reports --with-python=/usr/bin/python