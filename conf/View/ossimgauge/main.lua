-- path
package.path=package.path..";/usr/share/dashboard/lib/?.lua"
require('luarocks.loader')
require("common")
local cairo = require('cairo')
local colors = require("colors")
local MultiGauge = require("view.MultiGauge")
local EventLoader = require('data.EventLoader')
theme = require('theme')
-- configuration files
local conf = require('conf')

function conky_init()
end


function conky_widgets()
local updates = tonumber(conky_parse("$updates" ))
if updates%20 == 0  then
	-- rodar GC
	collectgarbage('collect')
end

local loader = EventLoader:new(conf.server)
local gauge = MultiGauge(conf)
gauge:drawTitle(conf.title)
--
local index = 1
local data = loader:getData(conf.source)
for name,itemtable in pairs(data) do
	gauge:drawNew(index,name,itemtable)
	index = index + 1
end
gauge:destroy()
end
