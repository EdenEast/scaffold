
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
    sf_include_once(CheckCXXCompilerFlag SF_COMPILER_FLAGS_CHECK_INCLUDED)
endmacro()

macro(sf_add_compiler_flag_nocheck flag)
    add_compile_options(${flag})
    list(APPEND SF_SET_FLAGS "${flag}")
endmacro()

macro(sf_check_compiler_flag flag result)
    sf_init_compiler_flag_check()
    check_cxx_compiler_flag(${flag} ${result})
endmacro()

macro(sf_add_compiler_flag flag)
    # creating a test name that can store if the option has been added
    string(REGEX REPLACE "[^a-zA-Z0-9_]" "_" var ${flag})

    sf_init_compiler_flag_check()
    set(CMAKE_REQUIRED_QUIET TRUE)
    check_cxx_compiler_flag("${flag}" HAVE_CXX_${var} QUIET)

    if(HAVE_CXX_${var})
        sf_add_compiler_flag_nocheck(${flag})
    endif()
endmacro()

macro(sf_add_common_compiler_flags_any_gcc_clang)
    sf_add_compiler_flag_nocheck("-W")
    sf_add_compiler_flag_nocheck("-Wall")
    sf_add_compiler_flag_nocheck("-Wextra")
    sf_add_compiler_flag_nocheck("-pedantic")

    sf_add_compiler_flag("-Wnull-dereference")
    sf_add_compiler_flag("-Wshift-negative-value")
    sf_add_compiler_flag_nocheck("-Wcast-align")
    sf_add_compiler_flag_nocheck("-Wnon-virtual-dtor")
    sf_add_compiler_flag_nocheck("-Woverload-virtual")
    sf_add_compiler_flag_nocheck("-Wno-multichar")
    sf_add_compiler_flag_nocheck("-Wpointer-arith")
    sf_add_compiler_flag_nocheck("-Wsequence-point")
    sf_add_compiler_flag_nocheck("-Wundef")
    sf_add_compiler_flag_nocheck("-Wwrite-strings")

    sf_add_compiler_flag_nocheck("-Wno-missing-field-initializers")
    sf_add_compiler_flag_nocheck("-Wno-unreachable-code")
    sf_add_compiler_flag_nocheck("-Wno-unused-functions")
    sf_add_compiler_flag_nocheck("-Wno-unused-local-typedefs")
endmacro()

macro(sf_add_common_compiler_flags_any_msvc)

endmacro()

macro(sf_add_common_compiler_flags_any)
    sf_message("added common flags")

    if (SF_COMPILER_IS_MSVC)
        sf_add_common_compiler_flags_any_msvc()
    else()
        sf_add_common_compiler_flags_any_gcc_clang()
    endif()
endmacro()

macro(sf_add_common_compiler_flags_gcc)
    sf_add_compiler_flag("-Wmisleading-indentation")
    sf_add_compiler_flag("-Wtautological-compare")
    sf_add_compiler_flag_nocheck("-Wlogical-op")
    sf_add_compiler_flag("-Wshift-overflow=2")
    sf_add_compiler_flag("-Wduplicated-cond")

    sf_add_compiler_flag_nocheck("-Wsuggest-final-types")
    sf_add_compiler_flag_nocheck("-Wsuggest-final-methods")
    sf_add_compiler_flag_nocheck("-Wsuggest-override")
endmacro()

macro(sf_add_common_compiler_flags_clang)
    sf_add_compiler_flag_nocheck("-Weverything")

    sf_add_compiler_flag_nocheck("-Wno-c++98-compat")
    sf_add_compiler_flag_nocheck("-Wno-c++98-compat-pedantic")
    sf_add_compiler_flag_nocheck("-Wno-class-varargs")
    sf_add_compiler_flag_nocheck("-Wno-conversion")
    sf_add_compiler_flag_nocheck("-Wno-covered-switch-default")
    sf_add_compiler_flag_nocheck("-Wno-date-time")
    sf_add_compiler_flag_nocheck("-Wno-double-promotion")
    sf_add_compiler_flag_nocheck("-Wno-exit-time-destructors")
    sf_add_compiler_flag_nocheck("-Wno-float-equal")
    sf_add_compiler_flag_nocheck("-Wno-global-constructors")
    sf_add_compiler_flag_nocheck("-Wno-gnu-statement-expression")
    sf_add_compiler_flag_nocheck("-Wno-header-hygiene")
    sf_add_compiler_flag_nocheck("-Wno-injected-class-name")
    sf_add_compiler_flag_nocheck("-Wno-missing-prototypes")
    sf_add_compiler_flag_nocheck("-Wno-missing-variable-declarations")
    sf_add_compiler_flag_nocheck("-Wno-newline-eof")
    sf_add_compiler_flag_nocheck("-Wno-old-style-cast")
    sf_add_compiler_flag_nocheck("-Wno-padded")
    sf_add_compiler_flag_nocheck("-Wno-range-loop-analysis")
    sf_add_compiler_flag_nocheck("-Wno-reserved-id-macro")
    sf_add_compiler_flag_nocheck("-Wno-switch-enum")
    sf_add_compiler_flag_nocheck("-Wno-unneeded-member-function")
    sf_add_compiler_flag_nocheck("-Wno-unused-lambda-capture")
    sf_add_compiler_flag_nocheck("-Wno-unused-macros")
    sf_add_compiler_flag_nocheck("-Wno-unused-member-function")
    sf_add_compiler_flag_nocheck("-Wno-weak-vtables")
endmacro()

macro(sf_add_common_compiler_flags_msvc)

endmacro()


macro(sf_add_common_compiler_flags_suggest_attribute)
    if (NOT "${SF_COMPILER_IS_MSVC}")
        sf_message("added common suggest-attribute flags")

        sf_add_compiler_flag("-Wsuggest-attribute=pure")
        sf_add_compiler_flag("-Wsuggest-attribute=const")
        sf_add_compiler_flag("-Wsuggest-attribute=noreturn")
        sf_add_compiler_flag("-Wsuggest-attribute=format")
    endif()
endmacro()

macro(sf_add_common_compiler_flags_release)
    sf_message("added common release flags")

    if (NOT "${SF_COMPILER_IS_MSVC}")
        sf_add_compiler_flag_nocheck("-Ofast")
        sf_add_compiler_flag_nocheck("-ffast-math")
    else()
    endif()

    add_definitions(-DNDEBUG)
endmacro()

macro(sf_add_common_compiler_flags_debug)
    sf_message("added common debug flags")

    if (NOT "${SF_COMPILER_IS_MSVC}")
        sf_add_compiler_flag_nocheck("-Og")
        sf_add_compiler_flag_nocheck("-g")
    else()
    endif()
endmacro()

macro(sf_add_common_compiler_flags)
    sf_add_common_compiler_flags_any()

    # adding common compiler option depending on compiler
    if (SF_COMPILER_IS_MSVC)
        sf_add_common_compiler_flags_msvc()
    elseif(SF_COMPILER_IS_CLANG)
        sf_add_common_compiler_flags_clang()
    elseif(SF_COMPILER_IS_GCC)
        sf_add_common_compiler_flags_gcc()
    endif()

    # adding common compiler options based on CMAKE_BUILD_TYPE
    string(TOLOWER "${CMAKE_BUILD_TYPE}" BUILD_TYPE)
    if ("${BUILD_TYPE}" STREQUAL "release")
        sf_add_common_compiler_flags_release()
    elseif ("${BUILD_TYPE}" STREQUAL "debug")
        sf_add_common_compiler_flags_debug()
    endif()

    sf_message("final flags: ${SF_SET_FLAGS}")
endmacro()
