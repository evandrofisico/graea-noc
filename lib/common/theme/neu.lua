-- por enquanto, apenas fonte e paleta de cores
local theme = {
--font = 'Infinity',
font = 'Yanone Kaffeesatz',
text = {
        alpha = 1.0,
	shadow = true,
	shadowalpha = 0.2,
	shadowcolor = 0x000000,
},
style = "fill",
--font = '(_renaissance),surrounding__.)',
	palette = {
		-- backgrounds
		CpuColor = 0xE54115,
		MemColor = 0x519548,
		UpColor = 0x35A0B0,
		DownColor = 0xb8172e,
		AlertColor = 0xf6a628,
		NeutralColor = 0x556270,
		AlertColor2 = 0xE54115,

		Outbound = 0x35A0B0,
		Inbound = 0xADC730,

		Background = 0x444444,
		DataBG = 0x111111,
		-- texts
		Title = 0xffffff,
		Shadow = 0x000000,
		Label = 0xffffff,
		Description = 0x000000,
		-- line
		Border = 0x333333,
		Line  = 0xffffff,
		-- priority based alerts
		Prio_Unclassified = 0x444444,
		Prio_Info 	  = 0x127C96,
		Prio_Warn 	  = 0xFFBE18,
		Prio_Avg  	  = 0x6F1C16,
		Prio_High 	  = 0xDD0B18,
		Prio_Disaster 	  = 0x48528A,
	},
	-- saturation and light for the heat-type widgets
	saturation = 0.78,
	light = 0.41,

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
