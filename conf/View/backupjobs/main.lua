-- path
package.path=package.path..";/usr/share/dashboard/lib/?.lua"
-- lua dependencies
require('luarocks.loader')
require("common")
local cairo = require('cairo')
local colors = require("colors")
local EventLoader = require("data.EventLoader")
-- script sources 
local PieChart = require("view.PieChart")
theme = require("theme")
-- configuration files
dofile("conf.lua")

function conky_start()
end

function conky_widgets()
local loader = EventLoader:new(prop.server)
local piechart = PieChart(prop)
local data = loader:getData(prop.source)
allzeros = true
for i,v in pairs(data) do
	if v ~= "0" then
		allzeros = false
		break
	end
end

if allzeros == true then
	data["No Jobs Run!"] = 1
end


piechart:drawPieChart(prop.title,prop.datatitle,data)
piechart:destroy()
end
