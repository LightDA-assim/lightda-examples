ARG compiler_image=gcc:latest
FROM $compiler_image AS gcc_cmake

RUN apt-get update
RUN apt-get -y install cmake

RUN useradd --home-dir /build build

USER build

WORKDIR /build

FROM gcc_cmake as hdf5-build

USER root

COPY hdf5/ /src
RUN mkdir /hdf5
RUN chown build:build /hdf5

USER build

RUN cmake -DHDF5_INSTALL_DIR=/hdf5 /src
RUN make -j8

USER root
RUN chown -R root:root /hdf5

FROM gcc_cmake as openmpi-build

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

FROM gcc_cmake as lightda-examples-build

USER root
RUN apt-get install -y liblapack-dev python3-pip
RUN pip3 install fprettify ford

COPY --from=hdf5-build /hdf5/ /usr/
COPY --from=openmpi-build /usr/local/openmpi/ /usr/local/openmpi/
COPY --from=lightda-examples-src / /src
COPY --from=lightda-examples-dependency-repos / /repositories

USER build

ENV MPI_HOME=/usr/local/openmpi

RUN cmake \
  -DMPI_Fortran_COMPILER=/usr/local/openmpi/bin/mpif90 \
  -DMPI_C_COMPILER=/usr/local/openmpi/bin/mpicc \
  -Dsystem_mpi_GIT_URL=/repositories/system_mpi.git \
  -Dfortran_exceptions_GIT_URL=/repositories/fortran_exceptions.git \
  -Dhdf5_exceptions_GIT_URL=/repositories/hdf5_exceptions.git \
  -DHDF5_DIR=/usr/share/cmake/hdf5 \
  -Dlightda_GIT_URL=/repositories/lightda.git \
  -Dlightda-lenkf-rsm_GIT_URL=/repositories/lightda-lenkf-rsm.git \
  /src/superbuild
RUN make -j8
