include(ExternalProject)

set(
  lightda-lenkf-rsm_GIT_URL
  "git@gitlab.hpc.mil:john.haiducek.ctr/lightda-lenkf-rsm.git" CACHE STRING
  "URL of lightda-lenkf-rsm git repository")

set(lightda-lenkf-rsm_INSTALL_DIR
  "${CMAKE_CURRENT_BINARY_DIR}/lightda-lenkf-rsm" CACHE STRING
  "lightda-lenkf-rsm installation directory")

ExternalProject_Add(lightda-lenkf-rsm
  GIT_REPOSITORY ${lightda-lenkf-rsm_GIT_URL}
  GIT_TAG main
  CMAKE_CACHE_ARGS
    -Dsystem_mpi_DIR:STRING=${CMAKE_CURRENT_BINARY_DIR}/system_mpi/lib/cmake/system_mpi
    -Dfortran_exceptions_DIR:STRING=${CMAKE_CURRENT_BINARY_DIR}/fortran_exceptions/lib/cmake/fortran_exceptions
    -Dlightda_DIR:STRING=${CMAKE_CURRENT_BINARY_DIR}/lightda/lib/cmake/lightda
    -DCMAKE_INSTALL_PREFIX:PATH=${lightda-lenkf-rsm_INSTALL_DIR}
  DEPENDS lightda)
