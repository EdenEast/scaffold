# Scaffold

> **Shaded CMake macros and functions**

Scaffold is a cmake library that helps you setup and maintain your cmake scripts. Scaffold is ment to be used as a submodule in your project.

## Quick start
1. Add this repository as a submodule of your project:

    ```bash
    git submodule add https://github.com/cruizemissile/scaffold.git external/scaffold
    ```

2. Include this repository in your project's CMakeLists:

    ```cmake
    cmake_minimum_required(VERSION 3.7)
    project(foo) # Note: make sure that you declare the project before you include scaffold

    list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/external/scaffold")
    include(scaffold)
    ```

## Example usage of Scaffold in your cmake project

### Setting up a project

```cmake
# Root CMakeLists.txt.

# Not sure the min version of cmake that is required.
# This needs to be tested. (currently developing with 3.9)
cmake_minimum_required(VERSION 3.7)

# Make sure that you define the project before you include 
# Scaffold into your file
project(foo)

# Include scaffold into the project from where you added 
# it as a submodule
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/external/scaffold")
include(scaffold)

# Here we are checking to see if the project is the master project.
# We can create options based on if the project is the master or not.
# Only build samples and tests if we are the master project.
# If we are a submodule then we dont have to build the sample and tests.
check_master_project(FOO_MASTER_PROJECT)
option(ENABLE_SAMPLES "Build samples for foo" ${FOO_MASTER_PROJECT})
option(ENABLE_TESTS "Build tests for foo" ${FOO_MASTER_PROJECT})

# Include the subdirectory that defines the the target
add_subdirectory(foo)

if(ENABLE_SAMPLES)
    add_subdirectory(samples)
endif()

if(ENABLE_TESTS)
    add_subdirectory(tests)
endif()
```

### Setting up a target
```cmake
# foo/CMakeLists.txt

# -------------------------------------------------
# An example of a library target
file(GLOB_RECURSE source_files
    "${CMAKE_CURRENT_LIST_DIR}/*.hpp"
    "${CMAKE_CURRENT_LIST_DIR}/*.cpp"
)

add_library(foo "${source_files}")
target_common_compiler_flags(foo PUBLIC)
target_source_group(foo)

# -------------------------------------------------
# An example of a header only / interface library
file(GLOB_RECURSE source_files
    "${CMAKE_CURRENT_LIST_DIR}/*.hpp"
)

add_library(bar INTERFACE)
target_common_compiler_flags(foo INTERFACE)
target_source_group(foo)
```
