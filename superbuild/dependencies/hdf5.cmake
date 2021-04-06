include(ExternalProject)

set(
  HDF5_GIT_URL
  "https://github.com/HDFGroup/hdf5.git" CACHE STRING
  "URL of HDF5 git repository")

set(HDF5_INSTALL_DIR
  "${CMAKE_CURRENT_BINARY_DIR}/HDF5" CACHE PATH
  "HDF5 installation directory")

enable_language(Fortran)

find_package(HDF5 COMPONENTS Fortran QUIET)
find_package(hdf5 COMPONENTS Fortran QUIET)

if(NOT HDF5_FOUND AND NOT hdf5_FOUND
    AND NOT TARGET hdf5::hdf5_fortran
    AND NOT TARGET hdf5_fortran-static
    AND NOT TARGET hdf5_fortran-shared)
  if(NOT ${CMAKE_VERSION} VERSION_LESS 3.2)
    # Setting UPDATE_COMMAND to "" saves time when re-building, but is
    # not supported on older CMake versions
    set(HDF5_PROJECT_UPDATE_DISCONNECTED_ARG "UPDATE_DISCONNECTED OFF")
  endif()

  ExternalProject_Add(
    HDF5
    GIT_REPOSITORY ${HDF5_GIT_URL}
    GIT_TAG hdf5-1_12_0
    UPDATE_COMMAND ""
    ${HDF5_PROJECT_UPDATE_DISCONNECTED_ARG}
    CMAKE_CACHE_ARGS
      -DHDF5_BUILD_FORTRAN:BOOL=ON
      -DCMAKE_INSTALL_PREFIX:PATH=${HDF5_INSTALL_DIR})
  set(HDF5_DIR ${HDF5_INSTALL_DIR}/share/cmake/hdf5)
else()
  add_custom_target(HDF5)
endif()

