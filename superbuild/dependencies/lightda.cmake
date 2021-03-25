include(ExternalProject)

set(
  lightda_GIT_URL
  "git@gitlab.hpc.mil:john.haiducek.ctr/lightda.git" CACHE STRING
  "URL of LightDA git repository")

set(lightda_INSTALL_DIR
  "${CMAKE_CURRENT_BINARY_DIR}/lightda" CACHE STRING
  "LightDA installation directory")

ExternalProject_Add(lightda
  GIT_REPOSITORY ${lightda_GIT_URL}
  GIT_TAG main
  CMAKE_CACHE_ARGS
    -Dsystem_mpi_DIR:STRING=${CMAKE_CURRENT_BINARY_DIR}/system_mpi/lib/cmake/system_mpi
    -Dfortran_exceptions_DIR:STRING=${CMAKE_CURRENT_BINARY_DIR}/fortran_exceptions/lib/cmake/fortran_exceptions
    -DCMAKE_INSTALL_PREFIX:PATH=${lightda_INSTALL_DIR}
  DEPENDS system_mpi fortran_exceptions)
