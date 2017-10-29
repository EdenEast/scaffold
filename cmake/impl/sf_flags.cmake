
include("${CMAKE_CURRENT_LIST_DIR}/sf_include.cmake")
sf_include_sf_dependency_once(sf_log)
sf_include_sf_dependency_once(sf_detection)

macro(sf_include_once module flags)
    if (NOT ${flags})
        include(${module})
        set(${flags} true)
    endif()
endmacro()


macro(sf_init_compiler_flag_check)
    sf_include_once(CheckCxxCompilerFlag SF_COMPILER_FLAGS_CHECK_INCLUDED)
endmacro()

macro(sf_add_compiler_flag_nocheck flag)
    add_compile_options(${flag})
    list(APPEND SF_SET_FLAGS "${flag}")
endmacro()

macro(sf_add_compiler_flag flag)
    # creating a test name that can store if the option has been added
    string(SUBSTRING ${flag} 1 -1 flag_0)
    string(TOUPPER ${flag_0} flag_1)
    string(REPLACE "-" "_" flag_2 ${flag_1})
    string(REPLACE "+" "X" flag_3 ${flag_2})
    set(PROJECT_TEST_NAME "${PROJECT_NAME_UPPER}_HAS_${flag_3}")

    sf_init_compiler_flag_check()
    check_cxx_compiler_flag(${flag} ${PROJECT_TEST_NAME})

    if (${PROJECT_TEST_NAME})
        sf_add_compiler_flag_nocheck(${flag})
    endif()

endmacro()


macro(sf_add_common_compiler_flags_any_gcc_clang)
    sf_message("adding common flags")

    sf_add_compiler_flag_nocheck("-W")
    sf_add_compiler_flag_nocheck("-Wall")
    sf_add_compiler_flag_nocheck("-Wextra")
    sf_add_compiler_flag_nocheck("-pedantic")

    sf_add_compiler_flag_nocheck("-Wwrite-strings")
    sf_add_compiler_flag_nocheck("-Wundef")
    sf_add_compiler_flag_nocheck("-Wpointer-arith")
    sf_add_compiler_flag_nocheck("-Wcast-align")
    sf_add_compiler_flag_nocheck("-Wnon-virtual-dtor")
    sf_add_compiler_flag_nocheck("-Woverload-virtual")
    sf_add_compiler_flag_nocheck("-Wsequence-point")
    sf_add_compiler_flag("-Wnull-dereference")
    sf_add_compiler_flag("-Wshift-negative-value")

    sf_add_compiler_flag_nocheck("-Wno-unused-local-typedefs")
    sf_add_compiler_flag_nocheck("-Wno-missing-field-initializers")
    sf_add_compiler_flag_nocheck("-Wno-unreachable-code")
endmacro()
