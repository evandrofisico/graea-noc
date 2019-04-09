NagEventsLoader = {}
NagEventsLoader_mt = { __index = NagEventsLoader }

function NagEventsLoader:new()
	local mc = apr.memcache(1)
	mc:add_server('localhost',11211);
	return setmetatable({ mc = mc }, NagEventsLoader_mt)
end

function NagEventsLoader:GetData()
local status, data, read
	status, show = self.mc:get('data:message:janus:bigalert:show')
	if status == nil  then
		return nil
	elseif show ~= '1' then
		return nil
	else
		local e = {}
		status, e.title = self.mc:get('data:message:janus:bigalert:title')
		status, e.text  = self.mc:get('data:message:janus:bigalert:text')
		--
		-- alterando para caso de problema, sinalizar com o 
		-- nivel e nao com o tipo de evento, entao up e ok 
		-- nao tem alteracoes
		-- local status, sttype = self.mc:get('janus:bigalert:type')
		-- if ( sttype == "ok" or  sttype == "up" ) then
		-- 	e.type = sttype
		-- else
		-- 	status, e.type = self.mc:get('janus:bigalert:level')
		-- end
		--
		status, e.type = self.mc:get('data:message:janus:bigalert:type')
		status, e.mute = self.mc:get('data:message:janus:bigalert:mute')
		status, read  =  self.mc:get('data:message:janus:bigalert:read')
		if tonumber(read) == 1 then
			e.read = 1
		end
		return e
	end
end

function NagEventsLoader:CleanData()
	self.mc:set('data:message:janus:bigalert:show',0,0)
	self.mc:set('data:message:janus:bigalert:read',0,0)
	self.mc:delete('data:message:janus:bigalert:read',1)
	self.mc:delete('data:message:janus:bigalert:show',1)
end

function NagEventsLoader:SetValue(name,value)
	self.mc:set('data:message:janus:bigalert:'..name,value)
end

function NagEventsLoader:GetValue(name)
	return self.mc:get('data:message:janus:bigalert:'..name)
end
