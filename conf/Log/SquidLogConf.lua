local conf = {
	-- persistent database
	--dbpath = ':memory:',
	dbpath = '/home/evandro.rodrigues/graea/data/squidstat.sqlite',
	-- time to live of the gathered data (in seconds)
	age = 15*60*60,
	-- periodicity of hitting the webserver with requests (in seconds)
	period = 60,
	-- memcache server
	-- memcserver = 'janus.evandrofisi.co',
	memcserver = 'localhost',
	-- data tree name
	subtree = 'squidstats',
	tree = 'data:',
}

return conf
