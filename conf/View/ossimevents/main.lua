-- path
package.path=package.path..";/usr/share/dashboard/lib/?.lua"
require('luarocks.loader')
require("common")
local cairo = require('cairo')
local colors = require("colors")
local PieChart = require("view.PieChart")
local EventLoader = require('data.EventLoader')
theme = require('theme')
-- configuration files
local propEventsProduct = require('confEventsProduct')
local propEventsCategory = require('confEventsCategory')
local propOcurrences = require('confOcurrences')
local confs = { propEventsProduct, propEventsCategory, propOcurrences  }

function conky_start()
end

function conky_widgets()
loader = EventLoader:new(confs[1].server)
-- widget 1
for _,conf in pairs(confs) do
	local ossimevents = PieChart:new(conf)
	local data = loader:getData(conf.source)
	ossimevents:drawPieChart(conf.title,conf.title,data)
	ossimevents:destroy()
end
end
