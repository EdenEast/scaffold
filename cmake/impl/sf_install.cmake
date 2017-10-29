
include("${CMAKE_CURRENT_LIST_DIR}/sf_include.cmake")
sf_include_sf_dependency_once(sf_log)

# creates an install target that installs the project as a header-only
# library. library files are in the `file_list`. the `src_dir` is
# copied to the dest_dir
macro(sf_header_only_install file_list src_dir dest_dir)
    sf_message("added header-only install target")

    add_custom_target(HEADER_ONLY_TARGET SOURCES ${file_list})
    set_target_properties(HEADER_ONLY_TARGET PROPERTIES LINKER_LANGUAGE CXX)
    install(DIRECTORY ${src_dir} DESTINIATION ${dest_dir})
endmacro()


# creates an install target that installs the project as a header-only library.
# auto `src_dir`
macro(sf_header_only_install_glob src_dir dest_dir)
    sf_message("globbing ${src_dir} for header-only install")

    file(GLOB_RECURSE INSTALL_FILES_LIST "${src_dir}/*")

    sf_header_only_install("${INSTALL_FILES_LIST}" "${src_dir}" "${dest_dir}")
endmacro()

macro(sf_create_include_directory file_list source_dir include_dir)
	# pruning the list of files to only have *.h *.hpp *.inl files
	foreach(source ${file_list})
		get_filename_component(ext "${source}" EXT)
		if ("${ext}" MATCHES ".h" OR 
			"${ext}" MATCHES ".hpp" OR 
			"${ext}" MATCHES ".inl")
			list(APPEND header_list ${source})
		endif()
	endforeach()

	foreach(source ${header_list})
		file(RELATIVE_PATH rel_path "${source_dir}" "${source}")
		get_filename_component(source_path "${rel_path}" PATH)
		file(COPY ${source} DESTINATION "${include_dir}/${source_path}")
	endforeach()
endmacro()
