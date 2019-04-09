package.path=package.path..";/usr/share/dashboard/lib/?.lua"
require('luarocks.loader')
require("lib.common")
--require('LuaVirt')
local ZabbixAPI = require("lib.api.ZabbixAPI")
local apr = require("apr")
cjson = require("cjson")

local ZabbixLoader = {}
local ZabbixLoader_mt = { __index = ZabbixLoader }

function ZabbixLoader:new(conf)
-- initialize memcache client
local mc = apr.memcache(1)
mc:add_server(conf.memcserver,11211);
-- initialize zabbix api client
local z = ZabbixAPI(conf.zserver,conf.zuser,conf.zpass)
--local allnodes = {}
return setmetatable({ mc = mc, z = z, conf = conf,}, ZabbixLoader_mt)
end

function ZabbixLoader:loop()
--while  true do
	print('zabbix loop')
	for i,group in pairs(self.conf.groups) do
		self:setData(group)
	end
	self:getIssues()
--end
end

function ZabbixLoader:registerTree()
-- first, register the plugin on the main data tree
local status, pdata = self.mc:get(self.conf.tree)

if ( status == nil or pdata == nil )then
-- nothing previously registered, we are first post :)
	local data = {}
	table.insert(data,self.conf.subtree)
	self.mc:set(self.conf.tree,cjson.encode(data),0)
else
	-- test if the plugin is already registered on the memcache
	-- server. If not, register it
	local newbranch = {}
	local found = false
	local data =  cjson.decode(pdata);
	for _,branch in pairs(data) do
		if branch == self.conf.subtree then
			found = true
		end
	end
	-- if we are already registered, do nothing
	if found == false then
		table.insert(data,self.conf.subtree)
		self.mc:set(self.conf.tree,cjson.encode(data),0)
	end
end

--[[ 
run through the configuration tree and set values for each source
and on the "root", set the json structure to guide while running the branch
--]]
local subtree = {}
local index = 1
for _,branch in pairs(self.conf.groups) do
	if subtree[branch.name] == nil then
		subtree[branch.name] = index
		index = index + 1
	end
end
-- invert the table
local nsubtree = {}
for i,v in pairs(subtree) do
	nsubtree[v] = i
end
-- add the special all nodes group, which contains, guess what, all nodes!
--nsubtree[#nsubtree+1] = self.conf.allnodes
-- add the special subtree for errors, the issues
nsubtree[#nsubtree+1] = self.conf.issuesbranch

self.mc:set(self.conf.tree .. self.conf.subtree,cjson.encode(nsubtree),0)
-- make only one concatenation of the tree name
self.subtree = self.conf.tree .. self.conf.subtree
end

function ZabbixLoader:setData(group)
	local namespacesL0 = {}
	local namespacesL1 = {}
	for namespace, itens in pairs(group.itens) do
		local  namespacesL2 = {}
		namespacesL0[#namespacesL0+1] = namespace
		for value,_ in pairs(itens) do
			namespacesL2[#namespacesL2+1] = value
		end
		namespacesL1[namespace] = namespacesL2
	end
	
	local allGroupNodes = {}
	local index = 1
	local pdata = {}
	for namespace, itens in pairs(group.itens) do
		local expand = false
		if group.macroexpand ~= nil then
			expand = group.macroexpand[namespace]
		end
		pdata = self.z:getGroupItem(group.name,itens,expand)
		allGroupNodes[index] = self:setItemData(group.name,namespace,pdata,namespacesL0,namespacesL1)
		index = index + 1
	end
	
	-- now, merge the allGroupNodes into a single, simpler table/array
	local flatNodeList = {}
	for _,groupNodes in pairs(allGroupNodes) do
		for nodename,_ in pairs(groupNodes) do
		flatNodeList[nodename] = 0
		end
	end
	local fnodeList = {}
	for i,v in pairs(flatNodeList) do
		fnodeList[#fnodeList+1] = i
	end
	self.mc:set(self.subtree..'.'.. group.name,cjson.encode(fnodeList),self.conf.age)
end

-- fuck trying to optimize code, we are doing it the dumb way!
-- PS: trying for 4 days to find a optimized way and the 
-- presentation layer is not working.
-- How this is dumb: we are passing the function all the possible data trees,
-- and as such, may as well be wrong. So the client must be smart
-- enougth to treat if a value does not exist and properly return null.
-- As of today, 2015-02-23, it is smart enought to do such, but is definetly not
-- an elegant solution. 

function ZabbixLoader:setItemData(groupname,namespace,pdata,namespaceL0,namespaceL1)
local groupNodes = {}
-- first, subtrees where the data will be put into

for sname,fsetdata in pairs(pdata) do
	for iftype,int in pairs(fsetdata) do
		--if namespace == "net" then
		--	int = int/10000000
		--end
		-- next line is the specific dumb line, as an already setted variable will be set
		self.mc:set(self.subtree..'.'..groupname.. '.' ..sname,cjson.encode(namespaceL0),self.conf.age)
		self.mc:set(self.subtree..'.'..groupname.. '.' ..sname.."."..namespace,cjson.encode(namespaceL1[namespace]),self.conf.age)
		self.mc:set(self.subtree..'.'..groupname.. '.' ..sname.."."..namespace.."."..iftype,int,self.conf.age)
		groupNodes[sname] = 0
	end
end
return groupNodes
end

-- function ZabbixLoader:setItemData(groupname,namespace,pdata)
-- local groupNodes = {}
-- for sname,fsetdata in pairs(pdata) do
-- 	for iftype,int in pairs(fsetdata) do
-- 		if namespace == "net" then
-- 			int = int/10000000
-- 		end
-- 		self.mc:set(self.subtree..'.'..groupname.. '.' ..sname.."."..namespace.."."..iftype,int,self.conf.age)
-- 		groupNodes[sname] = 0
-- 	end
-- end
-- return groupNodes
-- end



function ZabbixLoader:getIssues()
local issues = {}
local errordata = self.z:call("trigger.get", 
		{ 
			output = "extend", 
			-- group = self.conf.allhostsgroup,
			selectHosts = {'host', 'name', 'state', 'error', 'expression', 'description', 'priority', 'lastchange' },
			selectLastEvent = {'eventid', 'acknowledged', 'objectid', 'clock', 'ns'},
			withUnacknowledgedEvents = 1,
			sortfield = "lastchange",
			monitored = true,
			only_true = true,
			maintenance = false,
			limit = 200,
		}
	)

for i,item in pairs(errordata) do
	if tonumber(item["value"]) >= 1 then
		local newdata = {}
		newdata["title"] = item.hosts[1]["name"]
		newdata["priority"] = item["priority"]
		newdata["description"] = item["description"]:gsub("{HOST.NAME}",newdata["title"])
		newdata["host"] = item.hosts[1]["host"]
		newdata["ack"] = item["lastEvent"]["acknowledged"]
		issues[#issues+1] = newdata
	end
end
self.mc:set( self.conf.tree .. self.conf.subtree ..'.'.. self.conf.issuesbranch ,cjson.encode(issues),self.conf.age)
end


return ZabbixLoader
