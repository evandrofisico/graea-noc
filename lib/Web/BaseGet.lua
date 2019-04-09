require('luarocks.loader')
require("lib.common")
local apr = require("apr")
local cjson = require("cjson")
--local EventLoader = require('lib.common.data.EventLoader')
local EventLoader = require('lib.common.data.EventLoader')

local printTable = function (table)
  for k, v in pairs(table) do
    print(k, '=', v)
  end
end



BaseGet = {}
BaseGet.__index = BaseGet

setmetatable(BaseGet, {
__call = function (cls, ...)
	return cls.new(cls,...)
end,
})

function BaseGet:new(conf)
-- to signal the loader program how to load the plugins callbacks
conf.callback = false
conf.matchback = false
return setmetatable({ conf = conf, db = db, con = con, mc = mc }, self)
end

-- only plugins with write access should be capable of registring
-- a tree
function BaseGet:registerTree()
print("ae!")
return true
end

function BaseGet:returnHTML(data,path,requeststr)
local returndata = "<html><body>"
local dirurl = '<br/><a href="'.. path ..'/%s?'.. requeststr ..'" >%s</a>'
local dirurl = dirurl:gsub('//','/')
local datahtml = '<br/><div>%s</div>'
--local datavalue = '<div>%s</div>'
-- no need to do a recursive function, as our current data model
-- has either tables or plain values on each level, no mixing.
if type(data) == "table" then
	for i,v in pairs(data) do
		returndata = returndata .. dirurl:format(v,v)
	end
else
	returndata = returndata .. datahtml:format(data)
end

returndata = returndata .. "</body></html>"
return returndata
end

-- plugins with read only access should register that they are serving a path 
function BaseGet:registerPath()
print("registrando")
local filters = {
	["data"] = function (req,rep)
	--local pathp = {req["_path"]:match((req["_path"]:gsub("/[^/]*", "/([^/]*)")))}
	local cachepath = req["_path"]:gsub("/data/","data:"):gsub("/", ".")
	local getparams = req:params()
	print_r(req)
	local data
	local output
	--printTable(req["querystring"])
	--printTable(req["_query_string"])
	local loader = EventLoader(self.conf.server)
	if getparams["recursive"] == "true" then
		data = loader:getData(cachepath,false)
	else
		data = loader:getData(cachepath,true)
	end

	if getparams["format"] == "html" then
		output = self:returnHTML(data,req["_path"],req["_query_string"])
	else
		output = cjson.encode(data)
	end

	rep:write(output)
	
	end,
}
return filters
end

return BaseGet
