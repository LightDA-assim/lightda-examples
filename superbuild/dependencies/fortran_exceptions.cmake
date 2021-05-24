include(ExternalProject)

set(
  fortran_exceptions_GIT_URL
  "git@gitlab.hpc.mil:john.haiducek.ctr/fortran_exceptions.git" CACHE STRING
  "URL of fortran_exceptions git repository")

set(fortran_exceptions_INSTALL_DIR
  "${CMAKE_CURRENT_BINARY_DIR}/fortran_exceptions" CACHE PATH
  "fortran_exceptions installation directory")

set(fortran_exceptions_DIR
  "${fortran_exceptions_INSTALL_DIR}/lib/cmake/fortran_exceptions" CACHE PATH
  "fortran_exceptions installation directory")

ExternalProject_Add(
  fortran_exceptions
  GIT_REPOSITORY ${fortran_exceptions_GIT_URL}
  GIT_TAG main
  CMAKE_CACHE_ARGS
    -DPYTHON_EXECUTABLE:PATH=${PYTHON_EXECUTABLE}
        -DCMAKE_INSTALL_PREFIX:PATH=${fortran_exceptions_INSTALL_DIR})

