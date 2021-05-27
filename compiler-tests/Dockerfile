ARG compiler_image=gcc:latest
FROM $compiler_image AS build_base

RUN if command -v apt-get; then apt-get update; fi
RUN if command -v apt-get; then apt-get -y install cmake git; fi
RUN if command -v yum; then yum -y install cmake git; fi
RUN if [ $(sed -n 's/^ID=//p' /etc/os-release) == "fedora" ]; then yum -y install lbzip2; fi
RUN if command -v yum; then yum -y install gcc-gfortran gcc-c++; fi

ARG FC=gfortran
ARG FFLAGS="-g -fbacktrace -std=f2008 -fcheck=all"
ARG CC=gcc
ARG CXX=g++

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
ADD https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.1.tar.bz2 .
RUN chown build:build openmpi-4.1.1.tar.bz2
RUN if command -v yum; then yum -y install valgrind-devel findutils; fi
RUN if command -v apt-get; then apt-get install -y valgrind; fi

USER build

RUN tar xf openmpi-4.1.1.tar.bz2
WORKDIR /build/openmpi-4.1.1
RUN ./configure --prefix=/usr/local/openmpi --with-valgrind
RUN make -j8 all
USER root
RUN make install

FROM build_base AS build_with_ford

USER root
RUN if command -v apt-get; then apt-get install -y liblapack-dev python3-pip; fi
RUN if command -v yum; then yum -y install lapack-devel python3 python3-pip; fi
RUN pip3 install fprettify ford

USER build

FROM build_with_ford AS build_with_mpi

USER root
COPY --from=openmpi-build /usr/local/openmpi/ /usr/local/openmpi/
USER build

FROM build_with_mpi as system_mpi-build

USER root
COPY --from=system_mpi-repo / /repositories

USER build

ENV MPI_HOME=/usr/local/openmpi
ENV PATH=/usr/local/openmpi/bin:$PATH

RUN git clone --branch main /repositories/system_mpi.git
RUN mkdir build
RUN cd /build/build
RUN cmake \
  -DMPI_Fortran_COMPILER=/usr/local/openmpi/bin/mpif90 \
  -DMPI_C_COMPILER=/usr/local/openmpi/bin/mpicc \
  -DPYTHON_EXECUTABLE:PATH=/usr/bin/python3 \
  -DCMAKE_INSTALL_PREFIX:PATH=/build/install \
  /build/system_mpi
RUN make -j8
RUN make install

FROM build_with_ford as fortran_exceptions-build

USER root
COPY --from=fortran_exceptions-repo / /repositories

USER build

WORKDIR /build
RUN git clone --branch main /repositories/fortran_exceptions.git
RUN mkdir build
WORKDIR /build/build
RUN cmake \
  -DPYTHON_EXECUTABLE:PATH=/usr/bin/python3 \
  -DCMAKE_INSTALL_PREFIX:PATH=/build/install \
  /build/fortran_exceptions
RUN make -j8
RUN make install

FROM build_with_ford as hdf5_exceptions-build

USER root
COPY --from=hdf5-build /usr/local/hdf5/ /usr/local/hdf5
COPY --from=fortran_exceptions-build /build/install /build/install
COPY --from=hdf5_exceptions-repo / /repositories

USER build

ENV HDF5_ROOT=/usr/local/hdf5

RUN git clone --branch main /repositories/hdf5_exceptions.git
RUN mkdir build
RUN cd /build/build
RUN cmake \
  -Dfortran_exceptions_DIR:PATH=/build/install/lib/cmake/fortran_exceptions \
  -DPYTHON_EXECUTABLE:PATH=/usr/bin/python3 \
  -DCMAKE_INSTALL_PREFIX:PATH=/build/install \
  /build/hdf5_exceptions
RUN make -j8
RUN make install

FROM build_with_mpi as lightda-build

