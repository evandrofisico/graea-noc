local prop = {
	--width = conky_window.width,
	--height = conky_window.height,
	font = theme.font,
	fps = 15, -- frames per second
	update_interval = 10, -- update interval during non-animation
	border = {
		x = 5,
		y = 5,
	},
	dbpath = "/usr/share/dashboard/data/events2.sqlite",
	indicator = "left",
	bg = {
		-- cores de falha
		unknown = 	theme.palette.NeutralColor,
		warning		= theme.palette.AlertColor,
		problem		= theme.palette.DownColor, 
		down		= theme.palette.DownColor,
		critical	= theme.palette.DownColor,
		unreachable	= theme.palette.DownColor, 
		ok		= theme.palette.UpColor, 
		up		= theme.palette.UpColor, 
		default = 	theme.palette.Background,
	},
	fg = { 
		title 		= theme.palette.Title,
		description 	= theme.palette.Title,
	},
	grid = {
		x = 1,
		y = 13,
	},
}

return prop
