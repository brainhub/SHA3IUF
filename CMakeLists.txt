cmake_minimum_required(VERSION 3.21.0)

project(sha3)

# Set the C standard to C99
set(CMAKE_C_STANDARD 99)

# Global compile options and include directories
add_compile_options(-Wall -Wextra -Wpedantic -O3 -g)
include_directories(BEFORE ./include)

# Add a dynamic library target
add_library(sha3_dynamic SHARED ./src/sha3.c)
set_target_properties(
    sha3_dynamic
    PROPERTIES
        OUTPUT_NAME "sha3"   
)

# Add a static library target
add_library(sha3_static STATIC ./src/sha3.c)
set_target_properties(
    sha3_static
    PROPERTIES
        OUTPUT_NAME "sha3"
)

# Add sha3sum utility binary target
add_executable(sha3sum ./src/sha3.c ./src/sha3sum.c)

# Add sha3test utility binary target
add_executable(sha3test ./src/sha3.c ./src/sha3test.c)
