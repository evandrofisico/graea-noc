package.path=package.path..";/usr/share/hecate-dash/?.lua;/usr/share/hecate-dash/?/init.lua"

require('luarocks.loader')
require('lib.common')


local pegasus = require('pegasus')
local apr = require("apr")
local cjson = require("cjson")
local Deino = require('lib.Deino')
local EventLoader = require("lib.common.data.EventLoader")
local conf = require("conf")



local deino = Deino(conf)

-- load plugins
deino:init()

-- run webservice
deino:run()

