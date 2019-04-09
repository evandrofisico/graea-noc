local apr = require('apr')
EventsLoader = {}
EventsLoader_mt = { __index = EventsLoader }


function EventsLoader:new()
	local mc = apr.memcache(1)
	mc:add_server('localhost',11211);
	return setmetatable({  mc = mc }, EventsLoader_mt)
end
-- normalmente, index_table e location
function EventsLoader:GetData(index_table,source,assets)
local return_data = {}
	for asset,_ in pairs(index_table) do
	local name = asset.."_"..assets
	-- buscando dados
	local status, pdata = self.mc:get('janus:'..name.."."..source)
		if status == nil then
			if type(source) == "number" then
			return_data[asset] = source
			end
		else
		return_data[asset] = pdata
		end
	end
return return_data
end


function EventsLoader:Return()
	return self.data
end


