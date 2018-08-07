
# Include guard
if(SCAF_CPPCHECK_DONE)
  return()
endif()
set(SCAF_CPPCHECK_DONE ON)

include(CMakeParseArguments)

find_program(CPPCHECK_EXECUTABLE cppcheck)
if(NOT CPPCHECK_EXECUTABLE)
  sf_add_external_git_repo(
    URL https://github.com/cruizemissile/cppcheck
    TAG master
    PREFIX "external/cppcheck"
    OPTIONAL
  )

  if(CPPCHECK_TARGET)
    if(NOT WIN32)
      set(CPPCHECK_EXECUTABLE ${CMAKE_BINARY_DIR}/bin/cppcheck)
    else()
      set(CPPCHECK_EXECUTABLE ${CMAKE_BINARY_DIR}/bin/${CMAKE_BUILD_TYPE}/cppcheck.exe)
    endif()
    sf_target_set_folder(${CPPCHECK_TARGET} "tools/analysis/cppcheck")
  else()
    message(FATAL_ERROR "cppcheck failed to be cloned")
  endif()
endif()

macro(sf_cppcheck_add_target target)
  if(CPPCHECK_EXECUTABLE)
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
        message("removing ${f} from source list")
        list(REMOVE_ITEM target_source_list ${f})
      endforeach()
    endif()

    list(APPEND SF_CPPCHECK_SOURCE_LIST ${target_source_list})
  endif()
endmacro()

function(sf_cppcheck_create_command)
  cmake_parse_arguments(THIS "${flag_args}" "${single_args}" "${multi_args}" ${ARGN})

  list(APPEND CPPCHECK_ARGS
    --enable=warning,style,performance,portability,unusedFunction
    --std=c++14
    --error-exitcode=1
    --language=c++
    -DMAIN=main
    ${SF_CPPCHECK_SOURCE_LIST}
  )

  if(CPPCHECK_EXECUTABLE)
    add_custom_target(
      check
      COMMAND ${CPPCHECK_EXECUTABLE} ${CPPCHECK_ARGS}
      COMMENT "running cppcheck"
      DEPENDS ${CPPCHECK_TARGET}
    )
    sf_target_set_folder(check "tools/analysis/cppcheck")
  endif()
endfunction()
