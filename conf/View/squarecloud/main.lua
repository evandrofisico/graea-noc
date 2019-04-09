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

function cloudFilter(slist,sotype)
local cluster_data = {}
local index = 1
for node,statdata in pairs(slist) do
        --print_r(statdata)
        local ndata0 = {}
        -- flatten the table to one dimension
        if sotype == 'unix' then
                if statdata ~= nil then
                        if statdata.cpu ~= nil then 
				ndata0.cpu = statdata.cpu.idle 
                        	ndata0.cpuload = statdata.cpu.load 
			else
                        	ndata0.cpuload = 0
			end
                        if statdata.mem ~= nil then ndata0.mem = statdata.mem.free end
                        if statdata.disk ~= nil then
                                ndata0.data =  statdata.disk.data or nil
                                ndata0.root =  statdata.disk.root or nil
                                ndata0.pgxlog =  statdata.disk.pg_xlog or nil
                                ndata0.wal =  statdata.disk.wal or nil
                        end
                end
        end
        if sotype == 'win' then
                if statdata ~= nil then
                        if statdata.cpu ~= nil then ndata0.cpu = 100-statdata.cpu.system end
                        if statdata.cpu ~= nil then ndata0.cpuload = statdata.cpu.load end
                        if statdata.mem ~= nil then ndata0.mem = statdata.mem.free end
                        if statdata.disk ~= nil then
                                ndata0.C =  statdata.disk.C or nil
                                ndata0.D =  statdata.disk.D or nil
                                ndata0.E =  statdata.disk.E or nil
                                ndata0.F =  statdata.disk.F or nil
                        end
                end
        end
        cluster_data[index] = {
                                data = ndata0,
                                node = node,
        }
        index = index + 1
end
table.sort(cluster_data,ordRes)
return cluster_data
end


--layout = {}
--currPage = 0
--maxPages = 0

function conky_init()
end

function conky_widgets()

function ordRes(a,b)
        return a.data.cpuload > b.data.cpuload
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

local cloud = SquareCloud(conf)

local allvm = loader:getData(conf.datasource.virtuais)
local cluster_data = cloudFilter(allvm,'unix')


local maxvm=conf.grid.x*conf.grid.y
for i=0,maxvm+1 do 
	--print(cluster_data[i+1].node)
        cloud:drawData(i,cluster_data[i+1].data,cluster_data[i+1].node)
end


cloud:drawLabels(conf.labelmap)
cloud:destroy()
end
