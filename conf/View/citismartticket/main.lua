-- path
package.path=package.path..";/usr/share/dashboard/lib/?.lua"
require('luarocks.loader')
require("common")
local EventLoader = require('data.EventLoader')
local cairo = require('cairo')
local colors= require("colors")
local Label = require("view.Label")
theme = require('theme')
-- configuration files
local conf = require('conf')

function conky_init()
print("iniciando")
eventtype = {
		["0"] = "Unclassified",
		["1"] = "Info",
		["2"] = "Warn",
		["3"] = "Avg",
		["4"] = "High", 	     
		["5"] = "Disaster",
		}

print("fim do init")
end



function conky_widgets()

local function ord(a,b) return a.timeleft < b.timeleft end

local apr = require('apr')
--	-- forcar garbage collector a cada 20 updates
local updates = tonumber(conky_parse("$updates" ))
if updates%20 == 0  then
	-- rodar GC
	collectgarbage('collect')
end

local loader =  EventLoader:new(conf.server)
local data = loader:getData(conf.source)

local label = Label(conf)
local epochtime = apr.time_now()
--print_r(data)
--print(epochtime)
--local index = 0
-- create new table with summarized data and relative 
-- priority based on how out of SLA time are the tickets
local newtickets = {}
for _,ticket in pairs(data) do
	if ticket.abertura ~= nil then
	local ntic = {}
		local ticketenddate = tonumber(ticket.abertura)+tonumber(ticket.prazosegundos)
		if ticketenddate < epochtime then
			-- expired, no time left
			ntic.timeleft = 0
		else
			-- get percentage of time left
			local tleft = ticketenddate-epochtime
			ntic.timeleft = (tleft/ticket.prazosegundos)*100
		end
	if ticket.responsavel ~= nil then 
		ntic.title = "Ticket "..ticket.id.." - OK"
		--ntic.title = "Ticket "..ticket.id.." - "..ticket.responsavel
	else
		ntic.title = "Ticket "..ticket.id
	end

	ntic.description=ticket.solicitante
	table.insert(newtickets,ntic)
	end
end

table.sort(newtickets,ord)

--print_r(newtickets)


for index,sdata in pairs(newtickets) do
	label:textWidget(index-1,sdata.title,sdata.description,100-sdata.timeleft)
	index = index+1
end
label:destroy()
end
