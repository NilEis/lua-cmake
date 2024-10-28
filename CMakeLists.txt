cmake_minimum_required(VERSION 3.21.0)
project(
  lua
  VERSION 0.1.0
  LANGUAGES C)

set(lua_defines)
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/options.cmake)

# Warnings valid for both C and C++
set(CWARNSCPP)
# Warnings for gcc, not valid for clang
set(CWARNGCC)
# The next warnings are neither valid nor needed for C++
set(CWARNSC)
set(CFLAGS)

if(CMAKE_C_COMPILER_ID STREQUAL "MSVC")
  list(APPEND CWARNSCPP /W4)
  # list(APPEND CWARNSCPP /Wx)
elseif(CMAKE_C_COMPILER_ID STREQUAL "Clang" OR CMAKE_C_COMPILER_ID STREQUAL
                                               "GNU")

  if(CMAKE_C_COMPILER_ID STREQUAL "GNU")
    list(APPEND CWARNGCC -Wlogical-op)
    list(APPEND CWARNGCC -Wno-aggressive-loop-optimizations)
  endif()
  list(APPEND CWARNSCPP -Wfatal-errors)
  list(APPEND CWARNSCPP -Wextra)
  list(APPEND CWARNSCPP -Wshadow)
  list(APPEND CWARNSCPP -Wundef)
  list(APPEND CWARNSCPP -Wwrite-strings)
  list(APPEND CWARNSCPP -Wredundant-decls)
  list(APPEND CWARNSCPP -Wdisabled-optimization)
  list(APPEND CWARNSCPP -Wdouble-promotion)
  list(APPEND CWARNSCPP -Wmissing-declarations)
  list(APPEND CWARNSCPP -Wconversion)
  # the next warnings might be useful sometimes

  # list(APPEND CWARNSCPP -Werror)

  # list(APPEND CWARNSCPP -pedantic)

  # list(APPEND CWARNSCPP -Wsign-conversion)

  # list(APPEND CWARNSCPP -Wstrict-overflow=2)

  # list(APPEND CWARNSCPP -Wformat=2)

  # list(APPEND CWARNSCPP -Wcast-qual)
  list(APPEND CWARNSC -Wdeclaration-after-statement)
  list(APPEND CWARNSC -Wmissing-prototypes)
  list(APPEND CWARNSC -Wnested-externs)
  list(APPEND CWARNSC -Wstrict-prototypes)
  list(APPEND CWARNSC -Wc++-compat)
  list(APPEND CWARNSC -Wold-style-definition)
  list(APPEND CFLAGS -fno-stack-protector)
  list(APPEND CFLAGS -fno-common)
  list(APPEND CFLAGS -march=native)
else()
  message(STATUS "Unknown compiler, not setting any C/CPP warnings")
endif()

set(CWARNS ${CWARNSCPP} ${CWARNSC} ${CWARNGCC})

set(CORE_FILES
    lapi.c
    lcode.c
    lctype.c
    ldebug.c
    ldo.c
    ldump.c
    lfunc.c
    lgc.c
    llex.c
    lmem.c
    lobject.c
    lopcodes.c
    lparser.c
    lstate.c
    lstring.c
    ltable.c
    ltm.c
    lundump.c
    lvm.c
    lzio.c
    ltests.c)
list(TRANSFORM CORE_FILES PREPEND "${CMAKE_CURRENT_SOURCE_DIR}/")

set(AUX_FILES lauxlib.c)
list(TRANSFORM AUX_FILES PREPEND "${CMAKE_CURRENT_SOURCE_DIR}/")

set(LIB_FILES
    lbaselib.c
    ldblib.c
    liolib.c
    lmathlib.c
    loslib.c
    ltablib.c
    lstrlib.c
    lutf8lib.c
    loadlib.c
    lcorolib.c
    linit.c)
list(TRANSFORM LIB_FILES PREPEND "${CMAKE_CURRENT_SOURCE_DIR}/")

set(EXE_FILES lua.c)
list(TRANSFORM EXE_FILES PREPEND "${CMAKE_CURRENT_SOURCE_DIR}/")

add_library(lua_lib STATIC ${CORE_FILES} ${AUX_FILES} ${LIB_FILES})

target_include_directories(lua_lib PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})

set_property(TARGET lua_lib PROPERTY C_STANDARD 99)
set_target_properties(lua_lib PROPERTIES OUTPUT_NAME "lua")

if(LUA_EXE)
  add_executable(lua_exe ${EXE_FILES})
  target_link_libraries(lua_exe PUBLIC lua_lib)
  set_property(TARGET lua_exe PROPERTY C_STANDARD 99)
  set_target_properties(lua_exe PROPERTIES OUTPUT_NAME "lua")
  find_library(MATH_LIBRARY m)
  if(MATH_LIBRARY)
    target_link_libraries(lua_exe PUBLIC ${MATH_LIBRARY})
  endif(MATH_LIBRARY)
endif(LUA_EXE)

include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/create_clangd.cmake)
