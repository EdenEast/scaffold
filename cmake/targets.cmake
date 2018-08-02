
if(SCAF_TARGETS_DONE)
  return()
endif()
set(SCAF_TARGETS_DONE ON)

include("${CMAKE_CURRENT_LIST_DIR}/compiler.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/directory.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/filters.cmake")
include(CMakeParseArguments)

macro(sf_create_library target)
  # Parse arguments
  set(_options "NO_COMMON_FLAGS")
  set(_single_args "FILTER_DIRECTORY;CXX_VERSION;VISIBLITY")
  set(_multi_args "SOURCE_LIST;INCLUDE_DIR;DEPENDS")
  cmake_parse_arguments(THIS "${_options}" "${_single_args}" "${_multi_args}" ${ARGN})

  if(NOT THIS_SOURCE_LIST)
    message("You are creating a library but have not passed any source files.")
    message("Make sure that you pass the sources files with 'SOURCE_LIST'.")
    message(FATAL_ERROR "Pass 'SOURCE_LIST' files to target: ${target}")
  endif()

  # Defining the TARGET_LIB variable that can be used to call the targets
  string(TOUPPER ${target} target_upper)
  set(${target_upper}_LIB ${target} CACHE FORCE ${target_upper}_LIB)

  # Create the target
  add_library(${target} ${THIS_SOURCE_LIST})
  set_target_properties(${target} PROPERTIES LINKER_LANGUAGE CXX)
  sf_target_source_group(${target} DIRECTORY ${THIS_FILTER_DIRECTORY})

  if(THIS_VISIBILITY)
    set(target_visibility ${THIS_VISIBILITY})
  else()
    set(target_visibility PUBLIC)
  endif()

  if(NOT THIS_NO_COMMON_FLAGS)
    sf_target_common_compiler_flags(${target})
  endif()

  if(THIS_CXX_VERSION)
    sf_target_cxx(${target} ${THIS_CXX_VERSION})
  endif()

  foreach(depend ${THIS_DEPENDS})
    target_link_libraries(${target} ${target_visibility} ${depend})
  endforeach()

  foreach(include_dir ${THIS_INCLUDE_DIR})
    target_include_directories(${target} ${target_visibility} ${include_dir})
  endforeach()
endmacro(sf_create_library)

macro(sf_create_interface_library target)
  # Parse arguments
  set(_options "NO_IDE_TARGET;NO_COMMON_FLAGS")
  set(_single_args "FILTER_DIRECTORY;CXX_VERSION")
  set(_multi_args "SOURCE_LIST;INCLUDE_DIR;DEPENDS")
  cmake_parse_arguments(THIS "${_options}" "${_single_args}" "${_multi_args}" ${ARGN})

  # Defining the TARGET_LIB variable that can be used to call the targets
  string(TOUPPER ${target} target_upper)
  set(${target_upper}_LIB lib${target} CACHE FORCE ${target_upper}_LIB)

  # Create the target
  add_library(${${target_upper}_LIB} INTERFACE)

  if(NOT THIS_NO_COMMON_FLAGS)
    sf_target_common_compiler_flags(${${target_upper}_LIB})
  endif()

  if(THIS_CXX_VERSION)
    sf_target_cxx(${${target_upper}_LIB} ${THIS_CXX_VERSION})
  endif()

  foreach(depend ${THIS_DEPENDS})
    target_link_libraries(${${target_upper}_LIB} PUBLIC ${depend})
  endforeach()

  foreach(include_dir ${THIS_INCLUDE_DIR})
    target_include_directories(${${target_upper}_LIB} ${target_visibility} ${include_dir})
  endforeach()

  target_sources(${${target_upper}_LIB} INTERFACE ${THIS_SOURCE_LIST})

  if(NOT NO_IDE_TARGET)
    if(NOT THIS_SOURCE_LIST)
      message("-------------------------------------------------------------------------------------")
      message("| You are creating an ide target but have not passed any source files.              |")
      message("| Make sure that you pass the sources files with 'SOURCE_LIST'. or 'NOT_IDE_TARGET' |")
      message("-------------------------------------------------------------------------------------")
      message(FATAL_ERROR "Pass 'SOURCE_LIST' files to target: ${target}")
    endif()

    add_custom_target(${target} SOURCES ${THIS_SOURCE_LIST})
    sf_target_source_group(${target} DIRECTORY ${THIS_FILTER_DIRECTORY})
  endif()
endmacro(sf_create_interface_library)

