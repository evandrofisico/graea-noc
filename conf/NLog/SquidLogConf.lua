local conf = {
	-- persistent database
	--dbpath = ':memory:',
	dbpath = '/home/evandro.rodrigues/graea/data/squidstat.sqlite',
	-- time to live of the gathered data (in seconds)
	age = 15*60*60,
	-- data tree name
	subtree = 'squidstats',
	tree = 'data:',
}

return conf
