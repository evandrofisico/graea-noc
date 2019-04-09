require('luarocks.loader')
require("lib.common")
local cjson = require("cjson")
local luasql = require('luasql.postgres')

local CitiSmartSet = {}
local CitiSmartSet_mt = { __index = CitiSmartSet }

function CitiSmartSet:new(conf)
local db = assert (luasql.postgres())
local con = db:connect(
			conf.dbname,
			conf.dbuser,
			conf.dbpass,
			conf.dbserver
			)
return setmetatable({ db = db, con = con, conf= conf }, CitiSmartSet_mt)
end

function CitiSmartSet:registerTree()
	local returnData = {}
	self.subtree = self.conf.tree .. self.conf.subtree
	-- register each of the ticket groups as a sub-sub-tree
	local subsubtree = {}
	for branch,_ in pairs(self.conf.groups) do
		subsubtree[#subsubtree+1] = branch
	end
	--print(self.subtree,cjson.encode(subsubtree),0)
	returnData[self.subtree] = cjson.encode(subsubtree)
	return returnData
end


function CitiSmartSet:getData(group)
local query = string.format(self.conf.query,group)
local cursor = self.con:execute(query)
local index = 1
local data = {}

data[index] = {}
while cursor:fetch (data[index], "a") do
	index = index + 1
	data[index] = {}
end
return data
end

function CitiSmartSet:setDataTickets()
end


function CitiSmartSet:loop()
	local returnData = {}
	for groupname,id in pairs(self.conf.groups) do
		local grouptickets = self:getData(id)
		returnData[self.subtree .. ".".. groupname] = cjson.encode(grouptickets)
	end
	return returnData
end


return CitiSmartSet
