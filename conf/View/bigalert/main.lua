-- path
package.path=package.path..";/usr/share/dashboard/lib/?.lua"
-- lua dependencies
require('luarocks.loader')
cairo = require('cairo')
require('api.mpd')
apr = require("apr")
-- script sources
require("common")
local BigMessage = require("view.BigMessage")
-- configuration files
theme = require('theme')
dofile("conf.lua")
dofile("EventLoader.lua")

function conky_startup()
cl = NagEventsLoader:new()
cl:CleanData()
m = mpd.connect()
draw = false
frame_counter = 0
eventHolder = {}
end


function conky_widgets()
--	-- forcar garbage collector a cada 20 updates
local updates = tonumber(conky_parse("$updates" ))
if updates%20 == 0  then
	-- rodar GC
	collectgarbage('collect')
end

local event = cl:GetData()
if event ~= nil then
	-- iniciar musica
        if (frame_counter<2*prop.fade_frames + prop.showmsg_frames) then
		if (frame_counter == 0 and event.type ~= nil ) then
			m:clear()
			m:load(event.type)
			if event.read == 1 then
				local txtargs = apr.uri_encode(event.title..";"..event.text)
				m:add("http://translate.google.com/translate_tts?tl=pt&ie=iso8859-1&q="..txtargs)
				-- gambiarra mega ultra plus pra ler texto
			end
			m:play(0)
		end
		conky_set_update_interval(1/prop.fps)
		local le = BigMessage(prop)
		le:DrawEvent(event,frame_counter)
		le:destroy()
		--apr.sleep(30)
		frame_counter = frame_counter + 1
	else
		conky_set_update_interval(prop.update_interval)
		frame_counter = 0 
		cl:CleanData()
		--m:clear()
	end
end
end
