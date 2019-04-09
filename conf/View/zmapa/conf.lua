prop = {
	font = theme.font,
	border = {
		x = 0,
		y = 100,
	},
	scale = 0.9,
	max_w = 903,
	max_h = 908,
	-- update em segundos
	update_interval = 20,
	-- numero de updates para circular modo do mapa
	cicle_time = 3,
	indicator = "left",
	--	border = {
	--		DOWN = 0x4d0a0a,
	--	},
	bg = {
		neutral = 	theme.palette.NeutralColor,
		unknown = 	theme.palette.NeutralColor,
		up = 		theme.palette.UpColor,
		ok = 		theme.palette.UpColor,
		unreachable = 	theme.palette.AlertColor,
		intermitent = 	theme.palette.AlertColor,
		warning= 	theme.palette.AlertColor,
		off =		theme.palette.DownColor,
		down =		theme.palette.DownColor,
		death =		theme.palette.DownColor,
		zombie =	theme.palette.DownColor,
		critical = 	theme.palette.DownColor,
	},
	fg = { 
		label 	= theme.palette.Label,
		shadow = theme.palette.Shadow,
		title = theme.palette.Title,
		border = theme.palette.Border,
		line = theme.palette.Line,
	},
	-- grid usado para exibir nome de unidades fora do ar
	grid = {
		x = 2,
		y = 25,
	},
	-- data source 
	server = 'janus.evandrofisi.co',
	-- relacionado aos alertas e a prioridade
	sourceroot = "data:zabbix",
	sources = {
		"ServidoresSUREG",
		"RoteadoresSUREGS",
		"RoteadoresUA",
		"ServidoresUA",
	},

	service_count = 5,
	-- [[
	services = {
		[1] = {
			description = "Links no Brasil",
			source = { "RoteadoresUA", "RoteadoresSUREGS", },
			item = "avail.icmpping",
			type = "discrete",
			pointsize = 20,
			prefix = "router-",
		},

		[2] = {
			description = "Servidores no Brasil",
			source = { "ServidoresSUREG","ServidoresUA", },
			item = "avail.icmpping",
			type = "discrete",
			pointsize = 20,
			prefix = "",
		},
		[3] = { 
			description = "Uso de Banda Roteadores",
			source = { "RoteadoresUA", "RoteadoresSUREGS", },
			item = "net.inbound",
			type = "heat",
			pointsize = 20,
			prefix = "router-",
		},
		[4] = { 
			description = "Uso de CPU Servidores",
			source =  { "ServidoresSUREG", },
			--source =  { "ServidoresSUREG","ServidoresUA", },
			item = "cpu.idle",
			type = "heat",
			pointsize = 20,
			prefix = "",
		},
		[5] = { 
			description = "Uso de Ram Servidores",
			assets =  { "ServidoresSUREG","ServidoresUA", },
			source = "mem.used",
			type = "heat",
			pointsize = 20,
			prefix = "",
		},
			
	},
}


return prop
