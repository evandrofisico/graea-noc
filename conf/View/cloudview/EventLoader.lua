EventsLoader = {}
EventsLoader_mt = { __index = EventsLoader }

function EventsLoader:new()
	mc = apr.memcache(1)
	mc:add_server('localhost',11211);
	return setmetatable({ mc = mc}, EventsLoader_mt)
end

function EventsLoader:GetData(source)
local return_data = {}
local status, pdata = self.mc:get('data:'..source)
	if status == nil then
		return nil
	else
		local data =  cjson.decode(pdata);
		-- a partir de data, pegar cada tipo de dado
		if type(data) == "table" then
			for _,item in pairs(data) do
				status, return_data[item] = self.mc:get('data:'..source.."."..item)
			end
		end
	end
return return_data
end

function EventsLoader:GetDataItem(source)
local return_data = {}
local status, pdata = self.mc:get('data:'..source)
	if ( status == nil or pdata == nil ) then
		return nil
	else
		local data =  cjson.decode(pdata);
		-- a partir de data, pegar cada tipo de dado
		return data
	end
end
