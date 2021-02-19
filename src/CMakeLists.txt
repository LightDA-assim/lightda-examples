set(ADVECT1D_ASSIMILATE_INTERFACES_SOURCES advect1d_observations.F90 advect1d_assimilate_interfaces.F90 advect1d_forward_operator.F90 advect1d_localizer.F90)
add_library(advect1d_assimilate_interfaces ${ADVECT1D_ASSIMILATE_INTERFACES_SOURCES})
target_link_libraries(advect1d_assimilate_interfaces PRIVATE lightda)
target_link_libraries(advect1d_assimilate_interfaces PRIVATE hdf5_exceptions)
target_include_directories(advect1d_assimilate_interfaces PUBLIC ${CMAKE_CURRENT_BINARY_DIR})

set(ADVECT1D_SOURCES advect1d.f90)
add_library(advect1d SHARED ${ADVECT1D_SOURCES})

set(ALL_SOURCES ${ADVECT1D_ASSIMILATE_INTERFACES_SOURCES};${ADVECT1D_SOURCES})

# Prepend path to sources and propagate to parent scope
list(TRANSFORM ALL_SOURCES PREPEND "src/")
set(ALL_SOURCES ${ALL_SOURCES} PARENT_SCOPE)
