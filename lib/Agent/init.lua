require('luarocks.loader')
require("lib.common")
local ev = require('ev')
local Enyo = { }
local apr = require("apr")
local cjson = require("cjson")

setmetatable(Enyo, {
__call = function (cls, ...)
	return cls.new(cls,...)
end,
})

function Enyo:new(conf)
	local p = {}
	local mc = apr.memcache(1)
	mc:add_server(conf.memcserver,11211);
	p.mc = mc
	p.conf = conf
	p.Tree = {}
	p.TreeData = {}
	self.__index = self
	self.__call = function (cls, ...)
		return cls.new(cls,...)
	end
	return setmetatable(p, self)
end

function Enyo:registerTree(namespace,treedata)
	if (self.Tree[namespace] ~= nil) then
		return true
	else
		self.Tree[#self.Tree+1] = namespace 
		-- add the tree data to our 
		for key,value in pairs(treedata) do
			self.TreeData[namespace] = value
		end
	end
end

function Enyo:commitTree()
	local status, pdata = self.mc:get(self.conf.tree)
	if ( status == nil or pdata == nil )then
		self.mc:set(self.conf.tree, cjson.encode(self.Tree),0)
	else
	        local data = cjson.decode(pdata);
		for _, plugintree in pairs(self.Tree) do
	        	-- test if the plugin is already registered on the memcache
	        	-- server. If not, register it
	        	local found = false
	        	for _,branch in pairs(data) do
	        	        if branch == plugintree then
	        	                found = true
	        	        end
	        	end
	        	-- if we not registered, do it
	        	if found == false then
	        	        table.insert(data,plugintree)
	        	end
		end
		self.mc:set(self.conf.tree,cjson.encode(data),0)
	end

	for index,value in pairs(self.TreeData) do
		self.mc:set(self.conf.tree .. index ,value,0)
	end
end

function Enyo:init()
	local threads = {}
	local plugins = {}
	for _,plg in pairs(self.conf.plugins) do
		local pluginObj = require('lib.Agent.' .. plg )
		local pluginconf = require('conf.Agent.' .. plg .. "Conf" )
		plugins[plg] = pluginObj:new(pluginconf)
		-- print(pluginconf.tree .. pluginconf.subtree)
		self:registerTree(pluginconf.subtree, plugins[plg]:registerTree())
	end
	self:commitTree()
	for _,plg in pairs(self.conf.plugins) do
		print('registrando ',plg)

		threads[plg] = ev.Timer.new(
			function (loopcount,timer_event)
				print("running ",plg)
				local cachedata, message = plugins[plg]:loop()
				self:setCache(cachedata,0)
				print("-------------",plg)
				-- print_r(cachedata)
				--self:setMessage(message)
			end
		,plugins[plg].conf.period*math.random(),
		plugins[plg].conf.period)
	end
	self.threads = threads
end

function Enyo:Loop()
	for plugin,thread in pairs(self.threads) do
		thread:start(ev.Loop.default)
	end
	ev.Loop.default:loop()
end

--- Set data returned from the plugin loop function into the main cache.
-- set data returned from the plugin loop function into the main cache.
-- @cachedata table using keys as the data path on the cache a
-- @ttl the plugin specified expiration time of the data
-- @see setMessage
function Enyo:setCache(cachedata,ttl)
	for keys,values in pairs(cachedata) do
		--print(keys,values,ttl)
		self.mc:set(keys,values,ttl)
	end
end

return Enyo
