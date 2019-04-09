package.path=package.path..";/home/evandro.rodrigues/graea/?.lua;".."/home/evandro.rodrigues/graea/?/init.lua"
require('luarocks.loader')

local Pemphredo = require('lib.NLog.Injector')

local conf = require('conf.NLog')

local injetor = Pemphredo(conf)

injetor:init()
local messages=0
print_r(injetor)
function log(msg)
	messages = messages +1
	injetor:runFilters(msg)
	--print(messages)
end



