cmake_minimum_required(VERSION 3.10)

project(lightda-examples-advect1d)

include(${CMAKE_CURRENT_SOURCE_DIR}/../../../superbuild/common_dependencies.cmake)

ExternalProject_Add(lightda-examples-advect1d
  SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/..
  CMAKE_CACHE_ARGS
    -Dsystem_mpi_DIR:STRING=${CMAKE_CURRENT_BINARY_DIR}/system_mpi/lib/cmake/system_mpi
    -Dfortran_exceptions_DIR:STRING=${CMAKE_CURRENT_BINARY_DIR}/fortran_exceptions/lib/cmake/fortran_exceptions
    -Dlightda_DIR:STRING=${CMAKE_CURRENT_BINARY_DIR}/lightda/lib/cmake/lightda
    -Dlightda-lenkf-rsm_DIR:STRING=${CMAKE_CURRENT_BINARY_DIR}/lightda-lenkf-rsm/lib/cmake/lightda-lenkf-rsm
    -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_CURRENT_BINARY_DIR}/lightda-examples-advect1d
  DEPENDS lightda lightda-lenkf-rsm)
