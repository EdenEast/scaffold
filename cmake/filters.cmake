
# Includ guard
if(SCAF_FILTERS_DONE)
  return()
endif()
set(SCAF_FILTERS_DONE ON)


function(target_set_folder target folder)
  set_target_properties(${target} PROPERTIES FOLDER ${folder})
endfunction()

function(target_source_group target)
  # note on getting the source directory on a target is cmake 3.7+
  # https://stackoverflow.com/a/44064705
  get_target_property(target_source_list ${target} SOURCES)
  get_target_property(target_source_directory ${target} SOURCE_DIR)

  set(last_dir "")
  foreach(source ${target_source_list})
    get_filename_component(source_directory ${source} DIRECTORY)
    file(RELATIVE_PATH dir "${target_source_directory}" "${source_directory}")

    if (NOT "${dir}" STREQUAL "${last_dir}")
      if (files)
        source_group("${last_dir}" FILES ${files})
      endif()
      set(files "")
    endif()

    set(files ${files} ${source})
    set(last_dir ${dir})
  endforeach()
  if (files)
    source_group("${last_dir}" FILES ${files})
  endif()
endfunction()
