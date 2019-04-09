-- path
package.path=package.path..";/usr/share/dashboard/lib/?.lua"
require("common")
require('luarocks.loader')
local cairo = require('cairo')
local colors = require("colors")
-- script sources
local Label = require("view.Label")
-- configuration files
theme = require('theme')
local conf = require("conf")
local EventsLoader = require("EventLoader")


function conky_init()
end



function conky_widgets()
--	-- forcar garbage collector a cada 20 updates
local updates = tonumber(conky_parse("$updates" ))

if updates < 10 then
	return 0
end

if updates%20 == 0  then
	-- rodar GC
	collectgarbage('collect')
end

local loader = EventsLoader:new(conf.server)

local firewall = { 
	cpu = { "cpu.user", "cpu.system", "cpu.nice"  },  
	mem = { "mem.buffer", "mem.cache", "mem.free", }, 
	net = { "eth200", "eth192", "eth104", "eth10",  }, 
}

local label = Label(conf)
local totalindex = 0
local fwdata = {}
for dtype, data in pairs(firewall) do
	if dtype == "net" then
		for _,iface in pairs (data) do
		-- second loop to get one item for each interface
		local netsrc = { "net."..iface..".inbound", "net."..iface..".outbound"}
		fwdata[totalindex] = {}
		fwdata[totalindex].type  = dtype
		fwdata[totalindex].name  = "firewall "..iface
		fwdata[totalindex].data = loader:GetDataItem("firewall",netsrc)
		totalindex = totalindex +1
		end
	else
		fwdata[totalindex] = {}
		fwdata[totalindex].type  = dtype
		fwdata[totalindex].name  = "firewall "..dtype
		fwdata[totalindex].data = loader:GetDataItem("firewall",data)
		totalindex = totalindex +1
	end
end

label.properties.grid.y = totalindex
for i=0, totalindex-1 do
	------
	--function BarGraph:drawWidget(index,ltype,title,data)
	if (fwdata[i].type == "cpu" or fwdata[i].type == "mem" ) then
		label:singleGraph(i,fwdata[i].name,fwdata[i].data,fwdata[i].type)
	elseif fwdata[i].type == "net" then
		label:dualGraph(i,fwdata[i].name,fwdata[i].data)
	end
	--end
	--cs:drawWidget(i, fwdata[i].type, fwdata[i].name, fwdata[i].data)
	-----
end

label:destroy()

end
