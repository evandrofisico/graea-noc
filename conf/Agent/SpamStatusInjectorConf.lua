local conf = {
	-- relacionado aos alertas e a prioridade
	subtree = 'spaminject',
	tree = 'data:',
	memcserver = 'localhost',
	age = 2592000,
	-- periodicity of running
	period = 60*60*8, -- eight hours

	dbpath = "/usr/share/hecate-dash/data/spamstat.sql",
	datanames = { 
			[1] = "total", 
			[2] = "spam", 
			[3] = "rejected", 
			[4] = "banned"
	},
	ticksource = "date",
	ticktransfunc = function (str) return string.sub(str , 1, 10) end,
	--[[ 
	graphstyle = "Lines",
	drawstyles = { 
		total 	 = "fill", 
		spam 	 = "fillsum", 
		rejected = "fillsum", 
		badsig   = "fillsum", 
		failed	 = "fillsum", 
		nosig	 = "fillsum",
		banned	 = "fillsum",
	},

	--]]
}


return conf 
