local luasql = require('luasql.sqlite3')
local DBLoader = {}
local DBLoader_mt = { __index = DBLoader }

function DBLoader:new(conf)
local db = assert (luasql.sqlite3())
local con = db:connect(conf.dbpath)
return setmetatable({ db = db, con = con, }, DBLoader_mt)
end


function DBLoader:getData(count)
	local data = {}
	local index = 0;
	local cursor = self.con:execute("select * from events order by id desc limit "..count.." ;")
	data[index] = {}
	while cursor:fetch (data[index], "a") do
		index = index + 1
		data[index] = {}
	end
	cursor:close()
	self.con:close()
	self.db:close()
	-- fazer cache do resultdo da query para durante animacao
	return data
end

function DBLoader:setShown(id)
	local cursor = self.con:execute("update events set shown=1 where id="..id.." ;")
end

function DBLoader:getUnshown()
	local data = {}
	local index = 0;
	local cursor = self.con:execute("select count(*) from events where shown!=1;")
	cursor:fetch (data, "a")
	cursor:close()
	self.con:close()
	self.db:close()
	return data["count(*)"]
end

return DBLoader
