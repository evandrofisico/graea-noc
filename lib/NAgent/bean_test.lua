package.path=package.path..";/home/evandro.rodrigues/graea/?.lua;".."/home/evandro.rodrigues/graea/?/init.lua"
require('luarocks.loader')
require("lib.common")
local ev = require('ev')
local Enyo = { }
local apr = require("apr")
local cjson = require("cjson")
local haricot = require("haricot")

local bs = haricot.new('localhost', 11300)

local testtable = {
	a = { 1, 2, 3, 4},
	b = "string ae",
}

-- bs:use("testeae")
local msgpri = 1
local msgdelay = 1
local msgttr = 1
bs:put(2048,100,1,cjson.encode(testtable))

print(bs:list_tubes())
