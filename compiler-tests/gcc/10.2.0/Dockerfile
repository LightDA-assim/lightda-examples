FROM gcc:10.2.0

RUN apt-get update
RUN apt-get -y install cmake

COPY --from=lightda-examples-src / /src
COPY --from=lightda-examples-dependency-repos / /repositories

RUN mkdir /build

WORKDIR /build

RUN cmake \
  -Dsystem_mpi_GIT_URL=/repositories/system_mpi.git \
  -Dfortran_exceptions_GIT_URL=/repositories/fortran_exceptions.git \
  -Dhdf5_exceptions_GIT_URL=/repositories/hdf5_exceptions.git \
  -Dlightda_GIT_URL=/repositories/lightda.git \
  -Dlightda-lenkf-rsm_GIT_URL=/repositories/lightda-lenkf-rsm.git \
  /src/superbuild
RUN make -j8
RUN make install
