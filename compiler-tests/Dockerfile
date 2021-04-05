ARG compiler_image=gcc:latest
FROM $compiler_image AS build_base

RUN if command -v apt-get; then apt-get update; fi
RUN if command -v apt-get; then apt-get -y install cmake git; fi
RUN if command -v yum; then yum -y install cmake git; fi

ARG FC=gfortran
ARG FFLAGS="-g -fbacktrace -std=f2008 -fcheck=all"
ARG CC=gcc
ARG CXX=gxx

ENV FC=$FC
ENV F9X=$FC
ENV FFLAGS=$FFLAGS
ENV CC=$CC
ENV CXX=$CXX

RUN useradd --home-dir /build build

USER build

WORKDIR /build

ARG hdf5_tag=hdf5-1_12_0
FROM build_base as hdf5-build

USER root

COPY hdf5/ /src
RUN mkdir -p /usr/local/hdf5
RUN chown build:build /usr/local/hdf5

USER build
RUN cmake -DHDF5_INSTALL_DIR=/usr/local/hdf5 -DHDF5_GIT_TAG=$hdf5_tag /src
RUN make -j8

USER root
RUN chown -R root:root /usr/local/hdf5

FROM build_base as openmpi-build

USER root
ADD https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.0.tar.bz2 .
RUN chown build:build openmpi-4.1.0.tar.bz2

USER build

RUN tar xf openmpi-4.1.0.tar.bz2
WORKDIR /build/openmpi-4.1.0
RUN ./configure --prefix=/usr/local/openmpi
RUN make all
USER root
RUN make install

FROM build_base as lightda-examples-build

USER root
RUN if command -v apt-get; then apt-get install -y liblapack-dev python3-pip; fi
RUN if command -v yum; then yum -y install lapack-devel python3; fi
RUN pip3 install fprettify ford

COPY --from=hdf5-build /usr/local/hdf5/ /usr/local/hdf5
COPY --from=openmpi-build /usr/local/openmpi/ /usr/local/openmpi/
COPY --from=lightda-examples-src / /src
COPY --from=lightda-examples-dependency-repos / /repositories

USER build

ENV MPI_HOME=/usr/local/openmpi

ENV PATH=/usr/local/openmpi/bin:$PATH

RUN cmake \
  -DMPI_Fortran_COMPILER=/usr/local/openmpi/bin/mpif90 \
  -DMPI_C_COMPILER=/usr/local/openmpi/bin/mpicc \
  -Dsystem_mpi_GIT_URL=/repositories/system_mpi.git \
  -Dfortran_exceptions_GIT_URL=/repositories/fortran_exceptions.git \
  -Dhdf5_exceptions_GIT_URL=/repositories/hdf5_exceptions.git \
  -DHDF5_DIR=/usr/local/hdf5/share/cmake/hdf5 \
  -DHDF5_ROOT=/usr/local/hdf5 \
  -Dlightda_GIT_URL=/repositories/lightda.git \
  -Dlightda-lenkf-rsm_GIT_URL=/repositories/lightda-lenkf-rsm.git \
  /src/superbuild
RUN make -j8
