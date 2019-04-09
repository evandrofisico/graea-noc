-- path
package.path=package.path..";/usr/share/dashboard/lib/?.lua"
require('luarocks.loader')
require("common")
local cairo = require('cairo')
local colors = require("colors")
local EventLoader = require("data.EventLoader")
-- script sources
Text = require("view.DrawText")
local Mapa = require("view.Mapa")
-- configuration files
theme = require('theme')
local conf = require('conf')
local locations = require('assets')
local brasil = require('brazil')

group = 0

function conky_start()
end


function conky_widgets()
local loader = EventLoader(conf.server)

local itemdata = {}

if group > #conf.services then
	group = 1
else
	group = group + 1
end

-- load data for the current showing service
local servicedata = {}
for _,source in pairs(conf.services[group].source) do
	local l0,l1 = conf.services[group].item:match("(%w*).(%w*)")
	local itemdata = loader:getData(conf.sourceroot.."."..source)
	-- flatten data from multiple groups into a single table
	for name,asset in pairs(itemdata) do
		print(name,conf.services[group].description)
		print(l0,l1)
		print_r(asset)
		servicedata[name] = asset[l0][l1]
	end
end
--print_r(servicedata)

local mapa = Mapa(conf)
mapa:InsertLocations(locations)
-- map title
mapa.text:Draw({text = conf.services[group].description, sizeby = 'height', height=60, x=30,y=60})

--shapes
local labelUnits = {}
local labelIndex = 0
for unit,value in pairs(servicedata) do
	value = tonumber(value)
	if locations[unit].maptype == "shape" then
		if conf.services[group].type == "discrete" then
		mapa:DrawShape(unit,dict[value])
			if value > 0 then
			labelIndex = labelIndex + 1
			labelUnits[labelIndex] = { name = unit, status= dict[value] }
			end
		elseif conf.services[group].type == "heat" then
		mapa:DrawShape(unit,value)
			if value > 90 then
			labelIndex = labelIndex + 1
			labelUnits[labelIndex] = { name = unit, status = value }
			end
		end
	end
end
-- now, points over those shapes
for unit,value in pairs(servicedata) do
	value = tonumber(value)
	if locations[unit].maptype == "point" then
		if conf.services[group].type == "discrete" then
		mp:DrawPoint(unit,dict[value],pointsizes[unit])
			if value > 0 then
			labelIndex = labelIndex + 1
			labelUnits[labelIndex] = { name = unit, status = dict[value] }
			end
		elseif conf.services[group].type == "heat" then
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


end
