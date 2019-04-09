-- path
package.path=package.path..";/usr/share/dashboard/lib/?.lua"
require("common")
require('luarocks.loader')
local cairo = require('cairo')
local Label = require("view.Label")
DBLoader = require("data.DBLoader")
-- configuration files
theme = require("theme")
local conf = require("conf")

--

function conky_init()
end

function conky_widgets()
--	-- forcar garbage collector a cada 20 updates
local updates = tonumber(conky_parse("$updates" ))
if updates%20 == 0  then
	-- rodar GC
	collectgarbage('collect')
end

local loader = DBLoader:new(conf)
local label = Label(conf)
local eventCount = conf.grid.y+1

local events = loader:getData(eventCount)
for index=0,eventCount-1 do
	if events[index+1].state ~= nil then
	local event = events[index+1]
	label:textWidget(index,event.title,event.description,event.state:lower())
	end
end
label:destroy()
end
