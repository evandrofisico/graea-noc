-- path
package.path=package.path..";/usr/share/dashboard/lib/?.lua"
require('luarocks.loader')
require("common")
local EventLoader = require('data.EventLoader')
local cairo = require('cairo')
local colors= require("colors")
local Label = require("view.Label")
theme = require('theme')
-- configuration files
local conf = require('conf')

function conky_init()
print("iniciando")
eventtype = {
		["0"] = "Unclassified",
		["1"] = "Info",
		["2"] = "Warn",
		["3"] = "Avg",
		["4"] = "High", 	     
		["5"] = "Disaster",
		}

print("fim do init")
end



function conky_widgets()
--	-- forcar garbage collector a cada 20 updates
local updates = tonumber(conky_parse("$updates" ))
if updates%20 == 0  then
	-- rodar GC
	collectgarbage('collect')
end

local loader =  EventLoader:new(conf.server)
local data = loader:getData(conf.source)
local matriz = {}

for _,source in pairs(conf.filtersource) do
	local ndata = loader:getData(source)
	for asset,data in pairs(ndata) do
		matriz[asset] = data
	end
end

local label = Label(conf)
local index = 0
for priority=5,0,-1 do
	for _,sdata in pairs(data) do
		--gambi pra nao ter que ordenar array de dados
		if (tonumber(sdata.priority) == priority  and matriz[sdata.host] ~= nil ) then
			label:textWidget(index,sdata.title,sdata.description,eventtype[sdata.priority])
			index = index+1
		end
	end
end
label:destroy()
end
