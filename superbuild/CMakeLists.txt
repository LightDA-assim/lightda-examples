cmake_minimum_required(VERSION 3.0.2)

project(lightda-examples)

find_package(PythonInterp)

include(common_dependencies.cmake)

ExternalProject_Add(lightda-examples
  SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/..
  CMAKE_CACHE_ARGS
    -DMPI_Fortran_COMPILER:PATH=${MPI_Fortran_COMPILER}
    -DMPI_C_COMPILER:PATH=${MPI_C_COMPILER}
    -Dsystem_mpi_DIR:PATH=${system_mpi_DIR}
    -Dfortran_exceptions_DIR:PATH=${fortran_exceptions_DIR}
    -Dhdf5_exceptions_DIR:PATH=${hdf5_exceptions_DIR}
    -Dhdf5_DIR:PATH=${HDF5_DIR}
    -DHDF5_DIR:PATH=${HDF5_DIR}
    -Dlightda_DIR:PATH=${lightda_DIR}
    -Dlightda-lenkf-rsm_DIR:PATH=${lightda-lenkf-rsm_DIR}
    -DPYTHON_EXECUTABLE:PATH=${PYTHON_EXECUTABLE}
    -DMPIEXEC_EXECUTABLE:PATH=${MPIEXEC_EXECUTABLE}
    -DMPIEXEC_PREFLAGS:STRING=${MPIEXEC_PREFLAGS}
    -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_CURRENT_BINARY_DIR}/lightda-examples
  DEPENDS lightda lightda-lenkf-rsm hdf5_exceptions)
