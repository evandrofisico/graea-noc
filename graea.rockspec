package = "graea"
version = "0.0.1-1"
source = {
   url = "http://matthewwild.co.uk/projects/luaexpat/luaexpat-1.3.0.tar.gz"
}
description = {
   summary = "Graea Monitor System",
   detailed = [[
      Graea is a set of data aquiring daemons and user widgets to show monitoring
      data.
   ]],
   license = "MIT/X11",
   homepage = "https://github.com/evandrofisico/graea"
}
dependencies = {
   "luajit >= 2.0.3",
   "lua-apr",         
   "lua-cjson",       
   "lua-curl",
   "lua-ev",
   "luasql-postgres",
   "luasql-sqlite3"

}

