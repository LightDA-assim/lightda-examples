add_subdirectory(src)

find_package(PythonInterp 3.5)

if(PythonInterp_FOUND)

  configure_file(setup.py.in setup.py)

  set(PYTHON_SOURCES __init__.py animate_mpi.py advect1d.py libsuffix.py enkf.py)

  list(TRANSFORM PYTHON_SOURCES PREPEND "advect1d/")

  foreach(file ${PYTHON_SOURCES})
    configure_file(${file} ${file} COPYONLY)
  endforeach()

  set(PYTHON_BUILD_TIMESTAMP ${CMAKE_CURRENT_BINARY_DIR}/python-build/timestamp)

  add_custom_command(OUTPUT ${PYTHON_BUILD_TIMESTAMP}
    COMMAND ${PYTHON_EXECUTABLE} setup.py build --build-base ${CMAKE_CURRENT_BINARY_DIR}/python-build
    COMMAND ${CMAKE_COMMAND} -E touch ${PYTHON_BUILD_TIMESTAMP}
    DEPENDS setup.py advect1d_assimilate ${PYTHON_SOURCES})

  add_custom_target(advect1d_python ALL DEPENDS ${PYTHON_BUILD_TIMESTAMP})

  install(CODE "execute_process(COMMAND ${PYTHON_EXECUTABLE} ${CMAKE_CURRENT_BINARY_DIR}/setup.py install --root ${CMAKE_INSTALL_PREFIX})")

endif()
