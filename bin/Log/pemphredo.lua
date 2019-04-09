package.path=package.path..";/home/evandro.rodrigues/graea/?.lua;".."/home/evandro.rodrigues/graea/?/init.lua"
require('luarocks.loader')

local Pemphredo = require('lib.Log')

local conf = require('conf.Log')

local pemphredo = Pemphredo(conf)

pemphredo:init()

print_r(pemphredo)
function log(msg)
	-- print_r(msg)
	pemphredo:runFilters(msg)
end



