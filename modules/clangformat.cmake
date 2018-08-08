
# Include guard
if(SCAF_CLANGFORMAT_DONE)
  return()
endif()
set(SCAF_CLANGFORMAT_DONE ON)

find_program(CLANGFORMAT_EXECUTABLE clang-format)
if(NOT CLANGFORMAT_EXECUTABLE)
  message(STATUS "------------------------------------------------------------------")
  message(STATUS "| clang-format is enabled but could not be found.                |")
  message(STATUS "| Make sure that clang-format is installed on your system and is |")
  message(STATUS "| accessable from your PATH variable. Rerun once installed.      |")
  message(STATUS "------------------------------------------------------------------")
endif()

macro(sf_clangformat_add_target target)
  if(CLANGFORMAT_EXECUTABLE)
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

    list(APPEND SF_CLANGFORMAT_SOURCE_LIST ${target_source_list})
  endif()
endmacro()

function(sf_clangformat_create_command)
  list(APPEND CLANGFORMAT_ARGS
    -style=file
    -sort-includes
    -i
    ${SF_CLANGFORMAT_SOURCE_LIST}
  )

  if(CLANGFORMAT_EXECUTABLE)
    add_custom_target(
      format
      COMMAND ${CLANGFORMAT_EXECUTABLE} ${CLANGFORMAT_ARGS}
      COMMENT "running clang-format"
    )
    sf_target_set_folder(format "tools/formatter/clang-format")
  endif()
endfunction()
