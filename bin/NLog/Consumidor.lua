package.path=package.path..";/home/evandro.rodrigues/graea/?.lua;".."/home/evandro.rodrigues/graea/?/init.lua"
require('luarocks.loader')

local Consumer = require('lib.NLog.Consumer')

local conf = require('conf.NLog')

local consumer = Consumer(conf)

consumer:init()

--print_r(consumer)


consumer:runFilters()
