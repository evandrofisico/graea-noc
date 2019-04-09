-- path
package.path=package.path..";/usr/share/dashboard/lib/?.lua"
-- lua dependencies
require('luarocks.loader')
require("common")
local cairo = require('cairo')
local colors = require("colors")
local SpamStatLoader = require('data.SpamStatLoader')
-- local EventLoader = require("data.EventLoader")
-- script sources 
local PieChart = require("view.PieChart")
theme = require("theme")
-- configuration files
local conf=require("conf")

function conky_start()
end

function conky_widgets()
local loader = SpamStatLoader:new(conf)
local piechart = PieChart(conf)
local data = loader:getDataHour()
allzeros = true
for i,v in pairs(data) do
	if v ~= "0" then
		allzeros = false
		break
	end
end

if allzeros == true then
	data["No Incoming Email!"] = 1
end


piechart:drawPieChart(conf.title,conf.datatitle,data)
piechart:destroy()
end
