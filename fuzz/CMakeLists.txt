cmake_minimum_required(VERSION 3.22.1)

project(sha3iuf_fuzz)

add_executable(${PROJECT_NAME} "fuzz.cc")
target_link_libraries(${PROJECT_NAME} PRIVATE sha3iuf_lib
                                              -fsanitize=fuzzer,address)

target_compile_options(${PROJECT_NAME} PRIVATE -g -O0 -Wall -Wextra -Werror
                                               -pedantic)
