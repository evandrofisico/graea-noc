local conf = {
	-- persistent database
	dbpath = '/home/evandro.rodrigues/graea/data/spamstat.sql',
	-- time to live of the gathered data (in seconds)
	age = 15*60*60,
	-- data tree name
	-- memcache server
	memcserver = 'localhost',
	subtree = 'spamstats',
	tree = 'data:',
}

return conf
