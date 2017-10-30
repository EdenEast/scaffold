
# dependencies
include("${CMAKE_CURRENT_LIST_DIR}/sf_include.cmake")
sf_include_sf_dependency_once(sf_log)
sf_include_sf_dependency_once(sf_utils)

# return an unique name for a file target
# replaces slashes with `.`, assumes `.cpp` if the extention is not specified
function(sf_target_name_for out file)
    if (NOT ARGV2)
        set(_extention ".cpp")
    else()
        set(_extention "${ARGV2}")
    endif()

    file(RELATIVE_PATH _relative "${PROJECT_NAME_UPPER}_SOURCE_DIR" ${file})
    string(REPLACE "${_extention}" "" _name "${_relative}")
    string(REGEX REPLACE "/" "." _name ${_name})
    set(${out} "${_name}" PARENT_SCOPE)
endfunction()

# create a `check` target. this is intended for tests and examples
macro(sf_check_target)
    sf_message("created `check` target")
    add_custom_target(check
        COMMAND ${CMAKE_CTEST_COMMAND} --output-on-failure
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Build and then run all the tests.")
endmacro()

macro(sf_add_test name)
    add_test(${name} ${ARGN})
endmacro()

macro(sf_add_unit_test name)
    sf_add_test(${ARGV})
    add_dependencies(tests ${name})
endmacro()

