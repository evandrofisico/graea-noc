require('luarocks.loader')
require("lib.common")
local apr = require("apr")
local cjson = require("cjson")
local sqlite = require('luasql.sqlite3')

SpamStats = {}
SpamStats.__index = SpamStats

setmetatable(SpamStats, {
__call = function (cls, ...)
	return cls.new(cls,...)
end,
})

function SpamStats:new(conf)
local db = assert (sqlite.sqlite3())
local con = db:connect(conf.dbpath)

local mc = apr.memcache(1)
mc:add_server(conf.memcserver,11211);

-- to signal the loader program how to load the plugins callbacks
conf.callback = true
conf.matchback = false

return setmetatable({ conf = conf, db = db, con = con, mc = mc }, self)
end


function SpamStats:registerTree()
-- first, register the plugin on the main data tree
local status, pdata = self.mc:get(self.conf.tree)

if ( status == nil or pdata == nil )then
-- nothing previously registered, we are first post :)
	local data = {}
	table.insert(data,self.conf.subtree)
	self.mc:set(self.conf.tree,cjson.encode(data),0)
else
	-- test if the plugin is already registered on the memcache
	-- server. If not, register it
	local newbranch = {}
	local found = false
	local data =  cjson.decode(pdata);
	for _,branch in pairs(data) do
		if branch == self.conf.subtree then
			found = true
		end
	end
	-- if we are already registered, do nothing
	if found == false then
		table.insert(data,self.conf.subtree)
		self.mc:set(self.conf.tree,cjson.encode(data),0)
	end
end
local subtree = {
	postfix = { "connect", "reject",},
	amavis  = { "banned", "clean", "spam",},
	dkim    = { "oksig", "nosig", "badsig",},
}
local stree = {}
for branch,sbranch in pairs(subtree) do
	stree[#stree+1] = branch
	self.mc:set(self.conf.tree .. self.conf.subtree .. "." .. branch,cjson.encode(sbranch),0)
end

self.mc:set(self.conf.tree .. self.conf.subtree,cjson.encode(stree),0)
-- make only one concatenation of the tree name
self.subtree = self.conf.tree .. self.conf.subtree
end

function SpamStats:countEvent(origin,eventtype)
local today = os.date("%Y%m%d%H%M")
local setquery = 'insert or ignore into %s (date, eventtype, count) values ("%s", "%s", 0 );'
local updquery = 'update %s set count = count + 1 where date = "%s" and eventtype = "%s";'
self.con:execute(setquery:format(origin,today,eventtype))
self.con:execute(updquery:format(origin,today,eventtype))
---- use the same connection to gather data and inject into the cache
local getquery = 'select sum(count) as count, eventtype from %s where eventtype="%s" and date > strftime("%%Y%%m%%d%%H%%M","now","-1 hours","localtime");'
local cursor, cerror = self.con:execute(getquery:format(origin,eventtype))
if cursor ~= nil then
local data = {}
while cursor:fetch (data, "a") do
	--senddata[data["eventtype"]] = data["count"]
end
self.mc:set(self.conf.tree .. self.conf.subtree .. '.' .. origin .. '.' .. eventtype , cjson.encode(data["count"]),0)
else
	print(cerror)
end
end

function SpamStats:createTable()
local pftable = 'CREATE TABLE postfix ( date varchar, eventtype varchar, count integer, primary key (date,eventtype));'
local amtable = 'CREATE TABLE amavis  ( date varchar, eventtype varchar, count integer, primary key (date,eventtype));'
local dktable = 'CREATE TABLE dkim    ( date varchar, eventtype varchar, count integer, primary key (date,eventtype));'
local httable = 'CREATE TABLE hit     ( date varchar, eventtype varchar, count integer, primary key (date,eventtype));'
self.con:execute(pftable)
self.con:execute(amtable)
self.con:execute(dktable)
end

function SpamStats:runCallBack(log)
	local filters = {
		["mailsender postfix/smtpd"] = function (log)
			-- treat connections and rejections
			local reject  = string.match(log.msg, 'reject:')
			local connect = string.match(log.msg, '^connect from (%a+)')

			if reject  ~= nil then self:countEvent('postfix','reject')  end
			if connect ~= nil and connect ~= 'localhost' then 
				self:countEvent('postfix','connect') 
				--print("connect!")
			end

		end,
		["mailsender amavis"] = function (log)
			local banned = string.match(log.msg, 'Blocked BANNED ')
			local clean  = string.match(log.msg, 'Passed CLEAN ' )
			local spam   = string.match(log.msg, 'Passed SPAM ' )

			if banned ~= nil then self:countEvent('amavis','banned') end
			if clean  ~= nil then self:countEvent('amavis','clean')	 end
			if spam   ~= nil then self:countEvent('amavis','spam')   end
			-- postfix hit (number, whitelist, blacklist)
			
		end,
		["mailsender opendkim"] = function (log)
			local nosig  = string.match(log.msg, ' no signature data')
			local oksig  = string.match(log.msg, ' DKIM verification successful' )
			local badsig = string.match(log.msg, ' bad signature data' )

			if nosig  ~= nil then self:countEvent('dkim','nosig')  end
			if oksig  ~= nil then self:countEvent('dkim','oksig')  end
			if badsig ~= nil then self:countEvent('dkim','badsig') end
		end,
	}
	filters[log.program](log)

end

return SpamStats
