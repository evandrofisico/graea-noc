-- lua dependencies
require('luarocks.loader')
require("lib.common")
local curl = require("cURL")
local cjson = require("cjson")



local OssimLoader = {}
local OssimLoader_mt = { __index = OssimLoader }

function OssimLoader:new(conf)
	return setmetatable({ conf = conf }, OssimLoader_mt)
end

function OssimLoader:registerTree()
	local returnData = {}
	--[[ 
	run through the configuration tree and set values for each source
	and on the "root", set the json structure to guide while running the branch
	--]]
	local subtree = {}
	local index = 1
	for _,branch in pairs(self.conf.DataSources) do
		if subtree[branch.source] == nil then
			subtree[branch.source] = index
			index = index + 1
		end
	end
	-- invert the table
	local nsubtree = {}
	for i,v in pairs(subtree) do
		nsubtree[v] = i
	end
	returnData[self.conf.tree .. self.conf.subtree] = cjson.encode(nsubtree)
	-- make only one concatenation of the tree name
	self.subtree = self.conf.tree .. self.conf.subtree
	return returnData
end


function OssimLoader:mkURL(source,ltype,id,user)
local urlbase = self.conf.server

if source == nil then
	return nil
else
	urlbase = urlbase..source..'_api.php?'
end

if ltype ~=nil then
	urlbase = urlbase..'&type='..ltype
end
if id ~=nil then
	urlbase = urlbase..'&id='..id
end
if user ~=nil then
	urlbase = urlbase..'&user='..user
end
return urlbase
end

function OssimLoader:setData(st)
local returnData = {}
local data = {};
local slist = {}
local surl = self:mkURL(st.source, st.ltype, st.id, st.user)
--print_r(surl)
local cr = curl.easy_init()
cr:setopt(curl.OPT_USERAGENT,"AV Report Scheduler")
cr:setopt(curl.OPT_HTTPGET,1)
cr:setopt(curl.OPT_SSL_VERIFYPEER,0)
cr:setopt(curl.OPT_SSL_VERIFYHOST,0)
--self.cr:setopt(curl.OPT_URL,surl)
--print(surl)
cr:setopt_url(surl)
--self.cr:setopt_url(surl)
cr:setopt_writefunction(
	function(s,len)
		table.insert(data,s)
		return true
	end

)
cr:perform()
cr:close()
--print_r(table.concat(data))
local sdata = cjson.decode(table.concat(data));
local flist = {}
	for nfield, value in pairs(sdata) do
		local field = nfield:gsub(' ','_')
		table.insert(flist,field)
			if type(value) == "table" then
				local fflist = {}
				for ffield,fvalue in pairs(value) do
					table.insert(fflist,ffield)
					returnData[self.subtree ..".".. st.source ..'.'.. st.name .."."..field.."."..ffield] = fvalue
				end
				returnData[self.subtree.. "." .. st.source ..'.'.. st.name .."."..field] = cjson.encode(fflist)
			else
				returnData[self.subtree.. "." .. st.source ..'.'.. st.name .."."..field] = cjson.encode(value)
			end
	end
	return flist, returnData
end


function OssimLoader:loop()
--while true do
	local returnData = {}
	print('Ossim loop')
	local indextable = {}
	for i,state in pairs(self.conf.DataSources) do
		local glist, pReturnData = self:setData(state)
		-- lista para encontrar segundo nivel
		returnData[self.subtree.. "." .. state.source .. '.'.. state.name] =  cjson.encode(glist)
	
		-- lista para encontrar primeiro nivel
		if indextable[state.source] == nil then
			indextable[state.source] = {}
		end
		table.insert(indextable[state.source],state.name)

		-- add first level data to the return array
		for key, value in pairs(pReturnData) do
			returnData[key] = value
		end
	end
	
	for source,dlist in pairs(indextable) do
		returnData[self.subtree.. ".".. source] = cjson.encode(dlist)
	end
	return returnData
end

return OssimLoader 
