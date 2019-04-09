-- module loading
package.path=package.path..";/usr/share/hecate-dash/?.lua;".."/usr/share/hecate-dash/?/init.lua"
require("lib.common")
local loader = require('luarocks.loader')
cjson = require("cjson")

local luasql = require('luasql.sqlite3')
local SpamStatInject = {}
local SpamStatInject_mt = { __index = SpamStatInject }

function SpamStatInject:new(conf)
local db = assert (luasql.sqlite3())
local con = db:connect(conf.dbpath)
return setmetatable({ db = db, con = con, conf = conf }, SpamStatInject_mt)
end


function SpamStatInject:registerTree()
-- first, register the plugin on the main data tree
local returnData = {}

local subtree = {
	postfix = { "connect", "reject",},
	amavis  = { "banned", "clean", "spam",},
	dkim    = { "oksig", "nosig", "badsig",},
}
local stree = {}
for branch,sbranch in pairs(subtree) do
	stree[#stree+1] = branch
	returnData[self.conf.tree .. self.conf.subtree .. "." .. branch] = cjson.encode(sbranch)
end

returnData[self.conf.tree .. self.conf.subtree] = cjson.encode(stree)
-- make only one concatenation of the tree name
self.subtree = self.conf.tree .. self.conf.subtree
return returnData
end

function SpamStatInject:loop()
	local data = self:getDataDays(15)
	local returnData = {}
	returnData[self.conf.tree .. self.conf.subtree .. "." .. "perioddata"] = cjson.encode(data)
--end
end

function SpamStatInject:getDataDays(tinterval)
	--local query = [[ 
	--		select p.date,p.total,p.rejected,a.spam,a.banned,d.failed,d.nosig,d.badsig 
	--		from postfix as p, amavis as a, dkim as d  
	--		where strftime('%s',p.date) > strftime('%s','now','-DAYS day','localtime') and 
	--		p.date like '%23:50:%' and a.id=p.id and p.id=d.id;
	--		]]
	local mailclass = {
		postfix =  { "reject","connect", },
		amavis =  { "spam", "clean", },
		dkim =    {"nosig", "oksig"},
	}


	local query = [[ select sum(count) as soma, strftime("%%Y-%%m-%%d","now","-%d days","localtime") as date
			from %s where eventtype='%s' 
			and date > strftime("%%Y%%m%%d0000","now","-%d days","localtime") 
			and date < strftime("%%Y%%m%%d0000","now","-%d days","localtime");
	]]

	local dquery = [[  select  strftime("%%Y%%m%%d0000","now","-%d days","localtime") ]]


	--[[
        [4] = {
                ["spam"] = 3988;
                ["rejected"] = 91602;
                ["total"] = 117403;
                ["date"] = "2015-07-05 23:50:05";
                ["banned"] = 0;
        };
	--]]


	local resultdata = {}
	for days=1,tinterval do
		resultdata[days] = {}
		-- ugly but functional: using the database to format data
		local daystring
		for stable, class in pairs(mailclass) do
			for _,dtable in pairs(class) do
				local data = {}
				-- print(query:format(days,stable,dtable,days+1,days))
				local cursor = self.con:execute(query:format(days,stable,dtable,days+1,days))
				while cursor:fetch (data, "a") do
					-- data[#data+1] = {}
				end
				resultdata[days][dtable] = data["soma"]
				daystring = data["date"]
			end
		end
		resultdata[days]["date"] = daystring
	end
	self.db:close()
	-- fazer cache do resultdo da query para durante animacao
	--return data
	-- print_r(resultdata)
	return resultdata
end


function SpamStatInject:getDataHour()
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
return SpamStatInject
