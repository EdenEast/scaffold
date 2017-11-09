
# dependencies
include("${CMAKE_CURRENT_LIST_DIR}/sf_include.cmake")
sf_include_sf_dependency_once(sf_log)
sf_include_sf_dependency_once(sf_detection)
sf_include_sf_dependency_once(sf_flags)

function(sf_get_cxxstd_compiler_option version option)
    if(SF_COMPILER_IS_MSVC)
        list(APPEND versions "17" "14" "11")
        list(FIND versions "${version}" index)
        if (${index} GREATER -1)
            list(GET versions ${index} value)
            set(command "/std:c++${value}")
        endif()
    else()
        list(APPEND versions "17" "14" "11")
        list(APPEND flags "1z" "14" "11")
        list(FIND versions "${version}" index)
        if(${index} GREATER -1)
            list(GET flags ${index} value)
            set(command "-std=c++${value}")
        endif()
    endif()
    set(${option} "${command}" PARENT_SCOPE)
endfunction()

macro(sf_set_cxxstd version)
    sf_message("settings required c++ standard to ${x}")

    sf_get_cxxstd_compiler_option(${version} option)
    # sf_add_compiler_flag("${option}")
endmacro()

macro(sf_set_target_cxxstd target permission version)
    sf_message("setting ${target} to c++ version ${version}")

    sf_get_cxxstd_compiler_option(${version} option)
    sf_message("${option}")
    target_compile_options(${target} ${permission} ${option})
    set_target_properties(${target} PROPERTIES
        CXX_STANDARD ${version}
        CXX_STANDARD_REQUIRED YES
        CXX_EXTENSIONS OFF
    )
endmacro()

macro(sf_set_header_target_cxxstd target version)
    sf_message("setting ${target} to c++${version}")
    sf_get_cxxstd_compiler_option(${version} flag)
    target_compile_options(${target} INTERFACE ${flag})
endmacro()
