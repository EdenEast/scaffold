
if(SCAF_INTERFACE_DONE)
  return()
endif()
set(SCAF_INTERFACE_DONE ON)

include(CMakeParseArguments)

macro(add_interface_library target)
  cmake_parse_arguments(THIS "" "IDE_TARGET" "SOURCES" ${ARGN})

  add_library(${target} INTERFACE)
  set_target_properties(${target} PROPERTIES
    INTERFACE_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}
  )

  if (THIS_SOURCES)
    target_sources(${target} INTERFACE "${THIS_SOURCES}")
    target_source_group(${target})
  endif()

  if (THIS_IDE_TARGET)
    if(THIS_SOURCES)
      add_custom_target(${THIS_IDE_TARGET} SOURCES "${THIS_SOURCES}")
      target_source_group(${THIS_IDE_TARGET})
    else()
      message(FATAL_ERROR "Trying to create an IDE target without giving a list of files")
    endif(THIS_SOURCES)
  endif()
endmacro(add_interface_library)
