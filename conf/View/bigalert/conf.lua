prop = {
	width = 1920,
	height = 1080,
	font = theme.font,
	fade_frames = 30,
	showmsg_frames = 160,
	fps = 15, -- frames per second
	update_interval = 1, -- update interval during non-animation
	-- font = "Ninbus Sans L",
	bg = {
		atendimento = 	0x01a507,
		startup = 	0x01a507,
		neutral = 	theme.palette.NeutralColor,
		up = 		theme.palette.UpColor,
		ok = 		theme.palette.UpColor,
		unreachable = 	theme.palette.AlertColor,
		intermitent = 	theme.palette.AlertColor,
		off =		theme.palette.DownColor,
		problem =	theme.palette.DownColor,
		down =		theme.palette.DownColor,
		death =		theme.palette.DownColor,
		zombie =	theme.palette.DownColor,

		recovery     = theme.palette.UpColor,
		unclassified = theme.palette.Prio_Unclassified,
		info 	     = theme.palette.Prio_Info,
		warning      = theme.palette.Prio_Warn,
		average      = theme.palette.Prio_Avg,
		high 	     = theme.palette.Prio_High,
		disaster     = theme.palette.Prio_Disaster,
	},
	fg = { 
		-- name = 0x000000,
		title = 0xffffff,
		text = 0x333333,
		shadow = 0x444444,
	},
	grid = {
		x = 1,
		y = 10,
	},
}
