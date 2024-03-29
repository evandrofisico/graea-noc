local weatherIcons = {}

weatherIcons.iconcodeNight = {
[200] = { icocode = "", desc = "wi-storm-showers",},
[201] = { icocode = "", desc = "wi-thunderstorm",},
[202] = { icocode = "", desc = "wi-thunderstorm",},
[210] = { icocode = "", desc = "wi-thunderstorm",},
[211] = { icocode = "", desc = "wi-thunderstorm",},
[212] = { icocode = "", desc = "wi-thunderstorm",},
[221] = { icocode = "", desc = "wi-thunderstorm",},
[230] = { icocode = "", desc = "wi-storm-showers",},
[231] = { icocode = "", desc = "wi-storm-showers",},
[232] = { icocode = "", desc = "wi-storm-showers",},
[300] = { icocode = "  ",  desc = "wi-sprinkle",},
[301] = { icocode = "  ",  desc = "wi-sprinkle",},
[302] = { icocode = "  ",  desc = "wi-sprinkle",},
[310] = { icocode = "  ",  desc = "wi-sprinkle",},
[311] = { icocode = "  ",  desc = "wi-sprinkle",},
[312] = { icocode = "  ",  desc = "wi-sprinkle",},
[313] = { icocode = "  ",  desc = "wi-sprinkle",},
[314] = { icocode = "  ",  desc = "wi-sprinkle",},
[321] = { icocode = "  ",  desc = "wi-sprinkle",},
[500] = { icocode = " ", desc = "wi-rain",},
[501] = { icocode = " ", desc = "wi-rain",},
[502] = { icocode = " ", desc = "wi-rain",},
[503] = { icocode = " ", desc = "wi-rain",},  
[504] = { icocode = " ", desc = "wi-rain",}, 
[511] = { icocode = " ", desc = "wi-rain",}, 
[520] = { icocode = " ", desc = "wi-rain",}, 
[521] = { icocode = " ", desc = "wi-rain",}, 
[522] = { icocode = " ", desc = "wi-rain",}, 
[531] = { icocode = " ", desc = "wi-rain",}, 
[701] = { icocode = "", desc = "wi-night-fog",},
[711] = { icocode = "", desc = "wismoke",},
[721] = { icocode = "", desc = "wi-night-fog",},
[731] = { icocode = "", desc = "wi-night-fog",},
[741] = { icocode = "", desc = "wi-night-fog",},
[751] = { icocode = "", desc = "wi-night-fog",},
[761] = { icocode = "", desc = "wi-night-fog",},
[762] = { icocode = "", desc = "wi-night-fog",},
[771] = { icocode = "", desc = "wi-night-fog",},
[781] = { icocode = "", desc = "wi-night-fog",},
[801] = { icocode = " ", desc="wi-cloudy",},
[802] = { icocode = " ", desc="wi-cloudy",},
[803] = { icocode = " ", desc="wi-cloudy",},
[804] = { icocode = " ", desc="wi-cloudy",},
}


weatherIcons.iconcodeDay = {
[200] = { icocode = "", desc = "wi-storm-showers",},
[201] = { icocode = "", desc = "wi-thunderstorm",},
[202] = { icocode = "", desc = "wi-thunderstorm",},
[210] = { icocode = "", desc = "wi-thunderstorm",},
[211] = { icocode = "", desc = "wi-thunderstorm",},
[212] = { icocode = "", desc = "wi-thunderstorm",},
[221] = { icocode = "", desc = "wi-thunderstorm",},
[230] = { icocode = "", desc = "wi-storm-showers",},
[231] = { icocode = "", desc = "wi-storm-showers",},
[232] = { icocode = "", desc = "wi-storm-showers",},
[300] = { icocode = "",  desc = "wi-sprinkle",},
[301] = { icocode = "",  desc = "wi-sprinkle",},
[302] = { icocode = "",  desc = "wi-sprinkle",},
[310] = { icocode = "",  desc = "wi-sprinkle",},
[311] = { icocode = "",  desc = "wi-sprinkle",},
[312] = { icocode = "",  desc = "wi-sprinkle",},
[313] = { icocode = "",  desc = "wi-sprinkle",},
[314] = { icocode = "",  desc = "wi-sprinkle",},
[321] = { icocode = "",  desc = "wi-sprinkle",},
[500] = { icocode = "", desc = "wi-rain",},
[501] = { icocode = "", desc = "wi-rain",},
[502] = { icocode = "", desc = "wi-rain",},
[503] = { icocode = "", desc = "wi-rain",},  
[504] = { icocode = "", desc = "wi-rain",}, 
[511] = { icocode = "", desc = "wi-rain",}, 
[520] = { icocode = "", desc = "wi-rain",}, 
[521] = { icocode = "", desc = "wi-rain",}, 
[522] = { icocode = "", desc = "wi-rain",}, 
[531] = { icocode = "", desc = "wi-rain",}, 
[711] = { icocode = "", desc = "wismoke",},
[721] = { icocode = "", desc = "wi-fog",},
[731] = { icocode = "", desc = "wi-fog",},
[741] = { icocode = "", desc = "wi-fog",},
[751] = { icocode = "", desc = "wi-fog",},
[761] = { icocode = "", desc = "wi-fog",},
[762] = { icocode = "", desc = "wi-fog",},
[771] = { icocode = "", desc = "wi-fog",},
[781] = { icocode = "", desc = "wi-fog",},
[801] = { icocode = " ", desc="wi-cloudy",},
[802] = { icocode = " ", desc="wi-cloudy",},
[803] = { icocode = " ", desc="wi-cloudy",},
[804] = { icocode = " ", desc="wi-cloudy",},
}


weatherIcons.phase = {
[0] = new,
[1] = old,
[2] = waning_crescent,
[3] = waning_quarter,
[4] = waning_gibbous,
[5] = full,
[6] = waxing_gibbous,
[7] = waxing_quarter,
[8] = waxing_crescent,
[9] = young,
}

weatherIcons.sunny = " "
-- moon
weatherIcons.moonIcons = {
new="",
old="",
waning_crescent="",
waning_quarter="",
waning_gibbous="",
full="",
waxing_gibbous="",
waxing_quarter="",
waxing_crescent="",
young="",
}



return weatherIcons
