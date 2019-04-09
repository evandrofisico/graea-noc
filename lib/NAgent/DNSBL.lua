-- lua dependencies
--[[
	Embeds nmap ip manipulation function, and as such, this module is almost certanly
	GPLv2.


--]]
require('luarocks.loader')
require("lib.common")
local apr = require("apr")
local cjson = require("cjson")
local DNSBLSet = {}

setmetatable(DNSBLSet, {
__call = function (cls, ...)
        return cls.new(cls,...)
end,
})

function DNSBLSet:new(conf)
local p = {}
p.conf = conf
self.__index = self
return setmetatable(p, self)
end


function DNSBLSet:registerTree()
	local returnData = {}
	local subtree = {'dns','log'}
	returnData[self.conf.tree .. self.conf.subtree] = cjson.encode(subtree)
	self.subtree = self.conf.tree .. self.conf.subtree
	return returnData
end


function DNSBLSet:loop()
	self:checkBL()
end

function DNSBLSet:checkBL()
	local returnData = {}
	-- first, split ip address as a table of each quad
	local pattern, base
	if self.conf.checkip:match( ":" ) then
		pattern = "%x+"
		base = 16
	else
		pattern = "%d+"
		base = 10
	end
	local t = {}
	
	for part in string.gmatch(self.conf.checkip, pattern) do
		t[#t+1] = tonumber( part, base )
	end
	local chkaddr = t[4].."."..t[3].."."..t[2].."."..t[1]
	
	local blresults = {}
	for _,dnsserver in pairs(self.conf.dnsbl) do
		--print( chkaddr .. '.' .. dnsserver );
		local ip = apr.host_to_addr( chkaddr .. '.' .. dnsserver );
		--print(chkaddr .. '.' .. dnsserver)
		ip = apr.host_to_addr( chkaddr .. '.' .. dnsserver );
		-- retry, sometimes it takes two requests to get it right
		if ip ~= nil then
			blresults[#blresults+1] = dnsserver
		end
	end
	returnData[self.subtree..'.dns'] = cjson.encode(blresults)
end

return DNSBLSet
