-- path
package.path=package.path..";/usr/share/dashboard/lib/?.lua"
require('luarocks.loader')
require("common")
local cairo = require('cairo')
local colors = require("colors")
-- script sources
Text = require("view.DrawText")
local Mapa = require("view.Mapa")
-- configuration files
theme = require('theme')
dofile("/usr/share/dashboard/share/brazil.lua")
dofile("/usr/share/dashboard/share/assets.lua")
dofile("conf.lua")
dofile("EventLoader.lua")

group = 0

function conky_start()
end


function conky_widgets()

local dict = { }
dict[0] = "up"
dict[1] = "down"
dict[2] = "intermitent"
local loader = EventsLoader:new()

if tonumber(conky_parse("${updates}")) < 1 then
	return
end

local mp = Mapa(prop)
mp:ConvertData(brazil)
	-- funcao para circular modos do mapa
if prop.services[group+1] == nil then
	group = 1
else
	group = group+1
end

mp:InsertLocations(locations)
local showgrp = prop.services[group]
mp.text:Draw({text = showgrp["description"] ,sizeby = 'height', height=60, x=30,y=60})
-- data to draw
local mapdata = loader:GetData(locations,showgrp.source,showgrp.assets)
-- data for the unit point sizes
local pointsizes = loader:GetData(locations,showgrp.pointsize,showgrp.assets)

local labelUnits = {}
local labelIndex = 0
	--[[ Our definitions (nagios-based) are on the dict table
		and values larger than 0 are erro values
	--]] 
	-- drawing units, shapes first
for unit,value in pairs(mapdata) do
	value = tonumber(value)
	if locations[unit].maptype == "shape" then
		if prop.services[group].type == "discrete" then
		mp:DrawShape(unit,dict[value])
			if value > 0 then
			labelIndex = labelIndex + 1
			labelUnits[labelIndex] = { name = unit, status= dict[value] }
			end
		elseif prop.services[group].type == "heat" then
		mp:DrawShape(unit,value)
			if value > 90 then
			labelIndex = labelIndex + 1
			labelUnits[labelIndex] = { name = unit, status = value }
			end
		end
	end
end
	-- now, points over those shapes
for unit,value in pairs(mapdata) do
	value = tonumber(value)
	if locations[unit].maptype == "point" then
		if prop.services[group].type == "discrete" then
		mp:DrawPoint(unit,dict[value],pointsizes[unit])
			if value > 0 then
			labelIndex = labelIndex + 1
			labelUnits[labelIndex] = { name = unit, status = dict[value] }
			end
		elseif prop.services[group].type == "heat" then
		mp:DrawPoint(unit,value,pointsizes[unit])
			if value > 90 then
			labelIndex = labelIndex + 1
			labelUnits[labelIndex] = { name = unit, status = value }
			end
		end
	end
end


table.sort(labelUnits, function (x,y) 
			return locations[x.name].lat > locations[y.name].lat 
		   end )

for i,status in pairs(labelUnits) do
	mp:DrawLabel(status.name,status.status,i)
end
--
---- teste de pontos avulsos fora do mapa
--mp:DrawPoint("noronha","up",100)
----mp:SavePNG()	
--
mp:destroy()
--end
end
