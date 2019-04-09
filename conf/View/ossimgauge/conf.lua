local prop = {
	radius = 80,
	font = theme.font,
	-- font = "Ninbus Sans L",
	data_age = 60*5,
	fg = { 
		-- name = 0x000000,
		label = theme.palette.Title,
		description = theme.palette.Description,
		line = theme.palette.Line,
	},
	grid = {
		max_dlines = 5,
	},
	-- relacionado aos alertas e a prioridade
	bandalert = {
		interval = 15*60,
		warning_value = 0.7,
		error_value = 0.9,
	},
	--source ={ "siem.Risco", "siem.Ticket", "siem.Alarmes", },
	-- data source 
	server = 'localhost',
	-- relacionado aos alertas e a prioridade
	source = "data:siem.gauge",
	-- widget title
	title = 'AlienVault',
}

return prop
