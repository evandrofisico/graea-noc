prop = {
	-- layout 
	---- principal
	h = 150,
	w = 300,
	x = 0,
	y = 40,
	font = theme.font,
	-- font = "Ninbus Sans L",
	bg = {
		["Bytes Armazenados"]	= theme.genFirstColor(5),
		["Tamanho Catalogo"]	= theme.genColor(),
		["Ultimos Bytes"]	= theme.genColor(),
		["Total Volumes"]	= theme.genColor(),
		["Clientes"]		= theme.genColor(),
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

	translabel = {
		stored_bytes	= "Bytes Armazenados",
		database_size	= "Tamanho do Catalogo",
		bytes_last	= "Ultimos Bytes",
		volumes_size	= "Tamanho dos Volumes",
		clients		= "Numero de Clientes",
	},

	-- data source 
	server = 'localhost',
	-- relacionado aos alertas e a prioridade
	source = "data:backup.catalog",
	title = "Backup",
	datatitle = "jobs",
}

