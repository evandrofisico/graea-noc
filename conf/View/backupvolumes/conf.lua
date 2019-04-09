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
		Used = theme.palette.NeutralColor,
		Archive = theme.palette.Outbound,
		Append = theme.palette.Inbound,
		Full = theme.palette.DownColor,
		["Read-Only"] = theme.palette.Outbound,
		Purged = theme.palette.AlertColor2,
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
	server = 'localhost',
	source = "data:backup.volumes",
	title = "Tape",
	datatitle = "vols",
}

