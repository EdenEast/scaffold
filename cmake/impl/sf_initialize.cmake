
include("${CMAKE_CURRENT_LIST_DIR}/sf_include.cmake")
sf_include_sf_dependency_once(sf_log)

macro(sf_init_project_name_upper)
    set(PROJECT_NAME_UPPER "")
    string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UPPER)
endmacro()

# initalize the `${PROJECT_NAME}_SOURCE_DIR` vairable
macro(sf_init_project_source_dir)
    set("${PROJECT_NAME_UPPER}_SOURCE_DIR" "${CMAKE_CURRENT_SOURCE_DIR}")
endmacro()

macro(sf_init_project_common_module_paths)
    list(APPEND CMAKE_MODULE_PATH
        "${CMAKE_CURRENT_SOURCE_DIR}/cmake"
        "${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules")
endmacro()

macro(sf_init_project project_name)
    project(${project_name} CXX)
    enable_testing()

    sf_init_project_name_upper()
    sf_init_project_source_dir()
    sf_init_project_common_module_paths()

    sf_message("initialized project ${project_name}")
endmacro()

macro(sf_init_output_dirs)
    set(EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR}/outputs/bin/)
    set(LIRBARY_OUTPUT_PATH ${CMAKE_BINARY_DIR}/outputs/lib/)
endmacro()

macro(sf_init_target_output target)
    set_target_properties(${target}
        PROPERTIES
        ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/outputs/${target}/lib"
        LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/outputs/${target}/lib"
        RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/outputs/${target}/bin"
        EXECUTABLE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/outputs/${target}/bin")
endmacro()