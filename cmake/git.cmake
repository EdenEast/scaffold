
# Include guard
if(SCAF_GIT_DONE)
  return()
endif()
set(SCAF_GIT_DONE ON)

#
# Configure package management
#
find_package(Git)
if(NOT GIT_FOUND)
  message(FATAL_ERROR "Package management requires Git.")
endif()

include (CMakeParseArguments)

#
# clone_external_git_repo
# Clones a repo into a directory at configure time.  For more automated
# project configuration, consider add_external_git_repo
#
function(sf_clone_external_git_repo)
  set(flags OPTIONAL)
  set(oneValueArgs URL TARGET_DIR TAG COMMIT ALWAYS_UPDATE)
  cmake_parse_arguments(THIS "${flags}" "${oneValueArgs}" "" ${ARGN} )

  if(NOT EXISTS "${THIS_TARGET_DIR}/.git")
    message(STATUS "Cloning repo ${THIS_URL}")

    execute_process(
      COMMAND "${GIT_EXECUTABLE}" clone ${THIS_URL} --branch ${THIS_TAG} ${THIS_TARGET_DIR}
      RESULT_VARIABLE error_code
    )

    if(error_code)
      if(NOT THIS_OPTIONAL)
        message(FATAL_ERROR "Failed to clone ${THIS_URL}")
      endif()
      return()
    endif()

    if(NOT ${THIS_COMMIT} STREQUAL "")
      message(STATUS "Setting repo to commit ${THIS_COMMIT}")

      execute_process(
        COMMAND "${GIT_EXECUTABLE}" --work-tree=${THIS_TARGET_DIR} --git-dir=${THIS_TARGET_DIR}/.git reset --hard ${THIS_COMMIT}
        RESULT_VARIABLE error_code
      )

      if(error_code)
        if(NOT THIS_OPTIONAL)
          message(FATAL_ERROR "Failed to set repo to commit hash: ${THIS_COMMIT}")
        endif()
        return()
      endif()
    endif()
  elseif(${THIS_ALWAYS_UPDATE})
    message(STATUS "Updating repo ${THIS_URL}")

    execute_process(
      COMMAND "${GIT_EXECUTABLE}" pull
      WORKING_DIRECTORY ${THIS_TARGET_DIR}
    )

    if(error_code)
      if(NOT THIS_OPTIONAL)
        message(STATUS "Failed to update ${THIS_URL}")
      endif()
      return()
    endif()

    execute_process(
      COMMAND "${GIT_EXECUTABLE}" checkout ${THIS_TAG}
      WORKING_DIRECTORY ${THIS_TARGET_DIR}
    )

    if(error_code)
      if(NOT THIS_OPTIONAL)
        message(STATUS "Failed to chechout ${THIS_TAG} on ${THIS_URL}")
      endif()
      return()
    endif()
  endif()
endfunction(sf_clone_external_git_repo)

#
# add_external_git_repo
# Adds a prepository into a prefix and automatically configures it for use
# using defalt locations. For more control, use clone_external_git_repo
#
macro(sf_add_external_git_repo)
  set(options ALWAYS_UPDATE OPTIONAL)
  set(oneValueArgs URL PREFIX TAG COMMIT PACKAGE)
  cmake_parse_arguments(THIS "${options}" "${oneValueArgs}" "" ${ARGN})

  sf_clone_external_git_repo(
    URL ${THIS_URL}
    TAG ${THIS_TAG}
    COMMIT ${THIS_COMMIT}
    TARGET_DIR "${PROJECT_SOURCE_DIR}/${THIS_PREFIX}"
    ALWAYS_UPDATE ${THIS_ALWAYS_UPDATE}
    OPTIONAL ${THIS_OPTIONALS}
  )
  get_filename_component(full_path_source_dir "${PROJECT_SOURCE_DIR}/${THIS_PREFIX}" ABSOLUTE)
  get_filename_component(full_path_bin_dir "${PROJECT_BINARY_DIR}/${THIS_PREFIX}" ABSOLUTE)
  if(EXISTS ${full_path_source_dir} OR EXISTS ${full_path_bin_dir})
    add_subdirectory(${full_path_source_dir} ${full_path_bin_dir})
  endif()

  if(NOT ${THIS_PACKAGE} STREQUAL "")
    find_package(${THIS_PACKAGE} PATHS ${full_path_bin_dir}
      NO_CMAKE_PATH
      NO_CMAKE_ENVIRONMENT_PATH
      NO_SYSTEM_ENVIRONMENT_PATH
      NO_CMAKE_BUILDS_PATH
      NO_CMAKE_PACKAGE_REGISTRY
      NO_CMAKE_SYSTEM_PATH
    )
  endif()
 endmacro(sf_add_external_git_repo)
