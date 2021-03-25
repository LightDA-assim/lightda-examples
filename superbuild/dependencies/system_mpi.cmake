include(ExternalProject)

set(
  system_mpi_GIT_URL
  "git@gitlab.hpc.mil:john.haiducek.ctr/system_mpi.git" CACHE STRING
  "URL of system_mpi git repository")

set(system_mpi_INSTALL_DIR
  "${CMAKE_CURRENT_BINARY_DIR}/system_mpi" CACHE STRING
  "system_mpi installation directory")

ExternalProject_Add(
  system_mpi
  GIT_REPOSITORY ${system_mpi_GIT_URL}
  GIT_TAG main
  CMAKE_CACHE_ARGS
        -DCMAKE_INSTALL_PREFIX:PATH=${system_mpi_INSTALL_DIR})
