
if(SCAF_SAMPLES_DONE)
  return()
endif()
set(SCAF_SAMPLES_DONE ON)

include("${CMAKE_CURRENT_LIST_DIR}/directory.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/filters.cmake")
include(CMakeParseArguments)

macro(setup_samples)
  set(_options)
  set(_single_args DIRECTORY)
  set(_multi_args TARGET_DEPENDENCIES)
  cmake_parse_arguments(THIS "${_options}" "${_single_args}" "${_multi_args}" ${ARGN})

  if(THIS_DIRECTORY)
    set(root_sample_dir ${THIS_DIRECTORY})
  else()
    set(root_sample_dir ${CMAKE_CURRENT_SOURCE_DIR})
  endif()

  list_directories(${root_sample_dir} sample_directory_list)

  foreach(sample_name ${sample_directory_list})
    set(sample_path ${root_sample_dir}/${sample_name})

    # Collecting all of the files
    file(GLOB_RECURSE sample_files
      ${sample_path}/*.h
      ${sample_path}/*.hpp
      ${sample_path}/*.cpp
    )

    add_executable(${sample_name} "${sample_files}")
    target_source_group(${sample_name})
    target_set_folder(${sample_name} "Samples")

    if(THIS_TARGET_DEPENDENCIES)
      foreach(sample_target_dependency ${THIS_TARGET_DEPENDENCIES})
        target_link_libraries(${sample_name} ${sample_target_dependency})
      endforeach(sample_target_dependency ${THIS_TARGET_DEPENDENCIES})
    endif()

  endforeach(sample_name ${sample_directory_list})
endmacro(setup_samples)

