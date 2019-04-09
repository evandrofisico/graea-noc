prop = {
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
		["net.outbound"] =	theme.palette.Outbound,
		["net.inbound"] =	theme.palette.Inbound,
		["default"] = 	theme.palette.Background,
		["cpu.nice"] = 	0x8a9b0f,
		["cpu.user"] =	0x0b486b,
		["cpu.system"] =	0xbd1550,
	},
	fg = { 
		-- name = 0x000000,
		title = 0xffffff,
		description = 0x000000,
		outline = 0xcccccc,
	},
	grid = {
		x = 1,
		y = 10,
	},
	-- origem dos dados a mostrar
	services = {
		--
		[1] = { 
			description = "Uso de Banda Roteadores",
			assets = "router",
			source = { "net.inbound", "net.outbound" },
			type = "net",
		},
		--[[
		[1] = { 
			description = "Uso Memoria servidores",
			assets = "server",
			source = { "cpu.nice", "cpu.user", "cpu.system" },
			type = "cpu",
		},
		[2] = { 
			description = "Uso de Banda Roteadores",
			assets = "router",
			source = { "net.inbound", "net.outbound" },
			type = "net",
		},
		--]]
	},
}
