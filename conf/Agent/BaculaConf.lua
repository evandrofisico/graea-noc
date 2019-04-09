local baculawebconf = {
	-- time to live of the gathered data (in seconds)
	age = 2592000,
	-- periodicity of hitting the webserver with requests (in seconds)
	period = 60,
	-- memcache server
	memcserver = 'localhost',
	-- server/data source 
	server = "http://bacula01.evandrofisi.co/bacula-web/exportn.php?type=",
	-- data tree name
	subtree = 'backup',
	tree = 'data:',
	Tree = {
		backup = {
			'jobs', 
			'volumes', 
			'pool', 
			'catalog', 
		},
	},
}
return baculawebconf
