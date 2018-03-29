
# Include guard
if(SCAF_DIRECTORY_DONE)
  return()
endif()
set(SCAF_DIRECTORY_DONE ON)

function(list_directories directory result)
  file(GLOB children RELATIVE ${directory} ${directory}/*)
  set(directory_list "")

  foreach(child ${children})
    if(IS_DIRECTORY ${directory}/${child})
      list(APPEND directory_list ${child})
    endif()
  endforeach(child ${children})

  set(${result} "${directory_list}" PARENT_SCOPE)
endfunction(list_directories)
