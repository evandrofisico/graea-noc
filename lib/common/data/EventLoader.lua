require('luarocks.loader')
local apr = require('apr')
local cjson = require('cjson')



local EventLoader = {}
local EventLoader_mt = { __index = EventLoader }

setmetatable(EventLoader, {
__call = function (cls, ...)
	return cls.new(cls,...)
end,
})

function EventLoader:new(server)
	local mc = apr.memcache(1)
	mc:add_server(server,11211);
	return setmetatable({ mc = mc}, EventLoader_mt)
end

function EventLoader:getData(source,flat)
local return_data = {}
local status, pdata = self.mc:get(source)
	if ( status == nil or pdata == nil )then
		return nil
	else
		local data =  cjson.decode(pdata);
		-- a partir de data, pegar cada tipo de dado
		--print(type(data))
		if (type(data) == "table" and flat ~= true )then
			for _,item in pairs(data) do
				--print(_,item)
				--print(type(item))
				if type(item) == 'table' then
					return data
				end
				local ndata = self:getData(source.."."..item, flat)
				--print(ndata)
				--sometimes we would like to store json data directly on a branch, so...
				if ndata == nil then
					return_data[#return_data+1] = item
					--return data
				else
					return_data[item] = ndata
				end
				--print(_,item)
				--status, return_data[item] = self.mc:get('janus:'..source.."."..item)
			end
			return return_data
		else
			return data
		end
	end
end

return EventLoader
