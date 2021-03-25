include(ExternalProject)

set(
  fortran_exceptions_GIT_URL
  "git@gitlab.hpc.mil:john.haiducek.ctr/fortran_exceptions.git" CACHE STRING
  "URL of fortran_exceptions git repository")

set(fortran_exceptions_INSTALL_DIR
  "${CMAKE_CURRENT_BINARY_DIR}/fortran_exceptions" CACHE STRING
  "fortran_exceptions installation directory")

ExternalProject_Add(
  fortran_exceptions
  GIT_REPOSITORY ${fortran_exceptions_GIT_URL}
  GIT_TAG main
  CMAKE_CACHE_ARGS
        -DCMAKE_INSTALL_PREFIX:PATH=${fortran_exceptions_INSTALL_DIR})

