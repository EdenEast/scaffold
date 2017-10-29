
# dependencies
include("${CMAKE_CURRENT_LIST_DIR}/sf_include.cmake")
sf_include_sf_dependency_once(sf_log)
sf_include_sf_dependency_once(sf_detection)
sf_include_sf_dependency_once(sf_flags)

macro(sf_set_cxxstd x)
    sf_message("settings required c++ standard to ${x}")

    # depending on the version of cmake CXX_STANDARD might not have 17
    if ("${x}" EQUAL "17")
        sf_message("${x} equals 17")
    	# before cmake version 3.8.2 c++ 17 does not exist
    	if (${CMAKE_VERSION} VERSION_GREATER 3.8.2)
    		set(CMAKE_CXX_STANDARD ${x}})
    		set(CMAKE_CXX_STANDARD_REQUIRED on)
			set(CMAKE_CXX_EXTENTIONS OFF)
    	endif()
    	
        # version is before 3.8.2 and does not support setting standard to 17
		if (SF_COMPILER_IS_MSVC)
			sf_add_compiler_flag("/std:c++latest")
		else()
			sf_add_compiler_flag("-std=c++1z")
		endif()
    else()
    	# this is 14 or below and should be included by older versions of cmake
		set(CMAKE_CXX_STANDARD ${x}})
    	set(CMAKE_CXX_STANDARD_REQUIRED on)
		set(CMAKE_CXX_EXTENTIONS OFF)
    endif()
endmacro()
