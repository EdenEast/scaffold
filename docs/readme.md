# Scaffold's Overview

Scaffold is a collection of functions and marcos to make getting up and running with
cmake easier. Most of my cmake files were copied from one project to another. If I
wanted to make a change to it I would have to update all projects. This became a pain
and I wanted something that I could just pull and run. To that end scaffold is make do
be a git submodule to any project. Simply add it as a submodule and include it.
Scaffold will then create... well the 'scaffold' of your cmake project. If you are
interested in using scaffold with your project you can look at some of my other
projects as an example of usage of scaffold.

- [**Eden**](https://github.com/cruizemissile/eden) A c++ 17 game engine
- [**Pride**](https://github.com/cruizemissile/pride) My core c++ 17 library
- [**Cml**](https://github.com/cruizemissile/cml) A **C**onstexpr **M**ath **L**ibrary

Scaffold performs operations on targets and because of this it requires a more resent
version of cmake. The current minimum required version is `3.8`. Please make sure that you have a current version of cmake to get the latest and greatest it has to offer.

Scaffold's macros and functions are denoted with the prefix `sf_`. This is due to
cmake's lack of namespace support.

## What does it do?

Scaffold will help you with:

- managing common and compiler specific compiler/linker flags
- create and configure libraries and executables with one call
- optional clone git repositories and include the project
- mimic folder structure of files in IDEs
- create a requirement for a certain c++ version (ie. 11, 14, 17...)
- check generation for sensible defaults that can be overriden

## Install

1. Add this repository as a submodule of your project:

    ```bash
    git submodule add https://github.com/cruizemissile/scaffold.git external/scaffold
    ```

2. Include this repository in your project's CMakeLists:

    ```cmake
    cmake_minimum_required(VERSION 3.8)
    project(foo) # Note: make sure that you declare the project before you include scaffold

    list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/external/scaffold")
    include(scaffold)
    ```



## NOTE TO ME
- creation of libraries and executables need to be able to take compiler and linker flags

-------
-------
-------
-------
-------
-------
-------
-------
-------

# compiler.cmake

### Compiler flags
- sf_gcc_compile_flags
- sf_clang_compile_flags
- sf_gcc_clang_compile_flags
- sf_msvc_compiler_flags

### Target functions
- sf_target_compile_flags
- sf_target_cxx

-------

# target.cmake

### Creation of target libraries
- sf_create_library
- sf_create_interface_library

### Creation of target executables
- sf_create_executable
- sf_create_executables_per_files
- sf_create_executables_per_folders

-------

# directory.cmake
- sf_list_directories

-------

# filter.cmake
- sf_target_set_folder
- sf_target_source_group

-------

# git.cmake
- sf_clone_external_git_repo
- sf_add_external_git_repo

-------

# common.cmake

### Things that including scaffold checks automagicly
- Check if install directory is not the build directory
- Check to see that we are not building in source
- Check if the build type is not selected for non-multi builds and set default to 'Debug'
- Set the default output directoy if one does not exist
- Set the default runtime output if one does not exist
- Set the default archive out directory if one does not exist
- Set the default library out directory if one does not exist
- set `CMAKE_INSTALL_MESSAGE` to be `LAZY`
- set `CMAKE_CXX_STANDARD_REQUIRED` to be `ON`
- set `CMAKE_CXX_EXTENTIONS` to be `OFF`
- Define the project name un uppper case and lower case

### Functions
- sf_check_master_project

-------

# operating_system.cmake
- Define what platform cmake is running on
- currently supported platforms
    - Windows
    - Linux
    - Macosx
    - Android
