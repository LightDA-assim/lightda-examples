cmake_minimum_required(VERSION 3.10)

include(ExternalProject)

project(lenkf-rsm)

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
  "git@gitlab.hpc.mil:john.haiducek.ctr/fortran_exceptions.git" CACHE STRING
  "URL of fortran_exceptions git repository")

set(
  lightda_GIT_URL
  "git@gitlab.hpc.mil:john.haiducek.ctr/lightda.git" CACHE STRING
  "URL of LightDA git repository")

set(
  lightda-lenkf-rsm_GIT_URL
  "git@gitlab.hpc.mil:john.haiducek.ctr/lightda-lenkf-rsm.git" CACHE STRING
  "URL of lightda-lenkf-rsm git repository")

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
        -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_CURRENT_BINARY_DIR}/hdf5_exceptions)

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

ExternalProject_Add(lightda-examples
  SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/..
  CMAKE_CACHE_ARGS
    -Dsystem_mpi_DIR:STRING=${CMAKE_CURRENT_BINARY_DIR}/system_mpi/lib/cmake/system_mpi
    -Dfortran_exceptions_DIR:STRING=${CMAKE_CURRENT_BINARY_DIR}/fortran_exceptions/lib/cmake/fortran_exceptions
    -Dlightda_DIR:STRING=${CMAKE_CURRENT_BINARY_DIR}/lightda/lib/cmake/lightda
    -Dlightda-lenkf-rsm_DIR:STRING=${CMAKE_CURRENT_BINARY_DIR}/lightda-lenkf-rsm/lib/cmake/lightda-lenkf-rsm
    -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_CURRENT_BINARY_DIR}/lightda-examples
  DEPENDS lightda lightda-lenkf-rsm)