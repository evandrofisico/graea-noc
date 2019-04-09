local conf = {
	-- time to live of the gathered data (in seconds)
	age = 15*60*60,
	-- periodicity of hitting the webserver with requests (in seconds)
	period = 60,
	-- memcache server
	-- memcserver = 'janus.evandrofisi.co',
	memcserver = 'localhost',
	-- data tree name
	subtree = 'traceuser',
	tree = 'data:',
	-- persistent database
	dbpath = '/home/evandro.rodrigues/graea/data/traceuser.sql',
}

return conf
