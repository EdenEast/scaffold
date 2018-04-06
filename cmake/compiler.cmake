
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

include(CMakeParseArguments)
include(CheckCXXCompilerFlag)

function(get_cxx_compiler_option version flag)
  if (CMAKE_COMPILER_IS_MSVC)
    list(APPEND versions "17" "14" "11")
    list(FIND versions ${version} index)
    if (${index} GREATER -1)
      list(GET versions ${index} value)
      set(cmd "/std:c++${value}")
    endif()
  else()
    list(APPEND versions "17" "14" "11")
    list(FIND versions ${version} index)
    if (${index} GREATER -1)
      list(GET versions ${index} value)
      set(cmd "-std=c++${value}")
    endif()
  endif()
  set(${flag} ${cmd} PARENT_SCOPE)
endfunction(get_cxx_compiler_option)

function(gcc_compile_flags target visiblity)
  cmake_parse_arguments(THIS "" "" "FLAGS" ${ARGN})
  if(CMAKE_COMPILER_IS_GCC)
    foreach(flag "${THIS_FLAGS}")
      target_compile_options(${target} ${visiblity} ${flag})
    endforeach()
  endif()
endfunction()

function(clang_compile_flags target visiblity)
  cmake_parse_arguments(THIS "" "" "FLAGS" ${ARGN})
  if(CMAKE_COMPILER_IS_CLANG)
    foreach(flag "${THIS_FLAGS}")
      target_compile_options(${target} ${visiblity} ${flag})
    endforeach()
  endif()
endfunction()

function(gcc_clang_compile_flags target visiblity)
  cmake_parse_arguments(THIS "" "" "FLAGS" ${ARGN})
  if(CMAKE_COMPILER_IS_GCC OR CMAKE_COMPILER_IS_CLANG)
    foreach(flag "${THIS_FLAGS}")
      target_compile_options(${target} ${visiblity} ${flag})
    endforeach()
  endif()
endfunction()

function(msvc_compiler_flags target visiblity)
  cmake_parse_arguments(THIS "" "" "FLAGS" ${ARGN})
  if(CMAKE_COMPILER_IS_MSVC)
    foreach(flag "${THIS_FLAGS}")
      target_compile_options(${target} ${visiblity} ${flag})
    endforeach()
  endif()
endfunction()

function(target_common_compiler_flags target)
  set(single_args VISIBILITY)
  cmake_parse_arguments(THIS "" "${single_args}" "" ${ARGN})

  # Handle visiblity
  if (THIS_VISIBILITY)
    set(visiblity ${THIS_VISIBILITY})
  else()
    get_target_property(target_type ${target} TYPE)
    if(${target_type} STREQUAL "INTERFACE_LIBRARY")
      set(visiblity "INTERFACE")
    else()
      set(visiblity "PUBLIC")
    endif()
  endif()

  # if the compiler is clang or gcc add common compiler flags
  set(cxx_compiler_flags "")
  if (CMAKE_COMPILER_IS_CLANG OR CMAKE_COMPILER_IS_GCC)
    list(APPEND cxx_compiler_flags
      "-std=c++17" "-W" "-Wall" "-Wextra" "-Wno-unused-function"
      "-Wno-multichar" "-Wno-unused-parameter"
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
    if(CMAKE_COMPILER_IS_GCC)
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
      list(APPEND cxx_compiler_flags "-Wno-c++17-extensions")
      if(CMAKE_BUILD_TYPE STREQUAL "Debug")
      elseif(CMAKE_BUILD_TYPE STREQUAL "Release")
      elseif(CMAKE_BUILD_TYPE STREQUAL "MinSizeRel")
        list(APPEND cxx_compiler_flags "-Oz")
      endif()
    endif()
  elseif(CMAKE_COMPILER_IS_MSVC)
    list(APPEND cxx_compiler_flags "/std:c++latest")
  endif()

  foreach(flag ${cxx_compiler_flags})
    target_compile_options(${target} ${visiblity} ${flag})
  endforeach()
endfunction()

function(target_set_cxx target version)
  cmake_parse_arguments(THIS "VISIBILITY" "" "" ${ARGN})

  if (THIS_VISIBILITY)
    set(visiblity ${THIS_VISIBILITY})
  else()
    get_target_property(target_type ${target} TYPE)
    if (${target_type} STREQUAL "INTERFACE_LIBRARY")
      set(visiblity INTERFACE)
    else()
      set(visiblity PUBLIC)
    endif()
  endif()

  list(APPEND version_string_list "11" "14" "17")
  list(APPEND alt_versions "0x" "1y" "1z")
  list(APPEND version_list cxx_std_11 cxx_std_14 cxx_std_17)
  list(FIND version_string_list ${version} index)

  if(${index} EQUAL -1)
    message(FATAL_ERROR "Unknown cxx version ${version}")
  endif()

  if(CMAKE_COMPILER_IS_MSVC)
    set(compiler_flags_template "/std:c++")

    else()
    set(compiler_flags_template "-std=c++")
  endif()

  check_cxx_compiler_flag(${compiler_flags_template}${flag} result)
  if(result)
    set(cmd ${compiler_flags_template}${flags})
  elseif()
    list(GET alt_versions ${index} value)
    check_cxx_compiler_flag(${compiler_flags_template}${value} result)
    if(result)
      set(cmd ${compiler_flags_template}${value})
    endif()
  endif()

  if(cmd)
    target_compile_options(${target} ${visiblity} ${cmd})
  endif()

  set_target_properties(${target} PROPERTIES
    CXX_STANDARD ${version}
    CXX_STANDARD_REQUIRED ON
    CXX_EXTENSIONS OFF
  )

  list(GET version_list ${index} cxx_version)
  target_compile_features(${target} PUBLIC ${cxx_version})
endfunction(target_set_cxx)

