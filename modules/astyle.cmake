
# Include guard
if(SCAF_ASTYPE_DONE)
  return()
endif()
set(SCAF_ASTYPE_DONE ON)

include(CMakeParseArguments)

find_program(ASTYLE_EXECUTABLE astyle)
if(NOT ASTYLE_EXECUTABLE)
    sf_add_external_git_repo(
    URL https://github.com/cruizemissile/astyle
    TAG master
    PREFIX "external/astyle"
    OPTIONAL
  )

  if(ASTYLE_TARGET)
    if(NOT WIN32)
      set(ASTYLE_EXECUTABLE ${CMAKE_BINARY_DIR}/bin/astyle)
    else()
      set(ASTYLE_EXECUTABLE ${CMAKE_BINARY_DIR}/bin/${CMAKE_BUILD_TYPE}/astyle.exe)
    endif()
    sf_target_set_folder(${ASTYLE_TARGET} "tools/formatter/astyle")
  else()
    message(FATAL_ERROR "astyle failed to be cloned")
  endif()
endif()

macro(sf_astyle_add_target)
  foreach(target ${ARGN})
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
  endforeach()
endmacro()

function(sf_astype_create_command)
  set(single_args OPTION_FILE)
  cmake_parse_arguments(THIS "${flag_args}" "${single_args}" "${multi_args}" ${ARGN})

  if(THIS_OPTION_FILE)
    set(astyle_option_file "${THIS_OPTION_FILE}")
  else()
    set(astyle_option_file "${CMAKE_SOURCE_DIR}/.astyle")
  endif()

  if(ASTYLE_EXECUTABLE)
    add_custom_target(
      format
      COMMAND ${ASTYLE_EXECUTABLE} --options=${astyle_option_file} ${SF_ASTYLE_SOURCE_LIST}
      COMMENT "running astype"
      DEPENDS ${ASTYLE_TARGET}
    )
    sf_target_set_folder(format "tools/formatter/astyle")
  endif()
endfunction()
