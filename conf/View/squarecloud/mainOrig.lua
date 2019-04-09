-- path
package.path=package.path..";/usr/share/dashboard/lib/?.lua"
require('luarocks.loader')
require("common")
local EventLoader = require("data.EventLoader")
local cairo = require('cairo')
local colors= require("colors")
local SquareCloud = require("view.SquareCloud")
theme = require('theme')
-- configuration file
local conf = require("conf")

layout = {}
currPage = 0
maxPages = 0

function conky_init()
end

function conky_widgets()

-- reset current page and redo layout
if (currPage > maxPages) then
	currPage = 0 
end

--[[ 
Another new strategy:
As the creation of a new virtual machine is a relatively rare event,
we can try to calculate layout in the beginning of the loop. In this
strategy, we first gather all of the dom0's and all domU count, calculate
the layout, the amount of pages and then iterate over those pages,
gathering domU's data on every iteraction.

It implies that the layout table is going to be a global variable. Let's
hope that the memory usage doesn't grow exponentialy
--]] 


local loader = EventLoader:new(conf.server)
-- getting domU list
local domUlist = loader:getData(conf.hostsource)
--print_r(domUlist)

if currPage > #layout then
	currPage=0
end

-- layout magick
if currPage == 0 then
	local sitems = conf.grid.x*conf.grid.y
	for dom0,domUs in pairs(domUlist) do
		-- print_r(dom0,domUs)
		-- Why not sitems+2? because it looks better when we 
		-- are using 2 colums to let the first line be only
		-- the dom0 name,and so we add it here. On a different
		-- layout, it needs do be changed. Maybe next version...
		local dom0pages = math.ceil(#domUs/(sitems+2))
		for subpage=1,dom0pages do
			maxPages = maxPages+1
			local page = {}
			page.dom0 = dom0
			page.items = {}
			for vms=sitems*(subpage-1),sitems*subpage do
				if domUs[vms] ~= nil then
					page.items[vms] = domUs[vms]
				end
			end
			layout[#layout+1] = page
		end
	end
	currPage = 1
end



local dom0data = loader:getData(conf.datasource.fisicas .."." .. layout[currPage].dom0)


-- dom0
local ndata0 = {}
if dom0data ~= nil then
	if dom0data.cpu ~= nil then ndata0.cpu = dom0data.cpu.idle end
	if dom0data.mem ~= nil then ndata0.mem = dom0data.mem.free end
	if dom0data.net ~= nil then 
		ndata0.inbound =  dom0data.net.inbound or nil
		ndata0.outbound = dom0data.net.outbound or nil
	end
end

local cloud = SquareCloud(conf)
cloud:drawData(0,ndata0,layout[currPage].dom0)

-- Why not i=0? because it looks better when we 
-- are using 2 colums to let the first line be only
-- the dom0 name.

local i=1
local domUdata
for index,domUlist in pairs(layout[currPage].items) do
	i=i+1
	domUdata = loader:getData(conf.datasource.virtuais .. '.' .. domUlist)
	--print(layout[currPage].dom0,domUlist,index)
	-- manual mapping, simpler than a bunch of for loops, but ugly
	local ndata = {}
	if domUdata ~= nil then
		if domUdata.cpu ~= nil then ndata.cpu = domUdata.cpu.idle end
		if domUdata.mem ~= nil then ndata.mem = domUdata.mem.free end
		if domUdata.net ~= nil then 
			ndata.inbound = domUdata.net.inbound or nil
			ndata.outbound = domUdata.net.outbound or nil
		end
	end
	cloud:drawData(i,ndata,domUlist)
end

cloud:drawLabels(conf.labelmap)

cloud:destroy()

-- "turn" the page
currPage=currPage+1
end
