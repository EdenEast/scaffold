
include("${CMAKE_CURRENT_LIST_DIR}/sf_include.cmake")
sf_include_sf_dependency_once(sf_log)

macro(sf_init_project_name_upper)
    set(PROJECT_NAME_UPPER "")
    string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UPPER)
endmacro()

macro(sf_init_target_name_upper target)
    string(TOUPPER ${target} TARGET_UPPER)
    set(${TARGET_UPPER}_UPPER "")
    string(TOUPPER ${TARGET_UPPER}_UPPER "${target}")
endmacro()

# initalize the `${PROJECT_NAME}_SOURCE_DIR` vairable
macro(sf_init_project_root_dir)
    set("${PROJECT_NAME_UPPER}_ROOT_DIR" "${CMAKE_CURRENT_SOURCE_DIR}")
endmacro()

macro(sf_init_target_root_dir target)
    string(TOUPPER ${target} TARGET_UPPER)
    set("${${TARGET_UPPER}_UPPER}_ROOT_DIR" "${CMAKE_CURRENT_SOURCE_DIR}")
endmacro()

macro(sf_init_project_source_dir)
    set("${PROJECT_NAME_UPPER}_SOURCE_DIR" "${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_NAME}")
endmacro()

macro(sf_init_target_source_dir target)
    set("${TARGET_NAME_UPPER}_SOURCE_DIR" "${CMAKE_CURRENT_SOURCE_DIR}/${target}")
endmacro()

macro(sf_init_project_common_module_paths)
    list(APPEND CMAKE_MODULE_PATH
        "${CMAKE_CURRENT_SOURCE_DIR}/cmake"
        "${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules")
endmacro()

macro(sf_resolve_build_type)
    if ("${CMAKE_BUILD_TYPE}" STREQUAL "")
        sf_message("CMAKE_BUILD_TYPE is empty. Defaulting to release build.")
        set(CMAKE_BUILD_TYPE "Release")
    endif()
endmacro()

macro(sf_check_build_folder)
    if (${CMAKE_CURRENT_BINARY_DIR} STREQUAL ${PROJECT_SOURCE_DIR})
        sf_warning_message("when checking: 'CMAKE_CURRENT_BINARY_DIR' is the same as 'PROJECT_SOURCE_DIR' \
you should create a build folder in order to build ${PROJECT_NAME}. \
run this cmake command from the root of the project. `cmake . -Bbuild`")
    endif()
endmacro()

macro(sf_init_project project_name)
    sf_check_build_folder()
    sf_resolve_build_type()

    project(${project_name} CXX)
    enable_testing()

    sf_init_project_name_upper()
    sf_init_project_root_dir()
    sf_init_project_source_dir()
    sf_init_project_common_module_paths()
    sf_init_output_dirs()

    sf_message("initialized project ${project_name}")
endmacro()

macro(sf_init_target target_name)
    sf_init_target_name_upper("${target_name}")
    sf_init_target_root_dir("${target_name}")
    sf_init_target_source_dir("${target_name}")
    set_target_properties(${target_name} PROPERTIES LINKER_LANGUAGE CXX)
endmacro()

macro(sf_init_output_dirs)
    set(EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR}/bin/)
    set(LIRBARY_OUTPUT_PATH ${CMAKE_BINARY_DIR}/lib/)
endmacro()

macro(sf_init_target_output target)
    set_target_properties(${target} PROPERTIES
        ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
        LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
        RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
        EXECUTABLE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")
endmacro()
