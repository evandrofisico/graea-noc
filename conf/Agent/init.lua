local datadaemonconf = {
	tree = "data:",
	memcserver = 'memcache.evandrofisi.co',
	plugins = { 
			'Bacula', -- load data from bacula web
			'CitSmart', -- load tickets from citsmart system
			'Ossim', -- load data from makeshift ossim/alienvault 'API'
			'Virttool', -- load data from virttool and libvirt
			'Zabbix',  -- load data from a zabbix server
			'DNSBL', -- load blacklist data from dns servers
			'Weather', -- load weather data from openweathermap.org
	},
	sleep = 30,
}
return datadaemonconf
