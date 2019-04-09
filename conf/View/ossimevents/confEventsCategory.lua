local propEventsCategory = {
	-- layout 
	---- principal
	h = 220,
	w = 300,
	x = 630,
	y = 0,
	font = theme.font,
	-- font = "Ninbus Sans L",
	bg = {
		Recon  		= theme.genFirstColor(10),
		Access 		= theme.genColor(),
		Policy 		= theme.genColor(),
		Suspicious      = theme.genColor(),
		System 		= theme.genColor(),
		Application    	= theme.genColor(),
		Info   		= theme.genColor(),
		Network         = theme.genColor(),
		Authentication  = theme.genColor(),
		Exploit         = theme.genColor(),
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
	-- relacionado aos alertas e a prioridade
	server = 'janus.evandrofisi.co',
	source = "data:siem.event.category",
	title = "Events",
	datatitle = " ",
}


return propEventsCategory
