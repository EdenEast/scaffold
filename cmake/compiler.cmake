
# Include guard
if(SCAF_COMPILER_DONE)
  return()
endif()
set(SCAF_COMPILER_DONE ON)

# Compiler names
if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang" OR
  CMAKE_CXX_COMPILER_ID STREQUAL "AppleClang")
  set(CMAKE_COMPILER_IS_CLANG ON)
elseif(CMAKE_COMPILER_IS_GNUCXX)
  set(CMAKE_COMPILER_IS_GCC ON)
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
  set(CMAKE_COMPILER_IS_MSVC ON)
endif()

# option(SCAF_COMMON_WARN_DEPRECATED "Enable compiler deprecation warnings" ON)
# option(SCAF_COMMOON_DISABLE_WARN_AS_ERROR "Disable warning as error flag" OFF)

function(target_common_compiler_flags target visiblity)
  # if the compiler is clang or gcc add common compiler flags
  if (CMAKE_COMPILER_IS_CLANG OR CMAKE_COMPILER_IS_GNUCC)
    list(APPEND cxx_compiler_flags
      "-Wno-unused-function" "-Wno-multichar" "-Wno-unused-parameter"
      "-pedantic" "-W" "-Wall" "-Wextra"
    )

    # BUILD_TYPE specific flags
    if(CMAKE_BUILD_TYPE STREQUAL "Debug")
      list(APPEND cxx_compiler_flags "-O0" "-g3")
    elseif(CMAKE_BUILD_TYPE STREQUAL "Release")
      list(APPEND cxx_compiler_flags "-DNDEBUG" "-O3")
    elseif(CMAKE_BUILD_TYPE STREQUAL "MinSizeRel")
      list(APPEND cxx_compiler_flags "-DNDEBUG")
    endif()

    # compiler specific information
    if(CMAKE_COMPILER_IS_GNUCC)
      # https://gcc.gnu.org/onlinedocs/gcc/Option-Summary.html
      if(CMAKE_BUILD_TYPE STREQUAL "Debug")
        list(APPEND cxx_compiler_flags "-fno-inline" "-Og")
      elseif(CMAKE_BUILD_TYPE STREQUAL "Release")
        list(APPEND cxx_compiler_flags "--finline-limit=100")
      elseif(CMAKE_BUILD_TYPE STREQUAL "MinSizeRel")
        list(APPEND cxx_compiler_flags "-Os")
      endif()
    else()
      # https://clang.llvm.org/docs/DiagnosticsReference.html
      if(CMAKE_BUILD_TYPE STREQUAL "Debug")
      elseif(CMAKE_BUILD_TYPE STREQUAL "Release")
      elseif(CMAKE_BUILD_TYPE STREQUAL "MinSizeRel")
        list(APPEND cxx_compiler_flags "-Oz")
      endif()
    endif()
  elseif(${CMAKE_COMPILER_IS_MSVC})
    list(APPEND cxx_compiler_flags "/std:c++latest")
  endif()

  foreach(flag "${cxx_compiler_flags}")
    target_compile_options(${target} ${visiblity} ${flag})
  endforeach()
endfunction()
