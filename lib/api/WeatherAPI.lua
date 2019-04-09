local curl = require('cURL')
local WeatherAPI = { }

setmetatable(WeatherAPI, {
__call = function (cls, ...)
	return cls.new(cls,...)
end,
})

function WeatherAPI:new(conf)
	local p = {}
	p.conf = conf
	-- p.city = city
	-- p.countryc = countryc
	self.__index = self
	self.__call = function (cls, ...)
		return cls.new(cls,...)
	end
	return setmetatable(p, self)
end


function WeatherAPI:getData()
url = "http://api.openweathermap.org/data/2.5/weather?q="..self.conf.city..","..self.conf.countryc.."&APPID=" .. self.conf.apikey
local data = {};
cr = curl.easy_init()
cr:setopt(curl.OPT_URL,url)
cr:setopt_writefunction(
		function(s,len)
        		table.insert(data,s)
        		return true
		end

	)
cr:perform()
cr:close()
return cjson.decode(table.concat(data));
end

return WeatherAPI

--[[
WeatherAPI.conditions = {
200 = { desc = "thunderstorm with light rain",  icon="11d.png", },
201 = { desc = "thunderstorm with rain", icon="11d.png",},
202 = { desc = "thunderstorm with heavy rain", icon="11d.png",},
210 = { desc = "light thunderstorm", icon="11d.png",},
211 = { desc = "thunderstorm", icon="11d.png",},
212 = { desc = "heavy thunderstorm ", icon="11d.png",},
221 = { desc = "ragged thunderstorm ", icon="11d.png",},
230 = { desc = "thunderstorm with light drizzle ", icon="11d.png",},
231 = { desc = "thunderstorm with drizzle ", icon="11d.png",},
232 = { desc = "thunderstorm with heavy drizzle ", icon="11d.png",},
300 = { desc = "light intensity drizzle ", icon="09d.png",},
301 = { desc = "drizzle ", icon="09d.png",},
302 = { desc = "heavy intensity drizzle ", icon="09d.png",},
310 = { desc = "light intensity drizzle rain ", icon="09d.png",},
311 = { desc = "drizzle rain ", icon="09d.png",},
312 = { desc = "heavy intensity drizzle rain ", icon="09d.png",},
313 = { desc = "shower rain and drizzle ", icon="09d.png",},
314 = { desc = "heavy shower rain and drizzle ", icon="09d.png",},
321 = { desc = "shower drizzle ", icon="09d.png",},
500 = { desc = "light rain ", icon="10d.png",},
501 = { desc = "moderate rain ", icon="10d.png",},
502 = { desc = "heavy intensity rain ", icon="10d.png",},
503 = { desc = "very heavy rain ", icon="10d.png",},
504 = { desc = "extreme rain ", icon="10d.png",},
511 = { desc = "freezing rain ", icon="13d.png",},
520 = { desc = "light intensity shower rain ", icon="09d.png",},
521 = { desc = "shower rain ", icon="09d.png",},
522 = { desc = "heavy intensity shower rain ", icon="09d.png",},
531 = { desc = "ragged shower rain ", icon="09d.png",},
600 = { desc = "light snow ", icon="13d.png",},
601 = { desc = "snow ", icon="13d.png",},
602 = { desc = "heavy snow ", icon="13d.png",},
611 = { desc = "sleet ", icon="13d.png",},
612 = { desc = "shower sleet ", icon="13d.png",},
615 = { desc = "light rain and snow ", icon="13d.png",},
616 = { desc = "rain and snow ", icon="13d.png",},
620 = { desc = "light shower snow ", icon="13d.png",},
621 = { desc = "shower snow ", icon="13d.png",},
622 = { desc = "heavy shower snow ", icon="13d.png",},
701 = { desc = "mist ", icon="50d.png",},
711 = { desc = "smoke ", icon="50d.png",},
721 = { desc = "haze ", icon="50d.png",},
731 = { desc = "sand, dust whirls ", icon="50d.png",},
741 = { desc = "fog ", icon="50d.png",},
751 = { desc = "sand ", icon="50d.png",},
761 = { desc = "dust ", icon="50d.png",},
762 = { desc = "volcanic ash ", icon="50d.png",},
771 = { desc = "squalls ", icon="50d.png",},
781 = { desc = "tornado ", icon="50d.png",},
800 = { desc = "clear sky ", icon="01d.png",}, 
801 = { desc = "few clouds ", icon="02d.png",},
802 = { desc = "scattered clouds ", icon="03d.png",}, 
803 = { desc = "broken clouds ", icon="04d.png",},
804 = { desc = "overcast clouds ", icon="04d.png",}, 
900 = { desc = "tornado",},
901 = { desc = "tropical storm",},
902 = { desc = "hurricane",},
903 = { desc = "cold",},
904 = { desc = "hot"},
905 = { desc = "windy",},
906 = { desc = "hail",} 
950 = { desc = "setting",},
951 = { desc = "calm",},
952 = { desc = "light breeze",},
953 = { desc = "gentle breeze",},
954 = { desc = "moderate breeze",},
955 = { desc = "fresh breeze",},
956 = { desc = "strong breeze",},
957 = { desc = "high wind, near gale",},
958 = { desc = "gale",},
959 = { desc = "severe gale",},
960 = { desc = "storm",},
961 = { desc = "violent storm",},
962 = { desc = "hurricane ",},
}
--]]





