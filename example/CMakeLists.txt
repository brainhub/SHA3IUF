cmake_minimum_required(VERSION 3.22.1)

project(sha3iuf_example)

add_executable(${PROJECT_NAME} "main.c")
target_link_libraries(${PROJECT_NAME} sha3iuf_lib)
target_compile_options(${PROJECT_NAME} PRIVATE -Wall -Wextra -Werror -pedantic)
