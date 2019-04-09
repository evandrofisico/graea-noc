local ossimloaderconf = {
	-- time to live of the gathered data (in seconds)
	age = 2592000,
	-- periodicity of hitting the webserver with requests (in seconds)
	period = 60,
	--period = 60*5,
	memcserver = 'localhost',
	-- server configuration
	server  = "https://alienvault.evandrofisi.co/ossim/dashboard/sections/widgets/data/",

	DataSources = {
	 	-- gauges de risco
	 	{ source = 'gauge',		name = "Alarmes",	ltype = "alarm",	id = "52",},
	 	{ source = 'gauge',		name = "Risco",		ltype = "threat",	id = "53",},
	 	{ source = 'gauge',		name = "Ticket",	ltype = "ticket",	id = "54",},
	 	-- contagem de eventos
	 	{ source = "event",		name = "product",	ltype = "source_type",	id = "5",},
	 	{ source = "event",		name = "category",	ltype = "category",	id = "6",},
	 	-- contagem de ocorrencias
	 	{ source = "ocurrences",	name = "ocurrences",	ltype = "ocurrences",	id = "1",},
	 	{ source = "ocurrences",	name = "country",	ltype = "country",	id = "1",},
		-- contagem de tickets
		{ source = 'tickets',		name = "users",		ltype = 'ticketStatusAll',	id = '7',},
		-- -- lista de sensores/servidores
		-- { source = 'nodes',		name = 'nodes',},
		-- veeeeerus
		{ source = 'taxonomy',		name = 'virus',		ltype = 'virus',		id = '48',},
	},

	-- data tree name
	subtree = 'siem',
	tree = 'data:',
}
return ossimloaderconf
