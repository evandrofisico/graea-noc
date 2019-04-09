local prop = {
	width = 300,
	height = 1030,
	lw = 2,
	font = theme.font,
	cicle_time = 3,
	indicator = "left",
	border = {
		x = 5,
		y = 5,
	},
	bg = {
		["value"] = 0x8A9B0F,
		["bg"] = 0x495849,
	},
	fg = { 
		-- name = 0x000000,
		title = theme.palette.Title,
		outline = theme.palette.Line,
		description = theme.palette.Description,
	},
	grid = {
		x = 1,
		y = 5,
	},
	-- origem dos dados a mostrar
	server = 'localhost',
	source = 'data:siem.tickets.users',
}

return prop
