package.path=package.path..";/usr/share/dashboard/lib/?.lua"
require('luarocks.loader')
require("lib.common")
local pegasus = require('pegasus')

local plugins = {}

local Deino = { }
Deino.__index = Deino

setmetatable(Deino, {
__call = function (cls, ...)
	return cls.new(cls,...)
end,
})

function Deino:new(conf)
local p = {}
p.conf = conf
self.__call = function (cls, ...)
	return cls.new(cls,...)
end
p.server = pegasus:new({
	port=conf.http_port,
})
p.paths = {}
return setmetatable(p, self)
end

-- register plugins methods and paths
function Deino:init()
--print_r(self.conf.plugins)
for _,plg in pairs(self.conf.plugins) do
	local pluginObj = require('lib.Deino.' .. plg)
	local pluginconf = require('conf.Deino.' .. plg )
	plugins[plg] = pluginObj:new(pluginconf)
	--print_r(plugins[plg])
	
	if plugins[plg].registerTree ~= nil then
		plugins[plg]:registerTree()
	end

	if plugins[plg].createTable ~= nil then
		plugins[plg]:createTable()
	end

	print('pre registrando')
	if plugins[plg].registerPath ~= nil then
		print('pos registrando')
		self:addPaths(plugins[plg]:registerPath())
	end

	if plugins[plg].conf.callback then
		self:addFilters(plugins[plg]:registerCallBack())
	end

	if plugins[plg].conf.matchback then
		self:addMatchFilters(plugins[plg]:registerMatchCallback())
	end
end
end

function Deino:addPaths(pathtable)
for name, callback in pairs(pathtable) do
	self.paths[name] = callback
end
end


function Deino:authUser(user,pass)
-- initialy, we are only using a local database for access, and as such,
-- this method is going to be as simple as I can do (initialy, as I intend to support at least LDAP authentication)
end


function Deino:processRequest(req,rep)
	local program = req.method
	if self.workers[program] ~= nil then
		self.workers[program](req,rep)
	end
end

function Deino:run()
self.server:start(function (req,rep)
	local pathp = {req["_path"]:match((req["_path"]:gsub("/[^/]*", "/([^/]*)")))}
	-- we only handle here the first part of the path
	local context = pathp[1]
	--print_r(self)
	if self.paths[context] ~= nil then
		self.paths[context](req,rep)
	end
	end
) 
end

return Deino
