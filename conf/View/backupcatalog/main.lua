-- path
package.path=package.path..";/usr/share/dashboard/lib/?.lua"
-- lua dependencies
require('luarocks.loader')
require("common")
local cairo = require('cairo')
local colors = require("colors")
local EventLoader = require("data.EventLoader")
-- script sources 
local ListItem = require("view.ListItem")
theme = require("theme")
-- configuration files
dofile("conf.lua")

function conky_start()
end

function conky_widgets()

local loader = EventLoader:new(prop.server)
local listitem = ListItem(prop)
local data = loader:getData(prop.source)
local filterdata = {}
local itemcount=0
for i,v in pairs(prop.translabel) do
	itemcount = itemcount+1
	filterdata[v] = data[i];
end


listitem:drawLabel(itemcount,filterdata)
listitem:destroy()
end
