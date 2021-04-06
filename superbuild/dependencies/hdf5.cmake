include(ExternalProject)

set(
  HDF5_GIT_URL
  "https://github.com/HDFGroup/hdf5.git" CACHE STRING
  "URL of HDF5 git repository")

set(
  HDF5_GIT_TAG
  "hdf5-1_12_0" CACHE STRING
  "URL of HDF5 git repository")

set(HDF5_INSTALL_DIR
  "${CMAKE_CURRENT_BINARY_DIR}/HDF5" CACHE PATH
  "HDF5 installation directory")

enable_language(Fortran)

find_package(HDF5 COMPONENTS Fortran QUIET)
find_package(hdf5 COMPONENTS Fortran QUIET)

if(HDF5_FOUND OR hdf5_FOUND
    OR TARGET hdf5::hdf5_fortran
    OR TARGET hdf5_fortran-static
    OR TARGET hdf5_fortran-shared)

  # HDF5 is already installed, create a custom target to satisfy components that
  # need it
  add_custom_target(HDF5)

else()

  # HDF5 is not found, try to download and build it

  if(${CMAKE_VERSION} VERSION_LESS 3.12)

    # Build HDF5 with configure/make
    ExternalProject_Add(
      HDF5
      GIT_REPOSITORY ${HDF5_GIT_URL}
      GIT_TAG ${HDF5_GIT_TAG}
      CONFIGURE_COMMAND ${CMAKE_CURRENT_BINARY_DIR}/HDF5-prefix/src/HDF5/configure --enable-fortran --prefix=${HDF5_INSTALL_DIR}
      BUILD_COMMAND ${MAKE})

    set(ENV{HDF5_ROOT} ${HDF5_INSTALL_DIR} PARENT_SCOPE)

  else()

    # Build HDF5 with CMake
    ExternalProject_Add(
      HDF5
      GIT_REPOSITORY ${HDF5_GIT_URL}
      GIT_TAG ${HDF5_GIT_TAG}
      UPDATE_COMMAND ""
      CMAKE_CACHE_ARGS
        -DHDF5_BUILD_FORTRAN:BOOL=ON
        -DCMAKE_INSTALL_PREFIX:PATH=${HDF5_INSTALL_DIR})

    set(HDF5_DIR ${HDF5_INSTALL_DIR}/share/cmake/hdf5)

  endif()

endif()
