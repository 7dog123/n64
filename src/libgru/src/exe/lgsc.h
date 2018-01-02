#ifndef GRU_LGSC_H
#define GRU_LGSC_H
#include <config.h>
#ifdef HAVE_LUA5_3_LUA_H
#include <lua5.3/lua.h>
#else
#include <lua.h>
#endif
#include "../lib/libgru.h"

void            lgru_gsc_register(lua_State *L);
struct gru_gsc *lgru_gsc_create(lua_State *L);

#endif
