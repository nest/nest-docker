#!/usr/bin/env bash

# run.sh
#
# This file is part of NEST.
#
# Copyright (C) 2004 The NEST Initiative
#
# NEST is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# NEST is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with NEST.  If not, see <http://www.gnu.org/licenses/>.


if test $# -lt 1; then
    print_usage=true
else
    case "$1" in
	provision)
	    command=provision
	    ;;
	run)
	    command=run
	    ;;
	clean)
	    command=clean
	    ;;
	--help)
	    command=help
	    ;;
	*)
	    echo "Error: unknown command '$1'"
	    command=help
	    ;;
    esac
    shift
fi


case $command in
    provision)
        echo

        echo "Provisioning needs an argument: 'latest' 'latest_daint' '2.12.0', '2.14.0',"
        echo "'2.16.0', '2.18.0', '2.20.0', '2.20.1','3.0','3.1' or 'all'."
        echo
        while test $# -gt 0; do
            case "$1" in
            latest | latest_daint | 2.12.0 | 2.14.0 | 2.16.0 | 2.18.0 | 2.20.0 | 2.20.1 | 3.0 | 3.1)
                echo "Build the NEST image for NEST $1"
                echo
                docker build -t docker-registry.ebrains.eu/nest/nest-simulator:"$1" ./src/"$1"
                echo
                echo "Finished!"
                ;;
            all)
                echo "Build the NEST image for NEST 2.12.0, 2.14.0,"
                echo "2.16.0, 2.18.0, 2.20.0, 2.20.0, 3.0,, 3.1 latest and latest_daint"
                echo
                docker build -t nest/nest-simulator:2.12.0 ./src/2.12.0
                docker build -t nest/nest-simulator:2.14.0 ./src/2.14.0
                docker build -t nest/nest-simulator:2.16.0 ./src/2.16.0
                docker build -t nest/nest-simulator:2.18.0 ./src/2.18.0
                docker build -t nest/nest-simulator:2.20.0 ./src/2.20.0
                docker build -t nest/nest-simulator:2.20.1 ./src/2.20.1
                docker build -t nest/nest-simulator:3.0 ./src/3.0
                docker build -t nest/nest-simulator:3.1 ./src/3.1
                docker build -t nest/nest-simulator:latest ./src/latest
                docker build -t nest/nest-simulator:latest_daint ./src/latest_daint
                echo
                echo "Finished!"
                ;;
            *)
                echo "Error: Unrecognized option '$1'"
                command=help
                ;;
            esac
            shift
        done
	;;
    run)
        echo
        echo "Run needs three arguments:"
        echo
        echo "  - 'notebook VERSION'"
        echo "  - 'jupyterlab VERSION'"
        echo "  - 'interactive VERSION'"
        echo
        echo "VERSION is the version of NEST"
        echo "(e.g. latest, 2.12.0, 2.14.0, 2.16.0, 2.18.0, 2.20.0, 2.20.1, 3.0, 3.1)"
        echo
    LOCALDIR="$(pwd)"
    while test $# -gt 1; do
        case "$1" in
            notebook)
                case "$2" in
                    latest | 2.12.0 | 2.14.0 | 2.16.0 | 2.18.0 | 2.20.0 | 2.20.1 | 3.0 | 3.1 )
                    echo "Run NEST-$2 with Jupyter Notebook".
                    echo
                    docker run -it --rm -e LOCAL_USER_ID=`id -u $USER` --name my_app  \
							      -v $(pwd):/opt/data -e NEST_CONTAINER_MODE=notebook \
							      -p 8080:8080 docker-registry.ebrains.eu/nest/nest-simulator:"$2"
                    echo
                    ;;
                    *)
                    echo "Error: Unrecognized option '$2'"
                    command=help
                    ;;
                esac
            ;;
            jupyterlab)
                case "$2" in
                    latest | 2.12.0 | 2.14.0 | 2.16.0 | 2.18.0 | 2.20.0 | 2.20.1 | 3.0 | 3.1 )
                    echo "Run NEST-$2 with Jupyter Lab".
                    echo
                    docker run -it --rm -e LOCAL_USER_ID=`id -u $USER` --name my_app  \
							   -v $(pwd):/opt/data -e NEST_CONTAINER_MODE=jupyterlab \
							   -p 8080:8080 docker-registry.ebrains.eu/nest/nest-simulator:"$2"
                    echo
                    ;;
                    *)
                    echo "Error: Unrecognized option '$2'"
                    command=help
                    ;;
                esac
            ;;
            interactive)
                case "$2" in
                    latest | 2.12.0 | 2.14.0 | 2.16.0 | 2.18.0 | 2.20.0 | 2.20.1 | 3.0 | 3.1 )
                    echo "Run NEST-$2 in interactive mode."
                    echo
                    docker run -it --rm -e LOCAL_USER_ID=`id -u $USER` --name my_app  -e NEST_CONTAINER_MODE=interactive \
							      -p 8080:8080 docker-registry.ebrains.eu/nest/nest-simulator:"$2"
                    echo
                    ;;
                    *)
                    echo "Error: Unrecognized option '$2'"
                    command=help
                    ;;
                esac
            ;;
            *)
                    echo "Error: Unrecognized option '$2'"
                    command=help
                    ;;
        esac
        shift
    done
    ;;
	clean)
        echo
        echo "Stops every container and delete the NEST Images."
        echo
        docker stop $(docker ps -a -q)
        docker images -a | grep "nest" | awk '{print $3}' | xargs docker rmi
	    echo
	    echo "Done!"
	    echo
        echo "A list of the docker images on your machine:"
        docker images
	;;
	help)
	    echo
        more README.md
        echo
        exit 1
	;;
	*)
        echo
        more README.md
        echo
        exit 1
	;;
esac
