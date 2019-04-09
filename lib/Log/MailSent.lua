require('luarocks.loader')
require("lib.common")
local apr = require("apr")
local cjson = require("cjson")
local sqlite = require('luasql.sqlite3')

MailSent = {}
MailSent.__index = MailSent

setmetatable(MailSent, {
__call = function (cls, ...)
	return cls.new(cls,...)
end,
})

function MailSent:new(conf)
local db = assert (sqlite.sqlite3())
local con = db:connect(conf.dbpath)

local mc = apr.memcache(1)
mc:add_server(conf.memcserver,11211);

-- to signal the loader program how to load the plugins callbacks
conf.callback = true
conf.matchback = false

return setmetatable({ conf = conf, db = db, con = con, mc = mc }, self)
end


function MailSent:registerTree()
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
local subtree = {'outusers', 'indomains',}
self.mc:set(self.conf.tree .. self.conf.subtree,cjson.encode(subtree),0)
-- make only one concatenation of the tree name
self.subtree = self.conf.tree .. self.conf.subtree
end

function MailSent:internalSent(user,inc)
local today = os.date("%Y%m%d")
local setquery = 'insert or ignore into send (date, sender, count) values ("%s", "%s", 0 );'
local updquery = 'update send set count = count + %d where date = "%s" and sender = "%s";'
self.con:execute(setquery:format(today,user))
self.con:execute(updquery:format(inc,today,user))
-- use the same connection to gather data and inject into the cache
local getquery = 'select sender,count from send where date="%s" order by count desc limit 15;'
local cursor = self.con:execute(getquery:format(today,user))
local index = 1
local data = {}
local senddata = {}

data[index] = {}
while cursor:fetch (data[index], "a") do
	senddata[data[index]["sender"]] = data[index]["count"]
	index = index + 1
	data[index] = {}
end
self.mc:set(self.conf.tree .. self.conf.subtree .. '.outusers', cjson.encode(senddata),0)
end

function MailSent:externalReceived(domain,inc)
local today = os.date("%Y%m%d")
local setquery = 'insert or ignore into recv (date, domain, count) values ("%s", "%s", 0);'
local updquery = 'update recv set count = count + %d where date = "%s" and domain = "%s";'
self.con:execute(setquery:format(today,domain))
self.con:execute(updquery:format(inc,today,domain))
-- use the same connection to gather data and inject into the cache
local getquery = 'select domain,count from recv where date="%s" order by count desc limit 15;'
local cursor, cerror = self.con:execute(getquery:format(today,user))
if cursor ~= nil then
local index = 1
local data = {}
local senddata = {}

data[index] = {}
while cursor:fetch (data[index], "a") do
	senddata[data[index]["domain"]] = data[index]["count"]
	index = index + 1
	data[index] = {}
end
self.mc:set(self.conf.tree .. self.conf.subtree .. '.indomains', cjson.encode(senddata),0)
end
end

function MailSent:createTable()
	-- abusing date function to format a query... why not??
	local sendq = "CREATE TABLE send (date varchar, sender  varchar, count integer, primary key (date,sender));"
	local recvq = "CREATE TABLE recv (date varchar, domain  varchar, count integer, primary key (date,domain));"
	self.con:execute(sendq)
	self.con:execute(recvq)
end


function MailSent:runCallBack(log)
local contfrom = string.match(log.msg, 'from=<[^>]*@([^>]*)>')
local nrcpt = string.match(log.msg, 'nrcpt=(%d)')
if contfrom ~= nil and  nrcpt ~=nil then
	--local mymail = string.match(log.msg, 'from=<([^>]*)>')
	local fromRegex = 'from=<([^>]*)@' .. self.conf.mydomain ..'>'
	local mymail = string.match(log.msg, fromRegex)
	if mymail ~= nil then
		-- send to internal counter
		self:internalSent(mymail,tonumber(nrcpt))
	else
		self:externalReceived(contfrom,tonumber(nrcpt))
	end
end
end

return MailSent
