prop = {
	-- layout 
	---- principal
	h = 170,
	w = 350,
	x = 0,
	y = 0,
	font = theme.font,
	-- font = "Ninbus Sans L",
	bg = {
		Semanal = theme.genFirstColor(10),
		Mensal  = theme.genColor(),
		Diario  = theme.genColor(), 
		Pkg     = theme.genColor(),
		Anual   = theme.genColor(),
		Default = theme.genColor(),
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
	source = "data:backup.pool",
	title = "Pool",
	datatitle = "Tapes",
}

