#include <stdio.h>
#include <stdlib.h>
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
#include <luajit.h>

int main(int argc, char* argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <filename>\n", argv[0]);
        return 1;
    }

    const char* fname = argv[1];
    FILE* fp;
    long fsize;
    char* contents;
    lua_State* L;

    // Open the file for reading
    fp = fopen(fname, "rb");
    if (fp == NULL) {
        fprintf(stderr, "Error opening file\n");
        exit(1);
    }

    // Determine the size of the file
    fseek(fp, 0, SEEK_END);
    fsize = ftell(fp);
    fseek(fp, 0, SEEK_SET);

    // Allocate memory for the file contents
    contents = (char*) malloc(fsize + 1);

    // Read the file into the buffer
    fread(contents, fsize, 1, fp);

    // Add a null terminator to the end of the string
    contents[fsize] = '\0';

    // Initialize LuaJIT
    L = luaL_newstate();
    luaL_openlibs(L);

    // Load the Lua code
    if (luaL_loadstring(L, contents) != 0) {
        fprintf(stderr, "Error loading Lua code: %s\n", lua_tostring(L, -1));
        exit(1);
    }

    // Run the Lua code
    if (lua_pcall(L, 0, 0, 0) != 0) {
        fprintf(stderr, "Error running Lua code: %s\n", lua_tostring(L, -1));
        exit(1);
    }

    // Clean up
    free(contents);
    lua_close(L);
    fclose(fp);

    return 0;
}

