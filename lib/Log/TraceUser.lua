require('luarocks.loader')
require("lib.common")
local cjson = require("cjson")
local sqlite = require('luasql.sqlite3')

TraceUser = {}
TraceUser.__index = TraceUser

setmetatable(TraceUser, {
__call = function (cls, ...)
	return cls.new(cls,...)
end,
})

function TraceUser:new(conf)
	local db = assert (sqlite.sqlite3())
	local con = db:connect(conf.dbpath)
	conf.callback = false
	conf.matchback = true
	return setmetatable({ conf = conf, db = db, con = con,}, self)
end

function TraceUser:registerTree()
-- first, register the plugin on the main data tree
local returnData = {}
local subtree = {
	'sessions',
	'commands',
}
returnData[self.conf.tree .. self.conf.subtree] = cjson.encode(subtree)
-- make only one concatenation of the tree name
self.subtree = self.conf.tree .. self.conf.subtree
self.subtreetable = subtree
return returnData
end

function TraceUser:createTable()
local session = [[ CREATE TABLE traceuser_session (
			starttime integer, 
			endtime integer, 
			username varchar, 
			host varchar, 
			client varchar,
			port integer, 
			authmethod varchar,
			pid integer
			); ]]
			-- primary key (starttime,host,pid,port)

local cexec = [[ CREATE TABLE traceuser_commands (
			date integer, 
			host varchar, 
			username varchar, 
			client varchar,
			port integer,
			path varchar,
			exec varchar
			); ]]
--self.con:execute(session)
--self.con:execute(cexec)
end

function TraceUser:sendData()
	local returnData = {}
	local sendquery = "select traceuser_commands.username as username, traceuser_session.port as port, max(traceuser_commands.date) as date, traceuser_commands.host as host, traceuser_session.client as client, traceuser_commands.path as path, traceuser_commands.exec as exec from traceuser_commands, traceuser_session where traceuser_session.endtime is null and traceuser_commands.username=traceuser_session.username and traceuser_commands.port=traceuser_session.port group by traceuser_commands.username,traceuser_commands.host,traceuser_session.client,traceuser_session.port,traceuser_session.pid order by date;"
	
	local cursor = self.con:execute(sendquery)
	local index = 1
	local data = {}
	local senddata = {}
	
	data[index] = {}
	while cursor:fetch (data[index], "a") do
		--senddata[data[index]["domain"]] = data[index]["count"]
		index = index + 1
		data[index] = {}
	end
	returnData[self.conf.tree .. self.conf.subtree .. '.sessions'] = cjson.encode(data)
end


function TraceUser:runCallBack(log)
-- -- declare function to parse snoopy logs
local functions = {
	["snoopy"] = function (log)
	-- parse snoopy input
	local matchpattern = "%[([%w.%(%)].*)@([%w.%(%)].*):([%w./].*)%] (%w.*)"
	local username, clientstr, path, exec = log.msg:match(matchpattern)

	if ( username == "(unknown)" or clientstr == "(undefined)" ) then
		return nil
	else
	
		-- further match the client into client (ip), port (remote port) and local port (discharded)
		local client, port, rport = clientstr:match("(%d+.%d+.%d+.%d+) ([%d].*) ([%d].*)")
		--print(username,client,port,rport)
		--print(client,port,rport)
		
		-- check is there is an open session
		local sessionquery = "select * from traceuser_session where endtime is null and username='%s' and port='%s';"
		local cursor = self.con:execute(sessionquery:format(username,port))
		
		local data = {}
		cursor:fetch (data, "a")
		if data["authmethod"] ~= nil then
			local squery = "insert into traceuser_commands (date, host, username, client, port, path, exec) values ('%s', '%s', '%s', '%s', '%s', '%s', '%s' );"
			--print(squery:format(log["timestamp"],log["host"],username,client,port,path,exec))
			self.con:execute(squery:format(log["timestamp"],log["host"],username,client,port,path,exec))
			--print("inserting command ",exec)
		end
	end
	end,

	["sshd"] = function (log)
		local cachedata, messagedata
		local connpattern = "Accepted (%w+) for ([%w.]*) from (%d+.%d+.%d+.%d+) port ([%d].*) ssh2"
		local discpattern = "pam_unix%(sshd:session%): session closed for user ([%w.]*)"

		local authmethod, username, client, port = log.msg:match(connpattern)
		local disuser = log.msg:match(discpattern)

		if ( username == "avapi" or disuser  == "avapi" ) then
			return nil
		end

		if username ~= nil then
			local squery = "insert into traceuser_session (starttime, username, host, client, port, authmethod, pid ) values ('%s', '%s', '%s', '%s', '%s', '%s', '%s');";
			self.con:execute(squery:format(log["timestamp"], username, log["host"], client, port, authmethod, log.pid))
			-- print(squery:format(log["timestamp"], username, log["host"], client, port, authmethod, log.pid))
			cachedata, messagedata = self:sendData()
		end

		if disuser ~= nil then
			local squery = "update traceuser_session set endtime='%s' where pid='%s' and username='%s' and host='%s';"
			local altreg = self.con:execute(squery:format(log["timestamp"], log["pid"], disuser, log["host"]))
			-- print(squery:format(log["timestamp"], log["pid"], disuser, log["host"]))
			--print('alterados ',altreg,' registros')
			--print(squery:format(log["timestamp"], log["pid"], disuser, log["host"]))
			cachedata, messagedata = self:sendData()
		end
		return cachedata, messagedata
	end,
}
end

return TraceUser
