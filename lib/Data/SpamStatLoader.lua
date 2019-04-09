local luasql = require('luasql.sqlite3')
local SpamStatLoader = {}
local SpamStatLoader_mt = { __index = SpamStatLoader }

function SpamStatLoader:new(conf)
local db = assert (luasql.sqlite3())
local con = db:connect(conf.dbpath)
return setmetatable({ db = db, con = con, }, SpamStatLoader_mt)
end

function SpamStatLoader:getDataDays(days)
	local data = {}
	local index = 0;
	--local query = [[ 
	--		select p.date,p.total,p.rejected,a.spam,a.banned,d.failed,d.nosig,d.badsig 
	--		from postfix as p, amavis as a, dkim as d  
	--		where strftime('%s',p.date) > strftime('%s','now','-DAYS day','localtime') and 
	--		p.date like '%23:50:%' and a.id=p.id and p.id=d.id;
	--		]]
	local query = [[ 
			select p.date,p.total,p.rejected,a.spam,a.banned 
			from postfix as p, amavis as a
			where strftime('%s',p.date) > strftime('%s','now','-DAYS day','localtime') and 
			p.date like '%23:50:%' and a.id=p.id;
			]]
	local cursor = self.con:execute(query:gsub("DAYS",days+1))
	while cursor:fetch (data[#data], "a") do
		data[#data+1] = {}
	end
	data[#data] = nil
	--while cursor:fetch (data[index], "a") do
	--	index = index + 1
	--	data[index] = {}
	--end
	self.db:close()
	-- fazer cache do resultdo da query para durante animacao
	return data
end


function SpamStatLoader:getDataHour()
	local data = {}
	local index = 0;
	--local query = "select * from postfix where strftime('%s',date) > strftime('%s','now','-7 day','localtime') and date like '%23:50:%';"
	local query = [[ 
			select p.id, p.total-(p.rejected+a.spam+a.banned) as not_spam,
			p.rejected,a.spam,a.banned,d.failed,d.nosig,d.badsig 
			from postfix as p, amavis as a, dkim as d  where  a.id=p.id and p.id=d.id order by p.id desc limit 2;
			]]
	--[[ 
			select p.id,d.success+a.clean as not_spam,p.rejected,a.spam,a.banned,d.failed,d.nosig,d.badsig 
			from postfix as p, amavis as a, dkim as d  where  a.id=p.id and p.id=d.id order by p.id desc limit 2;
			--]]
	local cursor = self.con:execute(query)
	data[1] = {}
	while cursor:fetch (data[#data], "a") do
		data[#data+1] = {}
	end
	local returndata = {}
	for name,value in pairs(data[1]) do
		--print(name,value)
		returndata[name] = data[1][name] - data[2][name];
	end
	returndata["id"] = nil
	self.db:close()
	-- fazer cache do resultdo da query para durante animacao
	return returndata
end



return SpamStatLoader
