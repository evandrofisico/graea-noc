local prop = {
	font = theme.font,
	border = {
		x = 5,
		y = 5,
	},
	indicator = "right",
	-- update em segundos
	update_interval = 20,
	-- numero de updates para circular modo do mapa
	cicle_time = 3,
	bg = {
		UNKNOWN = 	theme.palette.NeutralColor,
		CRITICAL = 	theme.palette.DownColor,
		WARNING = 	theme.palette.AlertColor,
		default = 	theme.palette.Background,
		-- priority based alerts
		Unclassified = theme.palette.Prio_Unclassified,
		Info 	     = theme.palette.Prio_Info,
		Warn 	     = theme.palette.Prio_Warn,
		Avg  	     = theme.palette.Prio_Avg,
		High 	     = theme.palette.Prio_High,
		Disaster     = theme.palette.Prio_Disaster,
	},
	fg = { 
		title = theme.palette.Title,
		description = theme.palette.Title,
		--UNKNOWN = 	theme.palette.NeutralColor,
		--CRITICAL = 	theme.palette.DownColor,
		--WARNING = 	theme.palette.AlertColor,
	},
	-- grid usado para exibir nome de unidades fora do ar
	grid = {
		x = 2,
		y = 10,
		--y = 15,
	},
	server = 'localhost',
	source = 'data:zabbix.issues',
        filtersource = { 'data:zabbix.matrizVirtuais', "data:zabbix.Nuvens", },
}

return prop
