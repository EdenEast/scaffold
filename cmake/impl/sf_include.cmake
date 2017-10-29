# include a cmake module only once
macro(sf_include_module_once x)
    if (NOT ${x}_INCLUDED)
        include(${x})
        set("${x}_INCLUDED" true)
    endif()
endmacro()

# include a inner scafold impl module only once
macro(sf_include_sf_impl_once x)
    if (NOT ${x}_INCLUDED)
        include("${CMAKE_CURRENT_LIST_DIR}/impl/${x}.cmake")
        set("${x}_INCLUDED" true)
    endif()
endmacro()

# include an inner scafold dependency only once
macro(sf_include_sf_dependency_once x)
    if (NOT ${x}_INCLUDED)
        include("${CMAKE_CURRENT_LIST_DIR}/${x}.cmake")
        set("${x}_INCLUDED" true)
    endif()
endmacro()
