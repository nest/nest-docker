#!/usr/bin/env bash

# run.sh
#
# This file is part of NEST.
#
# Copyright (C) 2004 The NEST Initiative

# Define version arrays for easier maintenance
LEGACY_VERSIONS=("2.12.0" "2.14.0" "2.14.2" "2.16.0" "2.18.0" "2.20.0" "2.20.1" "2.20.2")
NEST3_VERSIONS=("3.0" "3.1" "3.2" "3.3" "3.4" "3.5" "3.6" "3.7" "3.8" "3.9")
SPECIAL_VERSIONS=("dev" "latest_daint")
ALL_VERSIONS=("${LEGACY_VERSIONS[@]}" "${NEST3_VERSIONS[@]}" "${SPECIAL_VERSIONS[@]}")

# Helper function to join array elements
join_array() {
    local IFS="$1"
    shift
    echo "$*"
}

# Helper function to check if version is valid
is_valid_version() {
    local version="$1"
    for v in "${ALL_VERSIONS[@]}"; do
        [[ "$v" == "$version" ]] && return 0
    done
    return 1
}

# Helper function to build Docker image
build_image() {
    local version="$1"
    local parallel="$2"
    local no_cache="$3"
    local build_opts=""
    
    # Add no-cache option if requested
    if [[ "$no_cache" == "true" ]]; then
        build_opts="--no-cache"
    elif [[ -n "$DOCKER_BUILDKIT" ]] && [[ "$DOCKER_BUILDKIT" == "1" ]]; then
        # Add build cache options for faster builds
        build_opts="--cache-from nest/nest-simulator:$version"
    fi
    
    echo "Building NEST image for version $version$([ "$no_cache" == "true" ] && echo " (no cache)")..."
    if [[ "$parallel" == "true" ]]; then
        docker build $build_opts -t nest/nest-simulator:"$version" ./src/"$version" &
    else
        docker build $build_opts -t nest/nest-simulator:"$version" ./src/"$version"
    fi
}
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
	list)
	    command=list
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
        echo "Provisioning options:"
        echo "  Individual versions: $(join_array ', ' "${ALL_VERSIONS[@]}")"
        echo "  Special commands: 'all', 'all-parallel', 'base'"
        echo "  Use --no-cache to force rebuild without cache"
        echo
        
        # Check for --no-cache flag
        no_cache="false"
        args=()
        for arg in "$@"; do
            if [[ "$arg" == "--no-cache" ]]; then
                no_cache="true"
            else
                args+=("$arg")
            fi
        done
        
        for arg in "${args[@]}"; do
            if is_valid_version "$arg"; then
                build_image "$arg" "false" "$no_cache"
                echo "Finished building $arg!"
            elif [[ "$arg" == "base" ]]; then
                echo "Building NEST base images..."
                docker build -t nest/nest-simulator:nest-simulator-build-base --file ./src/base/Dockerfile-build-base ./src/base/
                docker build -t nest/nest-simulator:nest-simulator-deploy-base --file ./src/base/Dockerfile-deploy-base ./src/base/
                echo "Finished building base images!"
            elif [[ "$arg" == "all" ]]; then
                echo "Building all NEST images sequentially$([ "$no_cache" == "true" ] && echo " (no cache)")..."
                echo "Versions: $(join_array ', ' "${ALL_VERSIONS[@]}")"
                for version in "${ALL_VERSIONS[@]}"; do
                    build_image "$version" "false" "$no_cache"
                done
                echo "Finished building all images!"
            elif [[ "$arg" == "all-parallel" ]]; then
                echo "Building all NEST images in parallel$([ "$no_cache" == "true" ] && echo " (no cache)") (faster but uses more resources)..."
                echo "Versions: $(join_array ', ' "${ALL_VERSIONS[@]}")"
                for version in "${ALL_VERSIONS[@]}"; do
                    build_image "$version" "true" "$no_cache"
                done
                echo "Waiting for all builds to complete..."
                wait
                echo "Finished building all images in parallel!"
            else
                echo "Error: Unrecognized option '$arg'"
                echo "Use --help to see available options"
                command=help
                break
            fi
        done
	;;
    list)
        echo
        echo "Available NEST versions:"
        echo "  Legacy versions (2.x): $(join_array ', ' "${LEGACY_VERSIONS[@]}")"
        echo "  NEST 3.x versions:     $(join_array ', ' "${NEST3_VERSIONS[@]}")"
        echo "  Special versions:      $(join_array ', ' "${SPECIAL_VERSIONS[@]}")"
        echo
        echo "Available run modes: notebook, jupyterlab, interactive"
        echo
        echo "Available provision commands: all, all-parallel, base, <version>"
        echo
        ;;
    run)
        if [[ $# -lt 2 ]]; then
            echo
            echo "Run command syntax:"
            echo "  ./run.sh run <MODE> <VERSION>"
            echo
            echo "Available modes: notebook, jupyterlab, interactive"
            echo "Available versions: $(join_array ', ' "${ALL_VERSIONS[@]}")"
            echo
            echo "Examples:"
            echo "  ./run.sh run notebook 3.9"
            echo "  ./run.sh run jupyterlab dev"
            echo "  ./run.sh run interactive 3.8"
            exit 1
        fi
        
        mode="$1"
        version="$2"
        
        if ! is_valid_version "$version"; then
            echo "Error: Invalid version '$version'"
            echo "Available versions: $(join_array ', ' "${ALL_VERSIONS[@]}")"
            exit 1
        fi
        
        docker_opts="-it --rm -e LOCAL_USER_ID=$(id -u $USER) --name nest_${mode}_${version} -v $(pwd):/opt/data -p 8080:8080"
        
        case "$mode" in
            notebook)
                echo "Starting NEST-$version with Jupyter Notebook..."
                docker run $docker_opts -e NEST_CONTAINER_MODE=notebook nest/nest-simulator:"$version"
                ;;
            jupyterlab)
                echo "Starting NEST-$version with JupyterLab..."
                docker run $docker_opts -e NEST_CONTAINER_MODE=jupyterlab nest/nest-simulator:"$version"
                ;;
            interactive)
                echo "Starting NEST-$version in interactive mode..."
                docker run $docker_opts -e NEST_CONTAINER_MODE=interactive nest/nest-simulator:"$version"
                ;;
            *)
                echo "Error: Invalid mode '$mode'"
                echo "Available modes: notebook, jupyterlab, interactive"
                exit 1
                ;;
        esac
        shift 2
    ;;
	clean)
        echo
        echo "Stops every container and deletes the NEST Images."
        echo
        docker stop $(docker ps -a -q) 2>/dev/null || true
        docker images -a | grep "nest" | awk '{print $3}' | xargs docker rmi 2>/dev/null || true
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
