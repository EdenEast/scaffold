
if(SCAF_TARGETS_DONE)
  return()
endif()
set(SCAF_TARGETS_DONE ON)

include("${CMAKE_CURRENT_LIST_DIR}/compiler.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/filters.cmake")
include(CMakeParseArguments)

macro(create_library target)
  # Parse arguments
  cmake_parse_arguments(THIS "NO_COMMON_FLAGS" "FILTER_DIRECTORY;CXX_VERSION;VISIBILITY" "SOURCE_LIST;INCLUDE_DIR;DEPENDS" ${ARGN})

  if(NOT THIS_SOURCE_LIST)
    message("You are creating a library but have not passed any source files.")
    message("Make sure that you pass the sources files with 'SOURCE_LIST'.")
    message(FATAL_ERROR "Pass 'SOURCE_LIST' files to target: ${target}")
  endif()

  string(TOUPPER ${target} target_upper)
  set(${target_upper}_LIB ${target})

  # Create the target
  add_library(${target} ${THIS_SOURCE_LIST})
  set_target_properties(${target} PROPERTIES LINKER_LANGUAGE CXX)
  target_source_group(${target} DIRECTORY ${THIS_FILTER_DIRECTORY})

  if(THIS_VISIBILITY)
    set(target_visibility ${THIS_VISIBILITY})
  else()
    set(target_visibility PUBLIC)
  endif()

  if(NOT THIS_NO_COMMON_FLAGS)
    target_common_compiler_flags(${target})
  endif()

  if(THIS_CXX_VERSION)
    target_set_cxx(${target} ${THIS_CXX_VERSION})
  endif()

  if(THIS_DEPENDS)
    foreach(depend ${THIS_DEPENDS})
      target_link_libraries(${target} ${target_visibility} ${depend})
    endforeach()
  endif()

  if(THIS_INCLUDE_DIR)
    foreach(include_dir ${THIS_INCLUDE_DIR})
      target_include_directories(${target} ${target_visibility} ${include_dir})
    endforeach()
  endif()
endmacro(create_library)

macro(create_interface_library target)
  # Parse arguments
  cmake_parse_arguments(THIS "NO_IDE_TARGET;NO_COMMON_FLAGS" "FILTER_DIRECTORY;CXX_VERSION" "SOURCE_LIST;INCLUDE_DIR;DEPENDS" ${ARGN})

  # Defining the TARGET_LIB variable that can be used to call the targets
  string(TOUPPER ${target} target_upper)
  set(${target_upper}_LIB lib${target})

  # Create the target
  add_library(${${target_upper}_LIB} INTERFACE)

  if(NOT THIS_NO_COMMON_FLAGS)
    target_common_compiler_flags(${${target_upper}_LIB})
  endif()

  if(THIS_CXX_VERSION)
    target_set_cxx(${target} ${THIS_CXX_VERSION})
  endif()

  if(THIS_DEPENDS)
    foreach(depend ${THIS_DEPENDS})
      target_link_libraries(${target} PUBLIC ${depend})
    endforeach()
  endif()

  if(THIS_INCLUDE_DIR)
    foreach(include_dir ${THIS_INCLUDE_DIR})
      target_include_directories(${target} ${target_visibility} ${include_dir})
    endforeach()
  endif()

  if(NOT_IDE_TARGET)
    if(NOT THIS_SOURCE_LIST)
      message("You are creating an ide target but have not passed any source files.")
      message("Make sure that you pass the sources files with 'SOURCE_LIST'. or 'NOT_IDE_TARGET'")
      message(FATAL_ERROR "Pass 'SOURCE_LIST' files to target: ${target}")
    endif()

    add_custom_target(${target})
    target_sources(${target} PUBLIC ${THIS_SOURCE_LIST})
    target_source_group(${taget} DIRECTORY ${THIS_FILTER_DIRECTORY})
  endif()
endmacro(create_interface_library)

