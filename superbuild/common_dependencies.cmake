include(ExternalProject)

set(
  system_mpi_GIT_URL
  "git@gitlab.hpc.mil:john.haiducek.ctr/system_mpi.git" CACHE STRING
  "URL of system_mpi git repository")

set(
  fortran_exceptions_GIT_URL
  "git@gitlab.hpc.mil:john.haiducek.ctr/fortran_exceptions.git" CACHE STRING
  "URL of fortran_exceptions git repository")

set(
  hdf5_exceptions_GIT_URL
  "git@gitlab.hpc.mil:john.haiducek.ctr/hdf5_exceptions.git" CACHE STRING
  "URL of fortran_exceptions git repository")

set(
  lightda_GIT_URL
  "git@gitlab.hpc.mil:john.haiducek.ctr/lightda.git" CACHE STRING
  "URL of LightDA git repository")

set(
  lightda-lenkf-rsm_GIT_URL
  "git@gitlab.hpc.mil:john.haiducek.ctr/lightda-lenkf-rsm.git" CACHE STRING
  "URL of lightda-lenkf-rsm git repository")

set(
  HDF5_GIT_URL
  "https://github.com/HDFGroup/hdf5.git" CACHE STRING
  "URL of HDF5 git repository")

enable_language(Fortran)
find_package(HDF5 COMPONENTS Fortran)

if(NOT ${HDF5_FOUND})
  ExternalProject_Add(
    HDF5
    GIT_REPOSITORY ${HDF5_GIT_URL}
    GIT_TAG hdf5-1_12_0
    UPDATE_COMMAND ""
    UPDATE_DISCONNECTED OFF
    CMAKE_CACHE_ARGS
      -DHDF5_BUILD_FORTRAN:BOOL=ON
      -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_CURRENT_BINARY_DIR}/HDF5)
  set(HDF5_DIR ${CMAKE_CURRENT_BINARY_DIR}/HDF5/share/cmake/hdf5)
else()
  add_custom_target(HDF5)
endif()

ExternalProject_Add(
  system_mpi
  GIT_REPOSITORY ${system_mpi_GIT_URL}
  GIT_TAG main
  CMAKE_CACHE_ARGS
        -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_CURRENT_BINARY_DIR}/system_mpi)

ExternalProject_Add(
  fortran_exceptions
  GIT_REPOSITORY ${fortran_exceptions_GIT_URL}
  GIT_TAG main
  CMAKE_CACHE_ARGS
        -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_CURRENT_BINARY_DIR}/fortran_exceptions)

ExternalProject_Add(
  hdf5_exceptions
  GIT_REPOSITORY ${hdf5_exceptions_GIT_URL}
  GIT_TAG main
  CMAKE_CACHE_ARGS
    -Dfortran_exceptions_DIR:STRING=${CMAKE_CURRENT_BINARY_DIR}/fortran_exceptions/lib/cmake/fortran_exceptions
    -DHDF5_DIR:PATH=${HDF5_DIR}
    -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_CURRENT_BINARY_DIR}/hdf5_exceptions
  DEPENDS HDF5)

ExternalProject_Add(lightda
  GIT_REPOSITORY ${lightda_GIT_URL}
  GIT_TAG main
  CMAKE_CACHE_ARGS
    -Dsystem_mpi_DIR:STRING=${CMAKE_CURRENT_BINARY_DIR}/system_mpi/lib/cmake/system_mpi
    -Dfortran_exceptions_DIR:STRING=${CMAKE_CURRENT_BINARY_DIR}/fortran_exceptions/lib/cmake/fortran_exceptions
    -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_CURRENT_BINARY_DIR}/lightda
  DEPENDS system_mpi fortran_exceptions)

ExternalProject_Add(lightda-lenkf-rsm
  GIT_REPOSITORY ${lightda-lenkf-rsm_GIT_URL}
  GIT_TAG main
  CMAKE_CACHE_ARGS
    -Dsystem_mpi_DIR:STRING=${CMAKE_CURRENT_BINARY_DIR}/system_mpi/lib/cmake/system_mpi
    -Dfortran_exceptions_DIR:STRING=${CMAKE_CURRENT_BINARY_DIR}/fortran_exceptions/lib/cmake/fortran_exceptions
    -Dlightda_DIR:STRING=${CMAKE_CURRENT_BINARY_DIR}/lightda/lib/cmake/lightda
    -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_CURRENT_BINARY_DIR}/lightda-lenkf-rsm
  DEPENDS lightda)

