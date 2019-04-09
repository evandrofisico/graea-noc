local prop = {
	-- layout 
	---- principal
	h = 300,
	w = 300,
	x = 0,
	y = 40,
	font = theme.font,
	-- font = "Ninbus Sans L",
	bg = {},
	fg = { 
		-- name = 0x000000,
		label 	= theme.palette.Label,
		shadow = theme.palette.Shadow,
	},

	-- data source 
	server = 'localhost',
	-- relacionado aos alertas e a prioridade
	source = "data:mailstats",
}
return prop
