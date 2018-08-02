
# Include guard
if(SCAF_ASTYPE_DONE)
  return()
endif()
set(SCAF_ASTYPE_DONE ON)

include(CMakeParseArguments)
include(ExternalProject)

find_program(ASTYLE_EXECUTABLE astyle)
if(NOT ASTYLE_EXECUTABLE)
  list(APPEND ASTYLE_CMAKE_ARGS
    "-DCMAKE_INSTALL_PREFIX=${CMAKE_BINARY_DIR}"
  )

  set(ASTYLE_TARGET astyle)
  ExternalProject_Add(
    ${ASTYLE_TARGET}
    GIT_REPOSITORY      https://github.com/Bareflank/astyle.git
    GIT_TAG             v1.2
    GIT_SHALLOW         1
    CMAKE_ARGS          ${ASTYLE_CMAKE_ARGS}
    PREFIX              ${CMAKE_BINARY_DIR}/external/astyle/prefix
    TMP_DIR             ${CMAKE_BINARY_DIR}/external/astyle/tmp
    STAMP_DIR           ${CMAKE_BINARY_DIR}/external/astyle/stamp
    DOWNLOAD_DIR        ${CMAKE_BINARY_DIR}/external/astyle/download
    SOURCE_DIR          ${CMAKE_BINARY_DIR}/external/astyle/src
    BINARY_DIR          ${CMAKE_BINARY_DIR}/external/astyle/build
  )
  set(ASTYLE_EXECUTABLE "${CMAKE_BINARY_DIR}/bin/astyle")
endif()

macro(sf_astyle_add_target target)
  get_target_property(target_type ${target} TYPE)
  if(${target_type} STREQUAL "INTERFACE_LIBRARY")
    get_target_property(target_source_list ${target} INTERFACE_SOURCES)
  else()
    get_target_property(target_source_list ${target} SOURCES)
  endif()

  if("${target_source_list}" STREQUAL "")
    message(FATAL_ERROR "Cound not find target ${target}'s list of sources")
  endif()

  list(APPEND SF_ASTYLE_SOURCE_LIST ${target_source_list})
endmacro()

function(sf_astype_create_command)
  set(single_args OPTION_FILE)
  cmake_parse_arguments(THIS "${flag_args}" "${single_args}" "${multi_args}" ${ARGN})

  if(THIS_OPTION_FILE)
    set(astyle_option_file "${THIS_OPTION_FILE}")
  else()
    set(astyle_option_file "${CMAKE_SOURCE_DIR}/.astyle")
  endif()

  message("astyle exec: ${ASTYLE_EXECUTABLE}")
  add_custom_target(
    format
    COMMAND ${ASTYLE_EXECUTABLE} --options=${astyle_option_file} ${SF_ASTYLE_SOURCE_LIST}
    COMMENT "running astype"
    # DEPENDS ${ASTYLE_TARGET}
  )
endfunction()
