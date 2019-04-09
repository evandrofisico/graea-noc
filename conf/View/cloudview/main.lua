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
require("CloudView")
require("Backup")
-- configuration files
dofile("/usr/share/dashboard/share/theme.lua")
dofile("conf.lua")
dofile("EventLoader.lua")

cloudlist = {}
currDom0 = 1
currPage = 0

function conky_init()
_G.loader = EventsLoader:new()
cloudlist = loader:GetDataItem(prop.hostsource)
end

function conky_widgets()
-- function to circle all avaliable servers
-- if cloudlist[currDom0+1] == nil then
-- 	currDom0 = 1
-- else
-- 	currDom0 = currDom0+1
-- end
-- data for the dom0 graph

local dom0_data = {}
for item, name in pairs(prop.datasource) do
	dom0_data[item] = loader:GetDataItem(cloudlist[currDom0].."."..name)
end
local Cindex = -1
local cloud = CloudView:new(prop)
cloud:drawTitle(Cindex,cloudlist[currDom0])
cloud:drawCircles(Cindex,dom0_data)
-- getting domU list
local domUlist = loader:GetDataItem(cloudlist[currDom0]..".vms")
--print_r(domUlist)

if domUlist == nil then
	pages = 1
else
	pages = math.floor(#domUlist/7)
end

--local pages = math.floor(#domUlist/7)

for i=0,6 do
	local domUdata = {}
	local index = (i+1)+7*currPage
		--print(i,index,domUlist[index])
	if domUlist ~= nil then
		if domUlist[index] ~= nil then
			for item, name in pairs(prop.datasource) do
			domUdata[item] = loader:GetDataItem(domUlist[index].."."..name)
			end
			cloud:drawCircles(i,domUdata)
			cloud:drawTitle(i,domUlist[index])
		end
	end
end


if currPage+1 >= pages then
	currPage = 0
	if cloudlist[currDom0+1] == nil then
		currDom0 = 1
	else
		currDom0 = currDom0+1
	end
else
	currPage = currPage+1
end
-- labels dos tipos de dado
cloud:drawLabels(prop.datasource)

cloud:destroy()
end
