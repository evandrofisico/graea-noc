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
		["net.eth200.outbound"] =	theme.palette.Outbound,
		["net.eth200.inbound"] =	theme.palette.Inbound,

		["net.eth104.outbound"] =	theme.palette.Outbound,
		["net.eth104.inbound"] =	theme.palette.Inbound,

		["net.eth192.outbound"] =	theme.palette.Outbound,
		["net.eth192.inbound"] =	theme.palette.Inbound,

		["net.eth10.outbound"] =	theme.palette.Outbound,
		["net.eth10.inbound"] =	theme.palette.Inbound,

		["default"] = 	theme.palette.Background,

		["mem.buffer"] = 0x520400 , 
		["mem.cache"]  = 0xd25e07, 
		["mem.free"]   = 0x036388,

		["cpu.nice"] = 	0x8a9b0f,
		["cpu.user"] =	0x0b486b,
		["cpu.system"] = 0xbd1550,
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
	-- server
	server = 'localhost',
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
return prop
