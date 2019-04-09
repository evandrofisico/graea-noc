-- path
package.path=package.path..";/usr/share/dashboard/lib/?.lua"
-- lua dependencies
require('luarocks.loader')
require('cairo')
require("colors")
apr = require("apr")
cjson = require("cjson")
-- script sources
require("common")
require("Text")
require("Label")
require("BarGraph")
-- configuration files
dofile("/usr/share/dashboard/share/theme.lua")
dofile("/usr/share/dashboard/share/brazil.lua")
dofile("/usr/share/dashboard/share/assets.lua")
dofile("conf.lua")
dofile("EventLoader.lua")

function conky_init()
	print("iniciando carga dos dados")
	units = {}
	unitService = {}
	unitCount = 0 
	_G.index = 0
	_G.loader = EventsLoader:new()
	
	for _,service in pairs(prop.services) do
		for location,_ in pairs(locations) do
		local data = loader:GetDataItem(location.."_"..service.assets,service.source)
			if data ~= nil then
			unitCount = unitCount + 1
			units[unitCount] = {} 
			units[unitCount].name = location.."_"..service.assets
			units[unitCount].type = service.type
			units[unitCount].data = data
			end
		end
	end
print("fim da carga dos dados")
end



function conky_widgets()
if tonumber(conky_parse("${updates}")) < 2 then
	return
end
local cs = BarGraph:new(prop)

if index + prop.grid.y > unitCount then
	index = 0
	-- recarregar os dados 
	conky_init()
end

for u = 1, prop.grid.y do
	local unitIndex = index + u
	cs:drawWidget(u, units[unitIndex].type, units[unitIndex].name, units[unitIndex].data)
end


index = index + 1
cs:destroy()
end