macro(sf_create_executable target_name)
  set(_options "")
  set(_single_args "DIRECTORY;FOLDER;FILTER_DIRECTORY")
  set(_multi_args "SOURCE_LIST;EXTENTIONS;DEPENDS")
  cmake_parse_arguments(THIS "${_options}" "${_single_args}" "${_multi_args}" ${ARGN})

  # Define the source list
  if(THIS_SOURCE_LIST)
    set(source_list "${THIS_SOURCE_LIST}")
  else()
    if(THIS_DIRECTORY)
      set(root_directory ${THIS_DIRECTORY})
    else()
      set(root_directory ${CMAKE_CURRENT_SOURCE_DIR})
    endif()

    set(file_extentions "")
    if(THIS_EXTENTIONS)
      foreach(e ${THIS_EXTENTIONS})
        list(APPEND file_extentions ${root_directory}/${e})
      endforeach(e ${THIS_EXTENTIONS})
    else()
        list(APPEND file_extentions "${root_directory}/*.h" "${root_directory}/*.hpp" "${root_directory}/*.cpp")
    endif()

    set(source_list "")
    foreach(f ${file_extentions})
      set(files "")
      file(GLOB_RECURSE files ${f})
      list(APPEND source_list ${files})
    endforeach(f ${file_extentions})
  endif()

  add_executable(${target_name} ${source_list})

  if(THIS_FOLDER)
    sf_target_set_folder(${target_name} ${THIS_FOLDER})
  endif()

  if(THIS_FILTER_DIRECTORY)
    sf_target_source_group(${target_name} DIRECTORY ${THIS_FILTER_DIRECTORY})
  else()
    sf_target_source_group(${target_name})
  endif()

  foreach(d ${THIS_DEPENDS})
    target_link_libraries(${target_name} ${d})
  endforeach(d ${THIS_DEPENDS})

  if(THIS_DIRECTORY)
    target_include_directories(${target_name} PUBLIC ${THIS_DIRECTORY})
  endif()
endmacro(sf_create_executable)

macro(sf_create_executables_per_files)
  set(_options "")
  set(_single_args "DIRECTORY;FOLDER;FILTER_DIRECTORY")
  set(_multi_args "DEPENDS;EXTENTIONS")
  cmake_parse_arguments(THIS "${_options}" "${_single_args}" "${_multi_args}" ${ARGN})

  if(THIS_DIRECTORY)
    set(root_directory ${THIS_DIRECTORY})
  else()
    set(root_directory ${CMAKE_CURRENT_SOURCE_DIR})
  endif()

  set(file_extentions "")
  if(THIS_EXTENTIONS)
    foreach(e ${THIS_EXTENTIONS})
      list(APPEND file_extentions ${root_directory}/${e})
    endforeach(e ${THIS_EXTENTIONS})
  else()
      list(APPEND file_extentions ${root_directory}/*.cpp)
  endif()

  set(file_list "")
  foreach(f ${file_extentions})
    file(GLOB files ${f})
    list(APPEND file_list ${files})
  endforeach()

  foreach(f ${file_list})
    # Get the name from the path and then remove the extention
    get_filename_component(target_name ${f} NAME)
    string(REGEX REPLACE "\\.[^.]*$" "" target_name ${target_name})

    sf_create_executable(${target_name}
      DIRECTORY ${THIS_DIRECTORY}
      FILTER_DIRECTORY ${THIS_FILTER_DIRECTORY}
      FOLDER ${THIS_FOLDER}

      DEPENDS "${THIS_DEPENDS}"
      EXTENTIONS "${THIS_EXTENTIONS}"
      SOURCE_LIST "${f}"
    )
  endforeach()
endmacro(sf_create_executables_per_files)

macro(sf_create_executables_per_folders)
  # Parse arguments
  set(_options "")
  set(_single_args "DIRECTORY;FOLDER")
  set(_multi_args "DEPENDS;EXTENTIONS")
  cmake_parse_arguments(THIS "${_options}" "${_single_args}" "${_multi_args}" ${ARGN})

  if(THIS_DIRECTORY)
    set(root_directory ${THIS_DIRECTORY})
  else()
    set(root_directory ${CMAKE_CURRENT_SOURCE_DIR})
  endif()

  sf_list_directories(${root_directory} directory_list)
  foreach(exec_name ${directory_list})
    set(exec_path ${root_directory}/${exec_name})

    set(file_extentions "")
    if(THIS_EXTENTIONS)
      foreach(e ${THIS_EXTENTIONS})
        list(APPEND file_extentions ${exec_path}/${e})
      endforeach(e ${THIS_EXTENTIONS})
    else()
        list(APPEND file_extentions "${exec_path}/*.h" "${exec_path}/*.hpp" "${exec_path}/*.cpp")
    endif()

    # Collecting all the files in the folder
    set(file_list "")
    foreach(f ${file_extentions})
      file(GLOB files ${f})
      list(APPEND file_list ${files})
    endforeach()

    sf_create_executable(${exec_name}
      DIRECTORY ${THIS_DIRECTORY}
      FILTER_DIRECTORY ${THIS_FILTER_DIRECTORY}
      FOLDER ${THIS_FOLDER}

      DEPENDS "${THIS_DEPENDS}"
      EXTENTIONS "${THIS_EXTENTIONS}"
      SOURCE_LIST "${file_list}"
    )
  endforeach(exec_name ${directory_list})
endmacro(sf_create_executables_per_folders)
