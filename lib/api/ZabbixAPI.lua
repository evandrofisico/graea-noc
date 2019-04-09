require('luarocks.loader')
local curl = require("cURL")
local ZabbixAPI = { }
local cjson = require('cjson')

setmetatable(ZabbixAPI, {
__call = function (cls, ...)
	return cls.create(cls,...)
end,
})

function ZabbixAPI:create(host,user,pass)
	local p = {}
	p.cr = curl.easy_init()
	p.host = host
	p.user = user
	p.pass = pass
	self.__index = self
	self.__call = function (cls, ...)
		return cls.new(cls,...)
	end
	return setmetatable(p, self)
end

function ZabbixAPI:login()
local req = {
	jsonrpc = "2.0",
	method = "user.login",
	params = {
		user = self.user, 
		password = self.pass, 
	},
	id = 1,
}
local ldata = self:sendRequest(req)
self.authkey =  ldata["result"]
end

function ZabbixAPI:call(method,params)
	-- if no authkey has been set, do login
	if self.authkey == nil then
		self:login()
	end
	local req = {
		jsonrpc = "2.0",
		method = method,
		params = params,
		id = 1,
		auth = self.authkey,
	}
	return self:sendRequest(req)["result"]
end

function ZabbixAPI:sendRequest(req)
	local data = {}
	local cr = curl.easy_init()
	local url = self.host..'/api_jsonrpc.php'
	local jsonreq = cjson.encode(req)
	cr:setopt(curl.OPT_URL,url)
	cr:setopt(curl.OPT_POST,1)
	cr:setopt_writefunction(
		function(s,len)
        		table.insert(data,s)
        		return true
		end

	)
	cr:setopt(curl.OPT_HTTPHEADER,{ "Content-Type: application/json"})
	cr:setopt(curl.OPT_POSTFIELDS, jsonreq )
	cr:perform()
	--print_r(jsonreq)
	local jsonresp = cjson.decode(table.concat(data));
	cr:close()
	--print_r(jsonresp)
	return jsonresp
end

function ZabbixAPI:getHostItem(hostname,itemtable)
local rthst = self:call("host.get", { output = "extend",  selectMacros = "extend" , filter = {host = { hostname, }}, })
--print_r(rthst)
local data = {}
for name,key in pairs(itemtable) do
	local idata = self:call("item.get", { output = "extend", hostids  = rthst[1]["hostid"] ,  search = { key_ = key  }})
	data[name] = idata[1]["lastvalue"]
end
return data
end



-- inicio de funcoes especificas para tv na conab
--[[
-- Comentado em 2015-09-14: nova implementacao abaixo
function ZabbixAPI:getGroupItem(groupname,itemtable)
local rtgrp = self:call("hostgroup.get", { output = "extend", filter = {name = { groupname, }}})
local items = {}
	for name,key in pairs(itemtable) do
		items[name] = self:call("item.get", { output = "extend", groupids  = rtgrp[1]["groupid"] ,  search = { key_ = key  }})
	end
-- put together host ids and items ids
local rthst = self:call("host.get", { output = "extend", groupids = rtgrp[1]["groupid"], })
local data = {}
for name, itemdata in pairs(items) do
	for _,host in pairs(rthst) do
	if data[ host["host"] ] == nil then
		data[host["host"] ] = {}
	end
		for i,k in pairs(itemdata) do
			if (host["hostid"] == k["hostid"]) then
			data[ host["host"] ][name] = k["lastvalue"]
			end
		end
	end
end
return data
end
--]]

function ZabbixAPI:getGroupItem(groupname,itemtable,macroexpand)
local rtgrp = self:call("hostgroup.get", { output = "extend", selectMacros = "extend", filter = {name = { groupname, }}})

-- if we are to expand macros, this block is necessary (and slow)
if macroexpand then
	local data = {}
	local hostlist = self:call("host.get", { output = "extend",  selectMacros = "extend" , groupids =  rtgrp[1]["groupid"], })
	for _,host in pairs(hostlist) do
		local hostdata = {}
		for itemname, itemvalue in pairs(itemtable) do
			for _,macro in pairs(host["macros"]) do
				if string.find(itemvalue,macro["macro"]) ~= nil then
					--print(itemvalue,macro["macro"])
					local key = itemvalue:gsub(macro["macro"],macro["value"])
					local vtable = self:call("item.get", 
						{ output = "extend", hostids  = host["hostid"] ,  search = { key_ = key  }})
					if vtable[1] ~= nil then
						hostdata[itemname] = vtable[1]["lastvalue"]
					end
				end
			end
		end
	data[ host["host"] ] = hostdata
	end
	return data
end

local items = {}
for name,key in pairs(itemtable) do
	items[name] = self:call("item.get", { output = "extend", groupids  = rtgrp[1]["groupid"] ,  search = { key_ = key  }})
end
-- put together host ids and items ids
local rthst = self:call("host.get", { output = "extend", groupids = rtgrp[1]["groupid"], })
local data = {}
for name, itemdata in pairs(items) do
	for _,host in pairs(rthst) do
	if data[host["host"]] == nil then
		data[host["host"]] = {}
	end
		for i,k in pairs(itemdata) do
			if (host["hostid"] == k["hostid"]) then
			data[host["host"]][name] = k["lastvalue"]
			end
		end
	end
end
return data
end



function ZabbixAPI:getGroupHosts(groupname)
local rtgrp = self:call("hostgroup.get", { output = "extend", filter = {name = { groupname, }}})
return self:call("host.get", { output = "extend", groupids = rtgrp[1]["groupid"], })
end


return ZabbixAPI
