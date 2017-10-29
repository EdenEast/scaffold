# Scaffold

> **Shaded CMake aliases, macros and functions**

## Quick start
1. Add this repository as a submodule of your project, in `./extlibs/scaffold` or `./3rdparty/scaffold`:

    ```bash
    git submodule add https://github.com/cruizemissile/scaffold.git extlibs/scaffold
    ```

2. Include this repository in your project's CMakeLists:

    ```cmake
    list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/extlibs/scaffold/cmake")
    include(scaffold)
    ```
