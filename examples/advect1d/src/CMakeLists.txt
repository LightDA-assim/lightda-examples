set(ADVECT1D_ASSIMILATE_INTERFACES_SOURCES advect1d_observations.F90 advect1d_assimilate_interfaces.F90 advect1d_forward_operator.F90 advect1d_localizer.F90)
set_source_files_properties(advect1d_assimilate_interfaces.F90
  PROPERTIES COMPILE_FLAGS -cpp)
add_library(advect1d_assimilate_interfaces ${ADVECT1D_ASSIMILATE_INTERFACES_SOURCES})
target_link_libraries(advect1d_assimilate_interfaces PRIVATE lightda)
target_link_libraries(advect1d_assimilate_interfaces PRIVATE hdf5_exceptions)
target_include_directories(advect1d_assimilate_interfaces PUBLIC ${CMAKE_CURRENT_BINARY_DIR})

set(ADVECT1D_SOURCES advect1d.f90)
add_library(advect1d SHARED ${ADVECT1D_SOURCES})
set_target_properties(
  advect1d
  PROPERTIES
  LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/../advect1d)

set(ADVECT1D_ASSIMILATE_SOURCES advect1d_assimilate.f90)
add_executable(advect1d_assimilate ${ADVECT1D_ASSIMILATE_SOURCES})
target_link_libraries(advect1d_assimilate PRIVATE
  lightda lightda-lenkf-rsm system_mpi advect1d_assimilate_interfaces
  hdf5_exceptions)
set_target_properties(
  advect1d_assimilate
  PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/../advect1d)

set(ALL_SOURCES ${ADVECT1D_ASSIMILATE_INTERFACES_SOURCES};${ADVECT1D_SOURCES};
  ${ADVECT1D_ASSIMILATE_SOURCES})

# Prepend path to sources and propagate to parent scope
list_transform_prepend(ALL_SOURCES "src/")
set(ALL_SOURCES ${ALL_SOURCES} PARENT_SCOPE)
