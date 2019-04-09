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
conf = require("conf")

function conky_start()
end

function conky_widgets()

local loader = EventLoader:new(conf.server)
local data = loader:getData(conf.source)
local filterdata = {}
local itemcount=0
local totalshown=0
for username,mails in pairs(data) do
	itemcount = itemcount+1
	totalshown = totalshown+tonumber(mails)
end

-- now, generate a color for each mailer
--theme.stateToRGB(state)
for username,mails in pairs(data) do
	local userstate = 100*(tonumber(mails)/totalshown)
	conf.bg[username] = theme.r_g_b_to_rgb( theme.stateToRGB(userstate) )
end


local listitem = ListItem(conf)
listitem:drawLabel(itemcount,data,true)
listitem:destroy()
end
