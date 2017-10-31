
# dependencies
include("${CMAKE_CURRENT_LIST_DIR}/sf_include.cmake")
sf_include_sf_dependency_once(sf_log)

macro(sf_add_default_subdirectories)
    if (EXISTS "${PROJECT_NAME}/CMakeLists.txt")
        add_subdirectory(${PROJECT_NAME})
    endif()
    if (EXISTS "samples/CMakeLists.txt")
        add_subdirectory(samples)
    endif()
    if (EXISTS "tests/CMakeLists.txt")
        add_subdirectory(tests)
    endif()
endmacro()

# add filter group for msvc. creates filters using file relative path of
# the source file from the root_dir.
# source_list: list of source files that will get filters added for them
# root_dir: the root folder where the filter will start from
#
# example usage:
#      sf_add_filter_group("${source_list}" "${CMAKE_CURRENT_SOURCE_DIR}")
macro(sf_add_filter_group source_list root_dir)
    foreach(source ${source_list})
        get_filename_component(parent_dir ${source} DIRECTORY)
        file(RELATIVE_PATH group "${root_dir}" "${parent_dir}")
        string(REPLACE "/" "\\" group "${group}")
        source_group("${group}" FILES "${source}")
    endforeach()
endmacro()

macro(sf_add_filter_group_inplace source_list)
    sf_add_filter_group("${source_list}" "${CMAKE_CURRENT_BINARY_DIR}")
endmacro()
