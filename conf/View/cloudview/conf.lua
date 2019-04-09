prop = {
	-- layout 
	---- principal
	x = 10,
	y = 0,
	w = 900,
	h = 1030,
	font = theme.font,
	-- font = "Ninbus Sans L",
	bg = {
		CPU = theme.palette.CpuColor,
		Memory = theme.palette.MemColor,
		Inbound   = theme.palette.Inbound,
		Outbound    = theme.palette.Outbound,
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
	hostsource = "cloudservers",
	datasource = { 
		Memory = "mem.free",
		CPU = "cpu.idle",
		Inbound = "net.inbound",
		Outbound = "net.outbound",
	},
	--[[ types of view:
			fullview:  arc centered on pi/2, starting on top, ranging from 0->2*pi
			leftview:  arc starting on pi/2, showing on left only, ranging form 0->pi
			rightview: arc starting on pi/2, showing on right only, ranging form 0->pi
	--]]
	dataview = {
		Memory = "fullview",
		CPU = "fullview",
		Inbound = "leftview",
		Outbound = "rightview",
	}
}


