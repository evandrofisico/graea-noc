-- lua dependencies
require('luarocks.loader')
curl = require("cURL")
require("lib.common")
local cjson = require("cjson")
local BaculawebLoader = {}
local BaculawebLoader_mt = { __index = BaculawebLoader }

function BaculawebLoader:new(conf)
	return setmetatable({ conf = conf}, BaculawebLoader_mt)
end

function BaculawebLoader:registerTree()
	local returnData = {}
	local subtree = {'jobs', 'volumes', 'pool', 'catalog', }
	returnData[self.conf.tree .. self.conf.subtree] = cjson.encode(subtree)
	-- make only one concatenation of the tree name
	self.subtree = self.conf.tree .. self.conf.subtree
	return returnData
end

function BaculawebLoader:loop()
	local returnData = {}
	local sources = {"jobs", "pool", "volumes", "catalog", }
	for _,source in pairs(sources) do
		local pdata = self:setData(source)
		local dataset = {}
		for dataitem, value in pairs(pdata) do
			returnData[self.subtree..'.'..source..'.'..dataitem] = value
			table.insert(dataset,dataitem)
		end
		returnData[self.subtree..'.'..source] = cjson.encode(dataset)
	end
	return returnData, nil
end

function BaculawebLoader:setData(dtype)
	local data = {};
	local url = self.conf.server..dtype
	local cr = curl.easy_init()
	cr:setopt_url(url)
	--cr:setopt_url(cr:escape(url))
	cr:setopt_writefunction(
		function(s,len)
        		table.insert(data,s)
        		return true
		end
	)
	cr:perform()
	cr:close()
	return cjson.decode(table.concat(data));
end
return BaculawebLoader
