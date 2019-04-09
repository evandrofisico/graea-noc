
package.path=package.path..";/home/evandro.rodrigues/graea/?.lua;".."/home/evandro.rodrigues/graea/?/init.lua"
require('luarocks.loader')
require("lib.common")
local haricot = require("haricot")
local cjson = require("cjson")
local posix = require("posix")
local proctitle = require('proctitle')


local Consumer = {}
local plugins = {}
Consumer.__index = Consumer 

setmetatable(Consumer, {
__call = function (cls, ...)
	return cls.new(cls,...)
end,
})

function Consumer:new(conf)
return setmetatable({conf = conf, plugins = {} }, self)
end


function Consumer:init()
for _,plg in pairs(self.conf.plugins) do
	local pluginObj = require('lib.NLog.' .. plg)
	local pluginconf = require('conf.NLog.' .. plg .. 'Conf')
	self.plugins[plg] = pluginObj:new(pluginconf)
	self.plugins[plg]:registerTree()
	self.plugins[plg]:createTable()
end
end

function Consumer:Daemonize()
-- get the user to lower priviledge to
local pwd = require "posix.pwd"
local signal = require "posix.signal"
local pid = posix.fork()
    if pid < 0 then
    	print ("Initial fork failed")
    elseif pid > 0 then
		local uid = pwd.getpwuid(self.conf.runAsUser)
		posix.setpid("u", uid)
		posix.setpid("s")
		-- signal handler
		signal.signal(signal.SIGQUIT, self:hangleSig("quit"))
		signal.signal(signal.SIGHUP, self:hangleSig("reload"))
	end
end

-- signal handling should be implemented in the instantiated 
-- object, as we do little to no control flow down here.
-- Overload it in the main program
function Consumer:handleSig(signal)
end


function Consumer:runFilters()
local pid
--print ("parent: my pid is: " .. posix.getpid ("pid"))
proctitle("Consumer                       ")
for tube,pluginObj in pairs(self.plugins) do
	--print_r(arg)
	--arg[-1] = "Plugin "
	--arg[0] = tube
	pid = posix.fork ()
	if pid == -1 then
		print ("The fork failed.")
	elseif pid == 0 then
		-- simple log consumer
		local bs = haricot.new(self.conf.bstalkdserver, self.conf.bstalkdport)
		print ("thread do plugin " .. tube .. " " .. posix.getpid("pid") )
		proctitle("Consumer: "..tube.."           ")
		bs:watch(tube)
		while true do
			--bs:watch(tube)
			local ok, job = bs:reserve()
			assert(ok, job)
			local id, data = job.id, job.data
			local dataTable = cjson.decode(job.data)
			--print(dataTable["program"])
			pluginObj:runCallBack(dataTable)
			bs:delete(job.id)
		end
	end
end
posix.wait()
end

return Consumer
