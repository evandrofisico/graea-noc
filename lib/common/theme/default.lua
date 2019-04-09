-- por enquanto, apenas fonte e paleta de cores
local theme = {
--font = 'Roboto:style=Regular',
font = 'Century Gothic',
style = "fill",
text = {
        alpha = 1.0,
	shadow = true,
	shadowalpha = 0.2,
	shadowcolor = 0x000000,
},
--font = 'Ubuntu',
palette = {
	-- backgrounds
	CpuColor = 0xE54115,
	-- CpuColor = 0xE54115,
	MemColor = 0x519548,
	-- MemColor = 0x9CB28C,
	UpColor = 0x036564,
	DownColor = 0x4d0a0a,
	AlertColor = 0xd07e0e,
	NeutralColor = 0x556270,
	AlertColor2 = 0xE54115,
	Outbound = 0x0d767e,
	Inbound = 0x13800d,
	Background = 0x333333,
	-- texts
	Title = 0xffffff,
	Shadow = 0x333333,
	Label = 0xffffff,
	Description = 0x000000,
	-- line
	Border = 0xcccccc,
	Line  = 0xcccccc,
	-- priority based alerts
	Prio_Unclassified = 0xDBDBDB,
	Prio_Info 	  = 0xD6F6FF,
	Prio_Warn 	  = 0xFFF6A5,
	Prio_Avg  	  = 0xFFB689,
	Prio_High 	  = 0xFF9999,
	Prio_Disaster 	  = 0xFF9999,
},
-- saturation and light for the heat-type widgets
	saturation = 0.71,
	light = 0.36,

	-- as sometimes the theme designer may want to change 
	-- how colors are calculated for the heat maps, add
	-- a function that returns r,g and b values based on the 
	-- status value
}

function theme.stateToRGB(state)
	return colors.hsl_to_rgb(100-state,  theme.saturation, theme.light)
end

function theme.rgb_to_r_g_b(colour, alpha)
	if colour == nil then
		colour = theme.palette.Background
	end
	return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255., alpha
end

function theme.r_g_b_to_rgb(r,g,b)
	return (r*255*0x10000+g*255*0x100+b*255)
end

function theme.genFirstColor(total)
        theme.genseed = 0
        theme.totalgcolor = total
        theme.colid = 0
        return theme.r_g_b_to_rgb(colors.hsl_to_rgb(theme.genseed+theme.colid*(360/theme.totalgcolor),  theme.saturation, theme.light))
end

function theme.genColor()
        theme.colid = theme.colid + 1
        return theme.r_g_b_to_rgb(colors.hsl_to_rgb(theme.genseed+theme.colid*(360/theme.totalgcolor),  theme.saturation, theme.light))
end

return theme
