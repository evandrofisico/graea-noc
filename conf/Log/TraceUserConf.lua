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
	-- dbdriver = 'sqlite3',
	-- dbpath = '/usr/share/hecate-dash/data/traceuser.sqlite',
	dbdriver = 'postgres',
	dbserver = 'dbhomolog02.evandrofisi.co',
	dbuser   = 'user_hecate',
	dbpass   = 'user_hecate',
	dbname   = 'bd_hecate',
}

return conf
