-- path
package.path=package.path..";/usr/share/dashboard/lib/?.lua"
require('luarocks.loader')
require("common")
local cairo = require('cairo')
local colors = require("colors")
local Label = require("view.Label")
local EventLoader = require("data.EventLoader")
-- configuration files
theme = require('theme')
dofile("/usr/share/dashboard/share/ISO_3166-1.lua")
local conf = require("conf")

function compare(a,b)
        if a.attacks > b.attacks then
                return true
        end
end

function conky_init()
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
local total = 0

for country,attacks in pairs(idata) do
        data[#data+1] = { country = country , attacks = tonumber(attacks) }
	total = total + tonumber(attacks)
end
-- reordenando a tabela
table.sort(data,compare)


-- order by number of attacks
local label = Label(conf)

for index=1,conf.grid.y do
	if data[index].attacks ~= nil then
		local atkperc = (data[index]['attacks']/total)*100
		label:imageGraph(index-1,
			iso_3166_1_table[data[index]['country']],
			data[index]['attacks'],atkperc,conf.flagpath..data[index]['country']..".png")
	end
end
label:destroy()
end
