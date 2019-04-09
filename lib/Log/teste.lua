package.path=package.path..";/home/evandro.rodrigues/graea/?.lua;".."/home/evandro.rodrigues/graea/?/init.lua"
require('luarocks.loader')
require("lib.common")
local haricot = require("haricot")
local cjson = require("cjson")
local posix = require("posix")

local bs = haricot.new('localhost', 11300)
bs:watch("MailSent")
bs:watch("SpamStats")
bs:watch("TraceUser")
while true do
	local ok, job = bs:reserve()
	print_r(job)
	print(bs:delete(job.id))
end