USER root
COPY --from=fortran_exceptions-build /build/install /build/install
COPY --from=system_mpi-build /build/install /build/install
COPY --from=lightda-repo / /repositories

USER build

ENV MPI_HOME=/usr/local/openmpi
ENV PATH=/usr/local/openmpi/bin:$PATH

RUN git clone --branch main /repositories/lightda.git
RUN mkdir build
RUN cd /build/build

RUN cmake \
  -Dfortran_exceptions_DIR:PATH=/build/install/lib/cmake/fortran_exceptions \
  -Dsystem_mpi_DIR:PATH=/build/install/lib/cmake/system_mpi \
  -DMPI_Fortran_COMPILER=/usr/local/openmpi/bin/mpif90 \
  -DMPI_C_COMPILER=/usr/local/openmpi/bin/mpicc \
  -DPYTHON_EXECUTABLE:PATH=/usr/bin/python3 \
  -DCMAKE_INSTALL_PREFIX:PATH=/build/install \
  /build/lightda
RUN make -j8
RUN make install

FROM build_with_mpi as lightda_lenkf_rsm-build

USER root
COPY --from=fortran_exceptions-build /build/install /build/install
COPY --from=system_mpi-build /build/install /build/install
COPY --from=lightda-build /build/install /build/install
COPY --from=lightda_lenkf_rsm-repo / /repositories

USER build

ENV MPI_HOME=/usr/local/openmpi
ENV PATH=/usr/local/openmpi/bin:$PATH

RUN git clone --branch main /repositories/lightda-lenkf-rsm.git
RUN mkdir build
RUN cd /build/build

RUN cmake \
  -Dfortran_exceptions_DIR:PATH=/build/install/lib/cmake/fortran_exceptions \
  -Dsystem_mpi_DIR:PATH=/build/install/lib/cmake/system_mpi \
  -Dlightda_DIR:PATH=/build/install/lib/cmake/lightda \
  -DMPI_Fortran_COMPILER=/usr/local/openmpi/bin/mpif90 \
  -DMPI_C_COMPILER=/usr/local/openmpi/bin/mpicc \
  -DPYTHON_EXECUTABLE:PATH=/usr/bin/python3 \
  -DCMAKE_INSTALL_PREFIX:PATH=/build/install \
  /build/lightda-lenkf-rsm
RUN make -j8
RUN make install

FROM build_with_mpi as lightda-examples-build

USER root

COPY --from=hdf5-build /usr/local/hdf5/ /usr/local/hdf5
COPY --from=lightda-examples-src / /src
COPY --from=system_mpi-build /build/install /build/install
COPY --from=fortran_exceptions-build /build/install /build/install
COPY --from=hdf5_exceptions-build /build/install /build/install
COPY --from=lightda-build /build/install /build/install
COPY --from=lightda_lenkf_rsm-build /build/install /build/install

USER build

ENV MPI_HOME=/usr/local/openmpi
ENV PATH=/usr/local/openmpi/bin:$PATH

ENV HDF5_ROOT=/usr/local/hdf5

RUN mkdir build
WORKDIR /build/build
RUN cmake \
  -Dfortran_exceptions_DIR:PATH=/build/install/lib/cmake/fortran_exceptions \
  -Dhdf5_exceptions_DIR:PATH=/build/install/lib/cmake/hdf5_exceptions \
  -Dsystem_mpi_DIR:PATH=/build/install/lib/cmake/system_mpi \
  -Dlightda_DIR:PATH=/build/install/lib/cmake/lightda \
  -Dlightda-lenkf-rsm_DIR:PATH=/build/install/lib/cmake/lightda-lenkf-rsm \
  -DMPI_Fortran_COMPILER=/usr/local/openmpi/bin/mpif90 \
  -DMPI_C_COMPILER=/usr/local/openmpi/bin/mpicc \
  -DPYTHON_EXECUTABLE:PATH=/usr/bin/python3 \
  /src
RUN make -j8
