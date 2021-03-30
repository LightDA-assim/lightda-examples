cmake_minimum_required(VERSION 3.0.2)

project(lightda-examples-advect1d)

enable_language(Fortran)

# Prevent older CMake versions from setting include directories with -isystem,
# which prevents gfortran from finding Fortran module files
set(CMAKE_NO_SYSTEM_FROM_IMPORTED ON)

find_package(lightda REQUIRED NO_POLICY_SCOPE)
find_package(lightda-lenkf-rsm REQUIRED)
find_package(hdf5_exceptions REQUIRED)

function(list_transform_prepend var prefix)
    set(temp "")
    foreach(f ${${var}})
        list(APPEND temp "${prefix}${f}")
    endforeach()
    set(${var} "${temp}" PARENT_SCOPE)
endfunction()

add_subdirectory(src)

find_package(PythonInterp 3.4 QUIET)

if(PythonInterp_FOUND)

  configure_file(setup.py.in setup.py.in)

  file(GENERATE OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/setup.py INPUT ${CMAKE_CURRENT_BINARY_DIR}/setup.py.in)

  set(PYTHON_SOURCES __init__.py animate_mpi.py advect1d.py libsuffix.py enkf.py)

  list_transform_prepend(PYTHON_SOURCES "advect1d/")

  foreach(file ${PYTHON_SOURCES})
    configure_file(${file} ${file} COPYONLY)
  endforeach()

  set(PYTHON_BUILD_TIMESTAMP ${CMAKE_CURRENT_BINARY_DIR}/python-build/timestamp)

  add_custom_command(OUTPUT ${PYTHON_BUILD_TIMESTAMP}
    COMMAND ${PYTHON_EXECUTABLE} setup.py build --build-base ${CMAKE_CURRENT_BINARY_DIR}/python-build
    COMMAND ${CMAKE_COMMAND} -E touch ${PYTHON_BUILD_TIMESTAMP}
    DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/setup.py advect1d_assimilate ${PYTHON_SOURCES})

  add_custom_target(advect1d_python ALL DEPENDS ${PYTHON_BUILD_TIMESTAMP})

  install(CODE "execute_process(COMMAND ${PYTHON_EXECUTABLE} -m pip install --root ${CMAKE_INSTALL_PREFIX} ${CMAKE_CURRENT_BINARY_DIR})")

else()
  message("No suitable Python interpreter found (need at least Python 3.5). Not building python wrappers.")
endif()

# Prepend path to sources and propagate to parent scope
list_transform_prepend(ALL_SOURCES "advect1d/")
set(ALL_SOURCES ${ALL_SOURCES} PARENT_SCOPE)
