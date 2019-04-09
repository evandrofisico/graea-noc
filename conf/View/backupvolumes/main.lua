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
-- configuration files
theme = require("theme")
dofile("conf.lua")

function conky_start()
end

function conky_widgets()
local loader = EventLoader:new(prop.server)
local piechart = PieChart(prop)
local data = loader:getData(prop.source)
print_r(data)
piechart:drawPieChart(prop.title,prop.datatitle,data)
piechart:destroy()
end
