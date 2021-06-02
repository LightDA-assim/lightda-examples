include(ExternalProject)

set(
  lightda-lenkf-rsm_GIT_URL
  "https://github.com/LightDA-assim/lightda-lenkf-rsm.git" CACHE STRING
  "URL of lightda-lenkf-rsm git repository")

set(lightda-lenkf-rsm_INSTALL_DIR
  "${CMAKE_CURRENT_BINARY_DIR}/lightda-lenkf-rsm" CACHE PATH
  "lightda-lenkf-rsm installation directory")

set(lightda-lenkf-rsm_DIR
  "${lightda-lenkf-rsm_INSTALL_DIR}/lib/cmake/lightda-lenkf-rsm" CACHE PATH
  "lightda-lenkf-rsm config directory")

ExternalProject_Add(lightda-lenkf-rsm
  GIT_REPOSITORY ${lightda-lenkf-rsm_GIT_URL}
  GIT_TAG main
  CMAKE_CACHE_ARGS
    -Dsystem_mpi_DIR:PATH=${system_mpi_DIR}
    -Dfortran_exceptions_DIR:PATH=${fortran_exceptions_DIR}
    -Dlightda_DIR:PATH=${lightda_DIR}
    -DPYTHON_EXECUTABLE:PATH=${PYTHON_EXECUTABLE}
    -DCMAKE_INSTALL_PREFIX:PATH=${lightda-lenkf-rsm_INSTALL_DIR}
  DEPENDS lightda)
