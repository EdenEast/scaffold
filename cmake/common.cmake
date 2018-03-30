
# Includ guard
if(SCAF_COMMON_DONE)
  return()
endif()
set(SCAF_COMMON_DONE ON)

# Checkign to see if the install directory is not in the build directory
if(CMAKE_INSTALL_PREFIX STREQUAL PROJECT_BINARY_DIR)
  message(FATAL_ERROR "Cannot install into build directory")
endif()

# Check to make sure that we are not building in source
if (${CMAKE_CURRENT_BINARY_DIR} STREQUAL ${PROJECT_SOURCE_DIR})
  message("")
  message("------------------------------------------------------------------")
  message("| In source build are not supported. It is recommended that you  |")
  message("| use a build/ subdirectory:                                     |")
  message("|    $ cmake . <OPTIONS> -Bbuild                                 |")
  message("|                                                                |")
  message("| Make sure that you clean up the cmake artifacts with:          |")
  message("|    $ rm -rf CMakeFiles CMakeCache.txt                          |")
  message("------------------------------------------------------------------")
  message("")
  message(FATAL_ERROR "Stopping build.")
endif()

# If no build type is selected for non multi builds then default the build to debug
if(NOT CMAKE_BUID_TYPE)
  if(SCAF_DEFAULT_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE ${SCAF_DEFAULT_BUILD_TYPE} CACHE STRING "Build type" FORCE)
  else()
    set(CMAKE_BUILD_tYPE Debug CACHE STRING "Build type" FORCE)
  endif()
endif()

# Setting default output directories
if(SCAF_DEFAULT_RUNTIME_OUT_DIR)
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${SCAF_DEFAULT_RUNTIME_OUT_DIR})
else()
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
endif()

if(SCAF_DEFAULT_ARCHIVE_OUT_DIR)
  set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${SCAF_DEFAULT_ARCHIVE_OUT_DIR})
else()
  set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
endif()

if(SCAF_DEFAULT_LIBRARY_OUT_DIR)
  set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${SCAF_DEFAULT_ARCHIVE_OUT_DIR})
else()
  set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
endif()

set(CMAKE_INSTALL_MESSAGE LAZY) # no up-to-date messages on installation
set(CMAKE_CXX_STANDARD_REQUIRED ON) # value of CXX_STANDARD on targets is required
set_property(GLOBAL PROPERTY USE_FOLDERS ON) # organize targets into folders

if(MSVC)
  set(CMAKE_MODULE_INSTALL_PATH ${PROJECT_NAME}/cmake)
else()
  set(CMAKE_MODULE_INSTALL_PATH share/${PROJECT_NAME}/cmake)
endif()

if($ENV{TRAVIS})
  set(TRAVIS ON)
endif()

string(TOUPPER ${PROJECT_NAME} UPPER_PROJECT_NAME)
string(TOLOWER ${PROJECT_NAME} LOWER_PROJECT_NAME)

function(check_master_project is_project)
  if(${CMAKE_PROJECT_NAME} STREQUAL ${PROJECT_NAME})
    set(${is_project} ON PARENT_SCOPE)
  else()
    set(${is_project} OFF PARENT_SCOPE)
  endif()
endfunction(check_master_project)
