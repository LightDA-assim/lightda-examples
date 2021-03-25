cmake_minimum_required(VERSION 3.10)

project(lightda-examples)

include(common_dependencies.cmake)

ExternalProject_Add(lightda-examples
  SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/..
  CMAKE_CACHE_ARGS
    -Dsystem_mpi_DIR:STRING=${system_mpi_DIR}
    -Dfortran_exceptions_DIR:STRING=${fortran_exceptions_DIR}
    -Dhdf5_exceptions_DIR:STRING=${hdf5_exceptions_DIR}
    -Dhdf5_DIR:PATH=${HDF5_DIR}
    -Dlightda_DIR:STRING=${lightda_DIR}
    -Dlightda-lenkf-rsm_DIR:STRING=${lightda-lenkf-rsm_DIR}
    -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_CURRENT_BINARY_DIR}/lightda-examples
  DEPENDS lightda lightda-lenkf-rsm hdf5_exceptions)
