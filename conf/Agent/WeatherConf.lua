local weatherconf = {
	-- time to live of the gathered data (in seconds)
	age = 2592000,
	-- periodicity of hitting the webserver with requests (in seconds)
	period = 15*60,
	memcserver = 'localhost',
	-- weather data location
	countryc = "br",
	city = "Brasilia",
	apikey = "your_api_key",
	-- data tree name
	subtree = 'weather',
	tree = 'data:',

	Tree = {
		"weather",
	},
}

return weatherconf
