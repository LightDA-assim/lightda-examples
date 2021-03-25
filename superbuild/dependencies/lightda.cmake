include(ExternalProject)

set(
  lightda_GIT_URL
  "git@gitlab.hpc.mil:john.haiducek.ctr/lightda.git" CACHE STRING
  "URL of LightDA git repository")

set(lightda_INSTALL_DIR
  "${CMAKE_CURRENT_BINARY_DIR}/lightda" CACHE STRING
  "LightDA installation directory")

set(lightda_DIR
  "${lightda_INSTALL_DIR}/lib/cmake/lightda" CACHE STRING
  "LightDA config directory")

ExternalProject_Add(lightda
  GIT_REPOSITORY ${lightda_GIT_URL}
  GIT_TAG main
  CMAKE_CACHE_ARGS
     -Dsystem_mpi_DIR:PATH=${system_mpi_DIR}
     -Dfortran_exceptions_DIR:STRING=${fortran_exceptions_DIR}
    -DCMAKE_INSTALL_PREFIX:PATH=${lightda_INSTALL_DIR}
  DEPENDS system_mpi fortran_exceptions)
