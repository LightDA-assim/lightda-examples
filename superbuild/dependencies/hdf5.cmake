include(ExternalProject)

set(
  HDF5_GIT_URL
  "https://github.com/HDFGroup/hdf5.git" CACHE STRING
  "URL of HDF5 git repository")

set(HDF5_INSTALL_DIR
  "${CMAKE_CURRENT_BINARY_DIR}/HDF5" CACHE STRING
  "HDF5 installation directory")

enable_language(Fortran)
find_package(HDF5 COMPONENTS Fortran)

if(NOT ${HDF5_FOUND})
  ExternalProject_Add(
    HDF5
    GIT_REPOSITORY ${HDF5_GIT_URL}
    GIT_TAG hdf5-1_12_0
    UPDATE_COMMAND ""
    UPDATE_DISCONNECTED OFF
    CMAKE_CACHE_ARGS
      -DHDF5_BUILD_FORTRAN:BOOL=ON
      -DCMAKE_INSTALL_PREFIX:PATH=${HDF5_INSTALL_DIR})
  set(HDF5_DIR ${HDF5_INSTALL_DIR}/share/cmake/hdf5)
else()
  add_custom_target(HDF5)
endif()

