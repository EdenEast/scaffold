
# dependencies
include("${CMAKE_CURRENT_LIST_DIR}/sf_include.cmake")
sf_include_sf_dependency_once(sf_log)
sf_include_sf_dependency_once(sf_detection)
sf_include_sf_dependency_once(sf_flags)

macro(sf_set_compiler_flags_gcc_clang cxx_version)
    list(APPEND versions "17" "14" "11")
    list(APPEND flags "1z" "14" "11")
    list(FIND versions "${cxx_version}" index)
    if(${index} GREATER -1)
        list(GET flags index value)
        sf_add_compiler_flag("-std=c++${value}")
    endif()
endmacro()

macro(sf_set_compiler_flag_msvc cxx_version)
    list(APPEND versions "17" "14" "11")
    list(FIND versions "${cxx_version}" index)
    if (${index} GREATER -1)
        sf_add_compiler_flag("/std:c++${cxx_version}")
    endif()
endmacro()

macro(sf_set_cxxstd x)
    sf_message("settings required c++ standard to ${x}")

    if (SF_COMPILER_IS_MSVC)
        sf_set_compiler_flag_msvc("${x}")
    else()
        sf_set_compiler_flags_gcc_clang("${x}")
    endif()
endmacro()

macro(sf_set_target_cxx target version)
    sf_message("setting ${target} to c++ version ${version}")

    set_target_properties(${target} PROPERTIES
        CXX_STANDARD ${version}
        CXX_STANDARD_REQUIRED YES
        CXX_EXTENSIONS OFF
    )
endmacro()

