local conf = {
	-- layout 
	---- principal
	h = 300,
	w = 800,
	x = 10,
	y = 100,
	margin = 40,
	font = theme.font,
	-- font = "Ninbus Sans L",
	bg = {
                total		= theme.palette.UpColor,
                spam 		= 0x9E162D,
                rejected 	= 0xB4132D,
                badsig 		= 0xF25511,
                failed 		= 0xFF7A0D,
                nosig 		= 0xE28833,
                banned 		= 0xFF7F12,
	},
	fg = { 
		-- name = 0x000000,
		label 	= theme.palette.Label,
		shadow = theme.palette.Shadow,
	},
	-- relacionado aos alertas e a prioridade
	dbpath = "/usr/share/dashboard/data/spamstats.sqlite",
	title = "Email nos ultimos dias",
	datanames = { 
			[1] = "total", 
			[2] = "spam", 
			[3] = "rejected", 
			[4] =  "badsig", 
			[5] =  "failed", 
			[6] = "nosig", 
			[7] = "banned"
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
	graphstyle = "Bars",
	drawstyles = { 
		total 	 = "barbg", 
		spam 	 = "barsum", 
		rejected = "barsum", 
		badsig   = "barsum", 
		failed   = "barsum", 
		nosig	 = "barsum",
		banned	 = "barsum",
	},
	--]]
}


return conf 
