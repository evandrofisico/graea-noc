#!/usr/bin/luajit-2.0.0-beta9
-- lua dependencies
--package.path=package.path..";/usr/share/hecate-dash/?.lua;".."/usr/share/hecate-dash/?/init.lua"
package.path=package.path..";/home/evandro.rodrigues/graea/?.lua;".."/home/evandro.rodrigues/graea/?/init.lua"

require('luarocks.loader')
require('lib.common')

local DataDaemon = require('lib.Agent')

local conf = require('conf.Agent')
local dd = DataDaemon(conf)

dd:init()
dd:Loop()
