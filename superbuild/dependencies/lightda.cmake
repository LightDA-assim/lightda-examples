include(ExternalProject)

set(
  lightda_GIT_URL
  "git@gitlab.hpc.mil:john.haiducek.ctr/lightda.git" CACHE STRING
  "URL of LightDA git repository")

set(lightda_INSTALL_DIR
  "${CMAKE_CURRENT_BINARY_DIR}/lightda" CACHE PATH
  "LightDA installation directory")

set(lightda_DIR
  "${lightda_INSTALL_DIR}/lib/cmake/lightda" CACHE PATH
  "LightDA config directory")

ExternalProject_Add(lightda
  GIT_REPOSITORY ${lightda_GIT_URL}
  GIT_TAG main
  CMAKE_CACHE_ARGS
     -DMPI_Fortran_COMPILER:PATH=${MPI_Fortran_COMPILER}
     -DMPI_C_COMPILER:PATH=${MPI_C_COMPILER}
     -Dsystem_mpi_DIR:PATH=${system_mpi_DIR}
     -Dfortran_exceptions_DIR:PATH=${fortran_exceptions_DIR}
    -DCMAKE_INSTALL_PREFIX:PATH=${lightda_INSTALL_DIR}
  DEPENDS system_mpi fortran_exceptions)
