local propOcurrences = {
	-- layout 
	---- principal
	h = 220,
	w = 300,
	x = 1200,
	y = 0,
	font = theme.font,
	-- font = "Ninbus Sans L",
	bg = {
        	["Malware_Domain"] = theme.genFirstColor(6),
        	["Malicious_Host"] = theme.genColor(),
        	["Malware_IP"]     = theme.genColor(),
        	["C&C"]            = theme.genColor(),
        	["Scanning_Host"]  = theme.genColor(),
        	["Spamming"]       = theme.genColor(),
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
	source = "data:siem.ocurrences.ocurrences",
	title = "Ocurrences",
	datatitle = " ",
}
return propOcurrences
