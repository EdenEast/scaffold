# Scaffold

> **Shaded CMake macros and functions**

Scaffold is a cmake library that helps you setup and maintain your cmake scripts. Scaffold is ment to be used as a submodule in your project.

## Quick start
1. Add this repository as a submodule of your project, in `./extlibs/scaffold` or `./3rdparty/scaffold` or `./third_party/scaffold`:

    ```bash
    git submodule add https://github.com/cruizemissile/scaffold.git extlibs/scaffold
    ```

2. Include this repository in your project's CMakeLists:

    ```cmake
    list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/extlibs/scaffold/cmake")
    include(scaffold)
    ```

## Example usage of Scaffold in your cmake project

### Setting up a project

```cmake
# Root CMakeLists.txt.

# Not sure the min version of cmake that is required.
# This needs to be tested. (currently developing with 3.9)
cmake_minimum_required(VERSION 3.0)

# Including Scaffold to start off
list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/extlibs/scaffold/cmake")
include(scaffold)

# Inital setup for the project. This call does the following:
#   - Checks to see that you are running cmake with a build folder
#   - Resolve an undefined BUILD_TYPE and will set the default to `Release`
#   - Create a project with the name passed. ex `foobar`
#   - enables testing for the project
#   - Defines the project name in uppercase ex `FOOBAR_UPPER`
#   - Defines the project's root dir. This is the same as `CMAKE_SOURCE_DIR` ex `FOOBAR_ROOT_DIR`
#   - Defines the project's source dir. This is default to `ROOT_DIR/PROJECT_NAME` ex `FOOBAR_SOURCE_DIR`
#   - Add common module paths for cmake
sf_init_project(foobar)

# Setting the c++ version for the project.
sf_set_cxxstd(17)

# Setting up the default subdirectories.
# The default subdirectories are:
#   - project_name
#   - samples
#   - tests
sf_add_default_subdirectories()

# Setting up common compiler flags depending on BUILD_TYPE and COMPILER
sf_add_common_compiler_flags()

# If this project is a header only project then we can setup the header only library
# that is used to link to other targets in cmake
#
# Note: ${FOOBAR_SOURCE_DIR} is defined when we called: `sf_init_project`
sf_header_only_install_glob("foobar" ${FOOBAR_SOURCE_DIR} "INSTALL")
```

### Setting up a target
```cmake
# TODO: sample here
```
