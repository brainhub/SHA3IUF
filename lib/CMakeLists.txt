cmake_minimum_required(VERSION 3.22.1)

project(sha3iuf_lib)

set(BUILD_TYPE
    "STATIC"
    CACHE STRING "Build type")

if(BUILD_SHARED_LIBS)
  add_library(${PROJECT_NAME} SHARED "src/sha3.c")
else()
  add_library(${PROJECT_NAME} STATIC "src/sha3.c")
endif()
target_include_directories(${PROJECT_NAME} PUBLIC "include")
target_compile_options(${PROJECT_NAME} PRIVATE -Wall -Wextra -Werror -pedantic)
