#!/bin/sh

set -e

LOCAL_REPO_DIR=/Users/jhaiduce/Development/repositories
IFORT_FFLAGS="-g -traceback -check all -standard-semantics -assume nostd_mod_proc_name -stand f08"

docker build -t lightda-examples-src -f Dockerfile.src .
docker build -t system_mpi-repo --build-arg repo=system_mpi.git -f Dockerfile.repos $LOCAL_REPO_DIR
docker build -t fortran_exceptions-repo --build-arg repo=fortran_exceptions.git -f Dockerfile.repos $LOCAL_REPO_DIR
docker build -t hdf5_exceptions-repo --build-arg repo=hdf5_exceptions.git -f Dockerfile.repos $LOCAL_REPO_DIR
docker build -t lightda-repo --build-arg repo=lightda.git -f Dockerfile.repos $LOCAL_REPO_DIR
docker build -t lightda_lenkf_rsm-repo --build-arg repo=lightda_lenkf_rsm.git -f Dockerfile.repos $LOCAL_REPO_DIR
docker build -t lightda-examples-gcc:latest --build-arg compiler_image=gcc:latest compiler-tests
docker build -t lightda-examples-oneapi:2021.2-devel-centos8 --build-arg compiler_image=intel/oneapi-hpckit:2021.2-devel-centos8 --build-arg CC=icc --build-arg CXX=icpc --build-arg FC=ifort --build-arg FFLAGS="$IFORT_FFLAGS" compiler-tests
docker build -t lightda-examples-oneapi:2021.2-devel-ubuntu18.04 --build-arg compiler_image=intel/oneapi-hpckit:2021.2-devel-ubuntu18.04 --build-arg CC=icc --build-arg CXX=icpc --build-arg FC=ifort --build-arg FFLAGS="$IFORT_FFLAGS" compiler-tests
docker build -t lightda-examples-gcc:4.9.4-hdf5-1_10-7 --build-arg compiler_image=gcc:4.9.4 --build-arg hdf5_tag=hdf5-1_10_7 compiler-tests
docker build -t lightda-examples-gcc:10.2.0 --build-arg compiler_image=gcc:10.2.0 compiler-tests
docker build -t lightda-examples-gcc:5.5.0-hdf5-1_10-7 --build-arg compiler_image=gcc:5.5.0 --build-arg hdf5_tag=hdf5-1_10_7 compiler-tests
docker build -t lightda-examples-gcc:6.5.0-hdf5-1_10-7 --build-arg compiler_image=gcc:6.5.0 --build-arg hdf5_tag=hdf5-1_10_7 compiler-tests
docker build -t lightda-examples-gcc:7.5.0-hdf5-1_10-7 --build-arg compiler_image=gcc:7.5.0 --build-arg hdf5_tag=hdf5-1_10_7 compiler-tests
docker build -t lightda-examples-gcc:8.4.0 --build-arg compiler_image=gcc:8.4.0 compiler-tests
docker build -t lightda-examples-gcc:9.3.0 --build-arg compiler_image=gcc:9.3.0 compiler-tests
