option(LUAI_ASSERT "turns on all assertions inside Lua." OFF)
if(LUAI_ASSERT)
  list(APPEND lua_defines LUAI_ASSERT)
endif(LUAI_ASSERT)

option(
  HARDSTACKTESTS
  "forces a reallocation of the stack at every point where the stack can be reallocated."
  OFF)
if(HARDSTACKTESTS)
  list(APPEND lua_defines HARDSTACKTESTS)
endif(HARDSTACKTESTS)

option(HARDMEMTESTS
       "forces a full collection at all points where the collector can run."
       OFF)
if(HARDMEMTESTS)
  list(APPEND lua_defines HARDMEMTESTS)
endif(HARDMEMTESTS)

option(EMERGENCYGCTESTS
       "forces an emergency collection at every single allocation." OFF)
if(EMERGENCYGCTESTS)
  list(APPEND lua_defines EMERGENCYGCTESTS)
endif(EMERGENCYGCTESTS)

option(
  EXTERNMEMCHECK
  "removes internal consistency checking of blocks being deallocated (useful when an external tool like valgrind does the check)."
  OFF)
if(EXTERNMEMCHECK)
  list(APPEND lua_defines EXTERNMEMCHECK)
endif(EXTERNMEMCHECK)

option(MAXINDEXRK "limits range of constants in RK instruction operands." OFF)
if(MAXINDEXRK)
  option(MAXINDEXRK_value "value for MAXINDEXRK" 255)
  list(APPEND lua_defines MAXINDEXRK=${MAXINDEXRK_value})
endif(MAXINDEXRK)

option(LUA_USE_CTYPE "" OFF)
if(LUA_USE_CTYPE)
  list(APPEND lua_defines LUA_USE_CTYPE)
endif(LUA_USE_CTYPE)

option(LUA_USE_APICHECK "" OFF)
if(LUA_USE_APICHECK)
  list(APPEND lua_defines LUA_USE_APICHECK)
endif(LUA_USE_APICHECK)

option(TESTS "" OFF)
if(TESTS)
  list(APPEND lua_defines LUA_USER_H='"ltests.h"')
endif(TESTS)

if(UNIX)
  set(LUA_USE_LINUX CACHE BOOL "enable Linux goodies" ON)
endif(UNIX)

option(LUA_USE_LINUX "enable Linux goodies" OFF)
if(LUA_USE_LINUX)
  list(APPEND lua_defines LUA_USE_LINUX)
endif(LUA_USE_LINUX)

option(LUA_EXE "build Lua executable" ON)
