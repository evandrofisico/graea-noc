-- module loading
package.path=package.path..";/usr/share/dashboard/lib/?.lua"
require("lib.common")
local loader = require('luarocks.loader')
local WeatherAPI = require("lib.api.WeatherAPI")
cjson = require("cjson")

local WeatherLoader = {}
local WeatherLoader_mt = { __index = WeatherLoader }

function WeatherLoader:new(conf)
-- initialize memcache client
-- initialize zabbix api client
local w = WeatherAPI:new(conf)
--local allnodes = {}
return setmetatable({ w = w, conf = conf,}, WeatherLoader_mt)
end

function WeatherLoader:loop()
	print('weather loop')
	local data = self.w:getData()
	local cachedata = {}
	local message = nil
	cachedata[self.conf.tree .. self.conf.subtree .. '.temp']	=	data.main.temp-273.15
	cachedata[self.conf.tree .. self.conf.subtree .. '.humidity']	=	data.main.humidity
	cachedata[self.conf.tree .. self.conf.subtree .. '.iconcode']	=	data.weather[1].id
	cachedata[self.conf.tree .. self.conf.subtree .. '.sunrise']	=	data.sys.sunrise
	cachedata[self.conf.tree .. self.conf.subtree .. '.sunset']	=	data.sys.sunset
	return cachedata
--end
end

function WeatherLoader:registerTree()
-- first, register the plugin on the main data tree
-- register our (few) branches on the tree
local returnData = {}
local branches = {
	'temp',
	'humidity',
	'iconcode',
	'sunrise',
	'sunset',
}
returnData[self.conf.tree .. self.conf.subtree] = cjson.encode(branches)
return returnData
end

return WeatherLoader
