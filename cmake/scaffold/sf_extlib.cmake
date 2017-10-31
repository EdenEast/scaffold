
# Dependencies.
include("${CMAKE_CURRENT_LIST_DIR}/sf_include.cmake")
sf_include_sf_dependency_once(sf_log)

# looks for libray folder `extlibs` `3rdparty` or `third_party` in paths
# starting with `extlib` or `3rdparty`
macro(sf_find_extlib_in extlib dir)
    sf_message("finding ${extlib} in ${dir}")

    # including the directory passed in
    list(APPEND CMAKE_MODULE_PATH
        "${CMAKE_SOURCE_DIR}/${dir}/${extlib}/cmake/modules"
        "${CMAKE_SOURCE_DIR}/${dir}/${extlib}/cmake")

    list(APPEND extlib_list "exlibs" "3rdparty" "third_party")
    foreach(ex_lib ${extlib_list})
        list(APPEND CNAME_MODULE_PATH
            "${CMAKE_SOURCE_DIR}/${ex_lib}/${extlib}/cmake/modules"
            "${CMAKE_SOURCE_DIR}/${ex_lib}/${extlib}/cmake")
    endforeach()

    find_package("${extlib}" REQUIRED)
    string(TOUPPER "${extlib}" "${extlib}_UPPER")
endmacro()

macro(sf_find_extlib_in_and_default_include extlib dir)
    sf_find_extlib_in(${extlib} ${dir})
    include_directories("${${${extlib}_UPPER}_INCLUDE_DIR}")
endmacro()

macro(sf_find_extlib extlib)
    sf_message("finding ${extlib} in ./..")
    sf_find_extlib_in_and_default_include(${extlib} "..")
endmacro()
