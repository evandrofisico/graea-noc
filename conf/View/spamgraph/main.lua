-- path
package.path=package.path..";/usr/share/dashboard/lib/?.lua"
require('luarocks.loader')
require("common")
local cairo = require('cairo')
local colors = require("colors")
local Graph = require("view.Graph")
--local Graph = require("view.Graph")
local SpamStatLoader = require('data.SpamStatLoader')
theme = require('theme')
-- configuration files
local conf = require('conf')

function conky_start()
end

function conky_widgets()
loader = SpamStatLoader:new(conf)
local graph = Graph(conf)
local data = loader:getDataDays(15)
graph:drawData(data)
graph:drawLabel(data)
graph:drawTitle(conf.title)
--graph:destroy()
end
