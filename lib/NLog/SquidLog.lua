require('luarocks.loader')
require("lib.common")
local cjson = require("cjson")
local sqlite = require('luasql.sqlite3')
local url = require('net.url')

SquidLog = {}
SquidLog.__index = SquidLog

setmetatable(SquidLog, {
__call = function (cls, ...)
	return cls.new(cls,...)
end,
})

function SquidLog:new(conf)
local db = assert (sqlite.sqlite3())
local con = db:connect(conf.dbpath)

-- to signal the loader program how to load the plugins callbacks
conf.callback = true
conf.matchback = false

return setmetatable({ conf = conf, db = db, con = con, }, self)
end

function SquidLog:registerTree()
	-- first, register the plugin on the main data tree
	local returnData = {}
	local subtree = {
		'topusercon', 
		'topuserflux',
		'topsitecon',
		'topsiteflux',
	}
	returnData[self.conf.tree .. self.conf.subtree] = cjson.encode(subtree)
	-- make only one concatenation of the tree name
	self.subtree = self.conf.tree .. self.conf.subtree
	self.subtreetable = subtree
	return returnData
end


function SquidLog:createTable()
local dtable = "CREATE TABLE %s (date varchar, eventtype varchar, count integer, primary key (date,eventtype));"
for _,tablename in pairs(self.subtreetable) do
	self.con:execute(dtable:format(tablename))
end
end


function SquidLog:countEvent(msgtable)
	local returnData = {}
	local today = os.date("%Y%m%d")
	local fullquery = " "
	local setquery = 'insert or ignore into %s (date, eventtype, count) values ("%s", "%s", 0 );\n'
	fullquery  = fullquery .. setquery:format('topsitecon' ,today,msgtable.URL)
	fullquery  = fullquery .. setquery:format('topusercon' ,today,msgtable.user)
	fullquery  = fullquery .. setquery:format('topsiteflux',today,msgtable.URL)
	fullquery  = fullquery .. setquery:format('topuserflux',today,msgtable.user)
	
	local rows = self.con:execute(fullquery)
	self.con:commit()
	
	local fullquery = " "
	
	local fluxquery  = 'update %s set count = count + %d where date = "%s" and eventtype = "%s";\n'
	local countquery = 'update %s set count = count + 1 where date = "%s" and eventtype = "%s";\n'
	fullquery = fullquery .. fluxquery:format('topsiteflux',msgtable.bytes,today,msgtable.URL)
	fullquery = fullquery .. fluxquery:format('topuserflux',msgtable.bytes,today,msgtable.user)
	fullquery = fullquery .. countquery:format('topsitecon',today,msgtable.URL)
	fullquery = fullquery .. countquery:format('topusercon',today,msgtable.user)
	--fullquery = fullquery .. "end transaction;"
	
	-- finally, commit
	local rows = self.con:execute(fullquery)
	if rows ~= 0 then
	     print("comitou")
	end
	
	---- use the same connection to gather data and inject into the cache
	for _,tablename in pairs(self.subtreetable) do
		local getquery = 'select count, eventtype from %s where date >= strftime("%%Y%%m","now","localtime") order by count desc limit 20;'
		local cursor = self.con:execute(getquery:format(tablename))
		local data = {}
		local senddata = {}
		while cursor:fetch (data, "a") do
			senddata[data["eventtype"]] = data["count"]
		end
			--print_r(senddata)
		
		returnData[self.conf.tree .. self.conf.subtree .. '.' .. tablename] = cjson.encode(senddata)
	end
end

function SquidLog:runCallBack()
local parsefunc = function (log)
	local cachedata, messagedata 
	-- ugly parsing code, I know
	local logparms = { 
		[0]  = "time",
		[1]  = "elapsed",
		[2]  = "remotehost",
		[3]  = "status",
		[4]  = "bytes",
		[5]  = "method",
		[6]  = "URL",
		[7]  = "user",
		[8]  = "peerstatus",
		[9]  = "peerhost",
		[10] = "type",
	}
	local logvals = {}
	local strInd = 0
	for str in log.msg:gmatch("%S+") do
		logvals[ logparms[strInd] ] = str
		strInd = strInd + 1
	end
	--  do the statistical magic
	if logvals.user ~= '-' then
		if logvals.method ~= 'CONNECT' then
			logvals.URL = url.parse(logvals.URL).host
		end
		cachedata, messagedata = self:countEvent(logvals)
	end
	return cachedata, messagedata
	end

local filters = {
	["squidserver01 squid"] = parsefunc,
	["squidserver02 squid"] = parsefunc,
	["squidserver03 squid"] = parsefunc,
	["squidserver04 squid"] = parsefunc,
	["squidserver05 squid"] = parsefunc,
	["squidserver06 squid"] = parsefunc,
}
	return filters
end


return SquidLog
