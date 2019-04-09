-- path
package.path=package.path..";/usr/share/dashboard/lib/?.lua"
require('luarocks.loader')
require("common")
local cairo  = require('cairo')
local colors = require("colors")
local EventLoader = require('data.EventLoader')
theme = require('theme')
local conf = require('conf')

function conky_widgets()
	-- gambi experimental
	--	-- forcar garbage collector a cada 20 updates
	local updates = tonumber(conky_parse("$updates" ))
	if updates%20 == 0  then
		-- rodar GC
		collectgarbage('collect')
	end
	if conky_window ~=nil then
		require('lua-nucleo.strict')
	end

	local ClockWidget = require('view.ClockWidget')
	local loader = EventLoader:new(conf.server)
	local data = loader:getData(conf.source)
	local clock = ClockWidget(conf)
	clock:draw()
	clock:drawWeather(data)
	clock:destroy()
end
