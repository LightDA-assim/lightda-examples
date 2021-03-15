cmake_minimum_required(VERSION 3.10)

project(lightda-examples-advect1d)

include(${CMAKE_CURRENT_SOURCE_DIR}/../../../superbuild/common_dependencies.cmake)

find_package(PythonInterp 3.5)

if(PythonInterp_FOUND)

  add_custom_command(OUTPUT venv
    COMMAND ${PYTHON_EXECUTABLE} -m venv venv
    COMMAND venv/bin/python -m pip install --upgrade pip wheel)

  add_custom_target(venv_dir ALL DEPENDS venv)

  set(VENV_PYTHON ${CMAKE_CURRENT_BINARY_DIR}/venv/bin/python)

else()
  unset(VENV_PYTHON)
endif()

ExternalProject_Add(lightda-examples-advect1d
  SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/..
  CMAKE_CACHE_ARGS
    -Dsystem_mpi_DIR:STRING=${CMAKE_CURRENT_BINARY_DIR}/system_mpi/lib/cmake/system_mpi
    -Dfortran_exceptions_DIR:STRING=${CMAKE_CURRENT_BINARY_DIR}/fortran_exceptions/lib/cmake/fortran_exceptions
    -Dhdf5_exceptions_DIR:STRING=${CMAKE_CURRENT_BINARY_DIR}/hdf5_exceptions/lib/cmake/hdf5_exceptions
    -Dlightda_DIR:STRING=${CMAKE_CURRENT_BINARY_DIR}/lightda/lib/cmake/lightda
    -Dlightda-lenkf-rsm_DIR:STRING=${CMAKE_CURRENT_BINARY_DIR}/lightda-lenkf-rsm/lib/cmake/lightda-lenkf-rsm
    -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_CURRENT_BINARY_DIR}/lightda-examples-advect1d
    -DPYTHON_EXECUTABLE:STRING=${VENV_PYTHON}
  DEPENDS lightda lightda-lenkf-rsm venv_dir)
