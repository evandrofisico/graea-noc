local propEventsProduct = {
	-- layout 
	---- principal
	h = 220,
	w = 300,
	x = 0,
	y = 0,
	font = theme.font,
	-- font = "Ninbus Sans L",
	bg = {
		["Proxy"] 			= theme.genFirstColor(10),
		["Web_Server"] 			= theme.genColor(),
		["Alarm"]			= theme.genColor(),
		["Mail_Server"]			= theme.genColor(),
		["Intrusion_Detection"]		= theme.genColor(),
		["Operating_System"]		= theme.genColor(),
		["Antivirus"]			= theme.genColor(),
		["Authentication_and_DHCP"]	= theme.genColor(),
		["Firewall"]			= theme.genColor(),
		["Server"]			= theme.genColor(),
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
	server = 'janus.evandrofisi.co',
	source = "data:siem.event.product",
	title = "Events",
	datatitle = " ",
}
return propEventsProduct
