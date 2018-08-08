
# Include guard
if(SCAF_CLANGTIDY_DONE)
  return()
endif()
set(SCAF_CLANGTIDY_DONE ON)

find_program(CLANGTIDY_EXECUTABLE clang-tidy)
if(NOT CLANGTIDY_EXECUTABLE)
  message(STATUS "------------------------------------------------------------------")
  message(STATUS "| clang-tidy is enabled but could not be found.                  |")
  message(STATUS "| Make sure that clang-tidy is installed on your system and is   |")
  message(STATUS "| accessable from your PATH variable. Rerun once installed.      |")
  message(STATUS "------------------------------------------------------------------")
endif()

include(CMakeParseArguments)

macro(sf_clangtidy_add_target target)
  if(CLANGTIDY_EXECUTABLE)
    set(multi_args EXCLUDE_REGEX_LIST)
    cmake_parse_arguments(THIS "${flag_args}" "${single_args}" "${multi_args}" ${ARGN})

    get_target_property(target_type ${target} TYPE)
    if(${target_type} STREQUAL "INTERFACE_LIBRARY")
      get_target_property(target_source_list ${target} INTERFACE_SOURCES)
    else()
      get_target_property(target_source_list ${target} SOURCES)
    endif()

    if("${target_source_list}" STREQUAL "")
      message(FATAL_ERROR "Cound not find target ${target}'s list of sources")
    endif()

    if(THIS_EXCLUDE_REGEX_LIST)
      set(exclude_file_list "")
      foreach(exclude_regex ${THIS_EXCLUDE_REGEX_LIST})
        foreach(f ${target_source_list})
          if(${f} MATCHES ${exclude_regex})
            list(APPEND exclude_file_list ${f})
          endif()
        endforeach()
      endforeach()

      foreach(f ${exclude_file_list})
        list(REMOVE_ITEM target_source_list ${f})
      endforeach()
    endif()

    list(APPEND SF_CLANGTIDY_SOURCE_LIST ${target_source_list})
  endif()
endmacro()

function(sf_clangtidy_create_command)
  set(flag_args FIX)
  cmake_parse_arguments(THIS "${flag_args}" "${single_args}" "${multi_args}" ${ARGN})

  if(EXISTS "${CMAKE_SOURCE_DIR}/.clang-format")
    set(format_style_arg "-format-style=file")
  endif()

  if(THIS_FIX)
    set(fix_arg "-fix-errors")
  endif()

  list(APPEND CLANGTIDY_ARGS
    ${format_style_arg}
    ${fix_arg}
    -header-filter=.*
    -fix-errors
    -checks=clan*,cert*,misc*,perf*,cppc*,read*,mode*,-cert-err58-cpp,-misc-noexcept-move-constructor
    ${SF_CLANGTIDY_SOURCE_LIST}
  )

  if(CLANGTIDY_EXECUTABLE)
    message("creating tidy target")
    add_custom_target(
      tidy
      COMMAND ${CLANGTIDY_EXECUTABLE} ${CLANGTIDY_ARGS}
      COMMENT "running clang-tidy"
    )
    sf_target_set_folder(tidy "tools/analysis/clang-tidy")
  endif()
endfunction()
