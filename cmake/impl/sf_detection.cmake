
# dependencies
include("${CMAKE_CURRENT_LIST_DIR}/sf_include.cmake")
sf_include_sf_dependency_once(sf_log)

# sets 'flag' to 'true' of the compiler is gcc
macro(sf_check_compiler_gcc flag)
    if (CMAKE_CXX_COMPILER_ID MATCHES "GNU")
        sf_message("Detected compiler gcc. setting `${flag}` to `true`")
        set(${flag} true)
    else()
        set(${flag} false)
    endif()
endmacro()

# sets 'flag' to 'true' of the compiler is clang
macro(sf_check_compiler_clang flag)
    if (CMAKE_CXX_COMPILER_ID MATCHES "Clang")
        sf_message("Detected compiler clang. settings `${flag}` to `true`")
        set(${flag} true)
    else()
        set(${flag} false)
    endif()
endmacro()

# sets 'flag' to 'true' of the compiler is msvc
macro(sf_check_compiler_msvc flag)
    if (CMAKE_CXX_COMPILER_ID MATCHES "MSVC")
        sf_message("Detected compiler msvc. settings `${flag}` to `true`")
        set(${flag} true)
    else()
        set(${flag} false)
    endif()
endmacro()

sf_check_compiler_gcc(SF_COMPILER_IS_GCC)
sf_check_compiler_clang(SF_COMPILER_IS_CLANG)
sf_check_compiler_msvc(SF_COMPILER_IS_MSVC)
