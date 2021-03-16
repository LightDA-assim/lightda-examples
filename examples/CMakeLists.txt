add_subdirectory(advect1d)

# Prepend path to ALL_SOURCES and propagate to parent scope
list_transform_prepend(ALL_SOURCES "examples/")
set(ALL_SOURCES ${ALL_SOURCES} PARENT_SCOPE)
