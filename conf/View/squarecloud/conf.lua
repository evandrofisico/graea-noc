local prop = {
	-- layout 
	---- principal
	x = 10,
	y = 0,
	w = 900,
	h = 930,
	mydomain = 'evandrofisi.co',
	font = theme.font,
	border = {
		x = 5,
		y = 5,
	},
	--indicator = "right",
	indicator = "left",
	-- font = "Ninbus Sans L",
	bg = {
		cpu =      theme.palette.CpuColor,
		mem =      theme.palette.MemColor,
		inbound =  theme.palette.Inbound,
		outbound = theme.palette.Outbound,
		DataBG  =  theme.palette.DataBG,
	},
	fg = { 
		-- name = 0x000000,
		label 	= theme.palette.Label,
		shadow = theme.palette.Shadow,
	},
	grid = {
		x = 2,
		y = 11,
		--y = 13,
	},
	-- relacionado aos alertas e a prioridade
	server = 'localhost',
	hostsource = "data:virttool",
	datasource = { 
		virtuais = "data:zabbix.matrizVirtuais",
		fisicas  = "data:zabbix.Nuvens",
	},

	labelmap = {
		cpu = 	'cpu',
		mem = 	'mem',
		inbound = 	'inbound',
		outbound = 	'outbound',
	},
}
return prop
