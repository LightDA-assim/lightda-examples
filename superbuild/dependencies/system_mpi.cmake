include(ExternalProject)

set(
  system_mpi_GIT_URL
  "https://github.com/LightDA-assim/system_mpi.git" CACHE STRING
  "URL of system_mpi git repository")

set(system_mpi_INSTALL_DIR
  "${CMAKE_CURRENT_BINARY_DIR}/system_mpi" CACHE PATH
  "system_mpi installation directory")

set(system_mpi_DIR "${system_mpi_INSTALL_DIR}/lib/cmake/system_mpi" CACHE PATH
  "system_mpi directory")

enable_language(Fortran)

find_package(MPI REQUIRED)

ExternalProject_Add(
  system_mpi
  GIT_REPOSITORY ${system_mpi_GIT_URL}
  GIT_TAG main
  CMAKE_CACHE_ARGS
        -DMPI_Fortran_COMPILER:PATH=${MPI_Fortran_COMPILER}
        -DMPI_C_COMPILER:PATH=${MPI_C_COMPILER}
        -DPYTHON_EXECUTABLE:PATH=${PYTHON_EXECUTABLE}
        -DCMAKE_INSTALL_PREFIX:PATH=${system_mpi_INSTALL_DIR})
