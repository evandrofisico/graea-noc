prop = {
	-- layout 
	---- principal
	h = 170,
	w = 300,
	x = 0,
	y = 0,
	font = theme.font,
	-- font = "Ninbus Sans L",
	bg = {
		Running   = theme.palette.AlertColor,
		Completed = theme.palette.Outbound,
		Waiting   = theme.palette.Inbound,
		Failed    = theme.palette.DownColor,
		Canceled  = theme.palette.NeutralColor,
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
	server = 'localhost',
	-- relacionado aos alertas e a prioridade
	source = "data:backup.jobs",
	title = "Backup",
	datatitle = "jobs",
}

