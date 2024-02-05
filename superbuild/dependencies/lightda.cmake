include(ExternalProject)

set(
  lightda_GIT_URL
  "https://github.com/LightDA-assim/lightda-core.git" CACHE STRING
  "URL of LightDA git repository")

set(lightda_INSTALL_DIR
  "${CMAKE_CURRENT_BINARY_DIR}/lightda-core" CACHE PATH
  "LightDA installation directory")

set(lightda_DIR
  "${lightda_INSTALL_DIR}/lib/cmake/lightda" CACHE PATH
  "LightDA config directory")

  set(
    fhash_GIT_URL
    "https://github.com/LKedward/fhash.git" CACHE STRING
    "URL of fhash git repository")
  
  set(fhash_INSTALL_DIR
    "${CMAKE_CURRENT_BINARY_DIR}/fhash" CACHE PATH
    "fhash installation directory")
  
  set(fhash_DIR
    "${fhash_INSTALL_DIR}/lib/cmake/fhash" CACHE PATH
    "fhash config directory")

    ExternalProject_Add(fhash
      GIT_REPOSITORY ${fhash_GIT_URL}
      GIT_TAG master
      CMAKE_CACHE_ARGS
        -DCMAKE_INSTALL_PREFIX:PATH=${fhash_INSTALL_DIR})

ExternalProject_Add(lightda
  GIT_REPOSITORY ${lightda_GIT_URL}
  GIT_TAG main
  CMAKE_CACHE_ARGS
     -DMPI_Fortran_COMPILER:PATH=${MPI_Fortran_COMPILER}
     -DMPI_C_COMPILER:PATH=${MPI_C_COMPILER}
     -Dsystem_mpi_DIR:PATH=${system_mpi_DIR}
     -Dfortran_exceptions_DIR:PATH=${fortran_exceptions_DIR}
     -Dfhash_DIR:PATH=${fhash_DIR}
    -DPYTHON_EXECUTABLE:PATH=${PYTHON_EXECUTABLE}
    -DMPIEXEC_EXECUTABLE:PATH=${MPIEXEC_EXECUTABLE}
    -DMPIEXEC_PREFLAGS:STRING=${MPIEXEC_PREFLAGS}
    -DCMAKE_INSTALL_PREFIX:PATH=${lightda_INSTALL_DIR}
  DEPENDS system_mpi fortran_exceptions)
