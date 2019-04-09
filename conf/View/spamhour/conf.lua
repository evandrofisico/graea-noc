local conf = {
	-- layout 
	---- principal
	h = 280,
	w = 400,
--	h = 170,
--	w = 300,
	x = 0,
	y = 0,
	font = theme.font,
	-- font = "Ninbus Sans L",
	bg = {
                not_spam 	= theme.palette.UpColor,
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
	grid = {
		x = 3,
		y = 1,
	},
	-- data source 
	dbpath = "/usr/share/dashboard/data/spamstats.sqlite",
	title = "Email 1h ",
	-- relacionado aos alertas e a prioridade
	datatitle = "msgs",
}

return conf
