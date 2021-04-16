project(SoaFranca)
cmake_minimum_required(VERSION 3.1.3)
set(CMAKE_CXX_STANDARD 11)

if (CMAKE_HOST_APPLE)
    add_compile_options(-Wno-attributes  -Wno-error=deprecated-declarations)
endif ()

add_subdirectory(thirdparty)
