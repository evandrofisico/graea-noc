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
	returnData = {}
	returnData[self.subtree..'.dns'] = self:checkBL()
	returnData[self.subtree..'.reputation'] = self:checkReputation()
	return returnData, nil
end

function DNSBLSet:iptoquad(checkip,mode)
-- first, split ip address as a table of each quad
        local pattern, base
        if checkip:match( ":" ) then
                pattern = "%x+"
                base = 16
        else
                pattern = "%d+"
                base = 10
        end
        local t = {}

        for part in string.gmatch(checkip, pattern) do
                t[#t+1] = tonumber( part, base )
        end
        if mode == "string" then
                return t[4].."."..t[3].."."..t[2].."."..t[1]
        else
                return t
        end
end

function DNSBLSet:checkBL()
for _,checkip in pairs(self.conf.checkip) do
        local chkaddr = self:iptoquad(checkip,"string")
        local blresults = {}
        for _,dnsserver in pairs(self.conf.dnsbl) do
                local ip = apr.host_to_addr( chkaddr .. '.' .. dnsserver );
                ip = apr.host_to_addr( chkaddr .. '.' .. dnsserver );
                if ip ~= nil then
                        blresults[#blresults+1] = dnsserver
                end
        end
        -- update data to memcacheserver
	return cjson.encode(blresults)
end
end

function DNSBLSet:checkReputation()
for _,checkip in pairs(self.conf.checkip) do
        local chkaddr = self:iptoquad(checkip,"string")
        local blresults = {}
        local ip = apr.host_to_addr( chkaddr .. '.' .. self.conf.reputation );
        ip = apr.host_to_addr( chkaddr .. '.' .. self.conf.reputation);
        -- retry, sometimes it takes two requests to get it right
        if ip ~= nil then
                local reputation = self:iptoquad(ip)
                -- update data to memcacheserver
		return cjson.encode(reputation[4])
        end
end
end

return DNSBLSet
