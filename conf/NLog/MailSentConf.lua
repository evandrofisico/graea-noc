local conf = {
	-- persistent database
	dbpath = '/home/evandro.rodrigues/graea/data/mailstat.sql',
	-- time to live of the gathered data (in seconds)
	age = 15*60*60,
	-- memcache server
	memcserver = 'localhost',
	-- data tree name
	subtree = 'mailstats',
	tree = 'data:',
	mydomain = "evandrofisi.co",
}

return conf
