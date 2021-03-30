
if(FPRETTIFY_EXECUTABLE)

  set(FPRETTIFY_CMD ${DO_FPRETTIFY})
  list(APPEND FPRETTIFY_CMD "${ALL_SOURCES}")
  string(REPLACE ";" "\;" FPRETTIFY_CMD "${FPRETTIFY_CMD}")
  add_test(NAME test_fprettify
    COMMAND ${CMAKE_COMMAND}
    -DCMD=${FPRETTIFY_CMD}
    -DFAIL_PATTERN=.
    -P ${CMAKE_CURRENT_SOURCE_DIR}/test_and_check_regex.cmake)
endif()

find_package(lightda REQUIRED NO_POLICY_SCOPE)
find_package(lightda-lenkf-rsm REQUIRED)
find_package(hdf5_exceptions REQUIRED)

add_library(model_interface_tests model_interface_tests.f90)
target_link_libraries(model_interface_tests PRIVATE lightda)

add_executable(advect1d_model_interface_tests advect1d_model_interface_tests.F90)
target_link_libraries(advect1d_model_interface_tests PRIVATE model_interface_tests system_mpi advect1d_assimilate_interfaces MPI::MPI_Fortran)
target_link_libraries(advect1d_model_interface_tests PRIVATE lightda_util)
target_link_libraries(advect1d_model_interface_tests PRIVATE hdf5_exceptions)

add_test(test_advect1d_model_interface ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} 4 ./advect1d_model_interface_tests)

add_custom_target(all_tests ALL DEPENDS advect1d_model_interface_tests)

add_custom_command(
     TARGET all_tests
     COMMENT "Run tests"
     POST_BUILD
     WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
     COMMAND ${CMAKE_CTEST_COMMAND} -C $<CONFIGURATION> --output-on-failure
)
