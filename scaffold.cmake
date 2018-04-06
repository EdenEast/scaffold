cmake_minimum_required(VERSION 3.8)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/modules")

include("${CMAKE_CURRENT_LIST_DIR}/cmake/common.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/cmake/compiler.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/cmake/directory.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/cmake/filters.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/cmake/interface.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/cmake/operating_system.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/cmake/samples.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/cmake/targets.cmake")
