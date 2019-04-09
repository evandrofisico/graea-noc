-- path
package.path=package.path..";/usr/share/dashboard/lib/?.lua"
require('luarocks.loader')
require("common")
local EventLoader = require("data.EventLoader")
local cairo = require('cairo')
local colors= require("colors")
-- script sources
local Label = require("view.Label")
theme = require('theme')
local conf = require('conf')

function conky_init()
end

function compare(a,b)
	if a.val > b.val then
		return true
	end
end

function conky_widgets()
--	-- forcar garbage collector a cada 20 updates
local updates = tonumber(conky_parse("$updates" ))
if updates%20 == 0  then
	-- rodar GC
	collectgarbage('collect')
end


local loader = EventLoader:new(conf.server)
local idata = loader:getData(conf.source)
local data = {}
for user,tickets in pairs(idata) do
	local total = 0
	local done = 0 
	for ttype, count in pairs(tickets) do
		total = total + tonumber(count)
		if ( ttype == "Assigned" or ttype == "Closed" ) then
			done = done + count
		end
	end
	if total >0 then
		local tperc = math.floor((done/total)*100)
		data[#data+1] = { user = user, val = tperc }
	end
end

table.sort(data,compare)

local label = Label(conf)
local totalindex = 15

label.properties.grid.y = totalindex-1

for i=1, totalindex-1 do
	label:lineGraph(i-1,data[i].user,data[i].val);
end

label:destroy()
end
