include(ExternalProject)

set(
  hdf5_exceptions_GIT_URL
  "git@gitlab.hpc.mil:john.haiducek.ctr/hdf5_exceptions.git" CACHE STRING
  "URL of fortran_exceptions git repository")

set(hdf5_exceptions_INSTALL_DIR
  "${CMAKE_CURRENT_BINARY_DIR}/hdf5_exceptions" CACHE PATH
  "hdf5_exceptions installation directory")

set(hdf5_exceptions_DIR
  "${hdf5_exceptions_INSTALL_DIR}/lib/cmake/hdf5_exceptions" CACHE PATH
  "hdf5_exceptions config directory")

ExternalProject_Add(
  hdf5_exceptions
  GIT_REPOSITORY ${hdf5_exceptions_GIT_URL}
  GIT_TAG main
  CMAKE_CACHE_ARGS
    -Dfortran_exceptions_DIR:PATH=${fortran_exceptions_DIR}
    -Dhdf5_DIR:PATH=${HDF5_DIR}
    -DHDF5_DIR:PATH=${HDF5_DIR}
    -DHDF5_ROOT:PATH=${HDF5_ROOT}
    -DCMAKE_INSTALL_PREFIX:PATH=${hdf5_exceptions_INSTALL_DIR}
  DEPENDS HDF5 fortran_exceptions)
