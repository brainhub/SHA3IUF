cmake_minimum_required(VERSION 3.22.1)

project(sha3iuf)

set(CMAKE_C_STANDARD 99)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_subdirectory(lib)

if(BUILD_TESTING)
  add_subdirectory(test)
endif()

if(BUILD_EXAMPLE)
  add_subdirectory(example)
endif()

if(BUILD_FUZZER)
  add_subdirectory(fuzz)
endif()
