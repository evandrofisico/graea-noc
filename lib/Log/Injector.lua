require('luarocks.loader')
require("lib.common")
--local apr = require("apr")
local cjson = require("cjson")
local haricot = require("haricot")
local Injector = {}
local plugins = {}
Injector.__index = Injector 

setmetatable(Injector, {
__call = function (cls, ...)
	return cls.new(cls,...)
end,
})

function Injector:new(conf)
local bs = haricot.new(conf.bstalkdserver, conf.bstalkdport)
return setmetatable({conf = conf, filters = {}, matchstr = {}, bs = bs, }, self)
end


function Injector:init()
return true
end

function Injector:addMatchFilters(matchtable)
for strfilter, callback in pairs(matchtable) do
	self.matchstr[#self.matchstr+1] = { 
		str = strfilter,
		callback = callback,
	}
end
end

function Injector:registerMatchCallBack(programstring)
	for str,callback in pairs(self.conf.matchFilters) do
		if programstring:find(str) then
		self.conf.filters[programstring] = callback
		end
	end
end


function Injector:putJob(tube,logTable)
	self.bs:use(tube)
	self.bs:put(0,0,7200000,cjson.encode(logTable))
end

function Injector:runFilters(logtable)
	local program = logtable.program
	local cachedata
	local messagedata
	if self.conf.filters[program] ~= nil then
		self:putJob(self.conf.filters[program],logtable)
	else
		self:registerMatchCallBack(program)
		if self.conf.filters[program] ~= nil then
			self:putJob(self.conf.filters[program],logtable)
		end
	end
end

return Injector
