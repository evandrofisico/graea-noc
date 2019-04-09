local zabbixloaderconf = {
	-- time to live of the gathered data (in seconds)
	age = 2592000,
	-- periodicity of hitting the webserver with requests (in seconds)
	period = 60,
	-- period = 5*60,
	memcserver = 'localhost',
	-- zabbix server configuration
	zserver = 'http://zabbix.evandrofisi.co',
	zuser = 'zabbix',
	zpass = 'zabbix',
	-- data tree name
	subtree = 'zabbix',
	tree = 'data:',
	allnodes = 'allnodes',
	issuesbranch = 'issues',
	--[[ 	We only gather data from a few selected groups,
		otherwise the zabbix server usually gets overloaded.
		As such, we define a table of all of the necessary
		zabbix groups.
	--]]
	allhostsgroup = 'Matriz-Geral',
	groups = {
		{
			name = "Nuvens",
			itens = {
				net = { inbound = "net.if.in[bond0]", outbound = "net.if.out[bond0]"},
				cpu = { load = "system.cpu.load[percpu,avg15]", idle = "system.cpu.util[,idle]",},
				mem = { free  = "vm.memory.size[pavailable]", },
			},
		},
		{
			name = "matrizVirtuais",
			itens = {
				net = { inbound = "net.if.in[eth0]", outbound = "net.if.out[eth0]"},
				cpu = { load = "system.cpu.load[percpu,avg15]", idle = "system.cpu.util[,idle]",},
				mem = { free  = "vm.memory.size[pavailable]", },
			},
		},
		{
			name = "Alienvault",
			itens = {
				net = { inbound = "net.if.in[eth0]", outbound = "net.if.out[eth0]"},
				cpu = { load = "system.cpu.load[percpu,avg15]", idle = "system.cpu.util[,idle]",},
				mem = { free  = "vm.memory.size[pavailable]", },
			},
		},
		{
			name = "ServidoresUA",
			itens = {
				avail = { ping = "agent.ping", icmpping = "icmpping[,5,4000,,4000]", },
				net = { inbound = "net.if.in[eth0]", outbound = "net.if.out[eth0]"},
				cpu = { load = "system.cpu.load[percpu,avg15]", idle = "system.cpu.util[,idle]",},
				mem = { free  = "vm.memory.size[pavailable]", },
			},
		},
		{
			name = "GrupoMysqlSQLProd",
			itens = {
				avail = { ping = "agent.ping", icmpping = "icmpping[,5,4000,,4000]", },
				net = { inbound = "net.if.in[eth0]", outbound = "net.if.out[eth0]"},
				cpu = { load = "system.cpu.load[percpu,avg15]", idle = "system.cpu.util[,idle]",},
				mem = { free  = "vm.memory.size[pavailable]", },
				disk = { 
					root = "vfs.fs.size[/,pfree]",
					},
			},
		},
		{
			name = "GrupoOracleProd",
			itens = {
				avail = { ping = "agent.ping", icmpping = "icmpping[,5,4000,,4000]", },
				net = { inbound = "net.if.in[eth0]", outbound = "net.if.out[eth0]"},
				cpu = { load = "system.cpu.load[percpu,avg15]", idle = "system.cpu.util[,idle]",},
				mem = { free  = "vm.memory.size[pavailable]", },
				disk = { 
					root = "vfs.fs.size[/,pfree]",
					},
			},
		},
		{
			name = "GrupoPostgreSQLDev",
			itens = {
				pgsql = { 
					procnum = "proc.num[,,,postgres]",
					isrunning = "psql.running[{$PGHOST},{$PGPORT},{$PGROLE},{$PGDATABASE}]",
					conn = "psql.active_connections[{$PGHOST},{$PGPORT},{$PGROLE},{$PGDATABASE}]",
					slowq = "psql.slow_queries[{$PGHOST},{$PGPORT},{$PGROLE},{$PGDATABASE},{$PGSLOWQUERY_THRESHOLD}]",
				},
				--pgsql = { running = "psql.running[{$PGHOST},{$PGPORT},{$PGROLE},{$PGDATABASE}]" , },
				avail = { ping = "agent.ping", icmpping = "icmpping[,5,4000,,4000]", },
				net = { inbound = "net.if.in[eth0]", outbound = "net.if.out[eth0]"},
				cpu = { load = "system.cpu.load[percpu,avg15]", idle = "system.cpu.util[,idle]",},
				mem = { free  = "vm.memory.size[pavailable]", },
				disk = { 
					root = "vfs.fs.size[/,pfree]",
					data = "vfs.fs.size[/data,pfree]",
					pg_xlog = "vfs.fs.size[/pg_xlog,pfree]",
					wal = "vfs.fs.inode[/wal,pfree]",
					},
			},
		},
		{
			name = "GrupoPostgreSQL",
			itens = {
				pgsql = { 
					procnum = "proc.num[,,,postgres]",
					isrunning = "psql.running[{$PGHOST},{$PGPORT},{$PGROLE},{$PGDATABASE}]",
					conn = "psql.active_connections[{$PGHOST},{$PGPORT},{$PGROLE},{$PGDATABASE}]",
					slowq = "psql.slow_queries[{$PGHOST},{$PGPORT},{$PGROLE},{$PGDATABASE},{$PGSLOWQUERY_THRESHOLD}]",
				},
				--pgsql = { running = "psql.running[{$PGHOST},{$PGPORT},{$PGROLE},{$PGDATABASE}]" , },
				avail = { ping = "agent.ping", icmpping = "icmpping[,5,4000,,4000]", },
				net = { inbound = "net.if.in[eth0]", outbound = "net.if.out[eth0]"},
				cpu = { load = "system.cpu.load[percpu,avg15]", idle = "system.cpu.util[,idle]",},
				mem = { free  = "vm.memory.size[pavailable]", },
				disk = { 
					root = "vfs.fs.size[/,pfree]",
					data = "vfs.fs.size[/data,pfree]",
					pg_xlog = "vfs.fs.size[/pg_xlog,pfree]",
					wal = "vfs.fs.inode[/wal,pfree]",
					},
			},
		},
		{
			name = "GrupoBancosMatriz",
			itens = {
				avail = { ping = "agent.ping", icmpping = "icmpping[,5,4000,,4000]", },
			},
		},
		{
			name = "GrupoSybaseProd",
			itens = {
				avail = { ping = "agent.ping", icmpping = "icmpping[,5,4000,,4000]", },
				cpu = { load = "system.cpu.load[,avg15]", system = "system.cpu.util[,system]"},
				mem = { free  = "vm.memory.size[pavailable]", },
				disk = { 
					C = "vfs.fs.size[C:,pfree]",
					D = "vfs.fs.size[D:,pfree]",
					E = "vfs.fs.size[E:,pfree]",
					F = "vfs.fs.size[F:,pfree]",
					},
			},
		},
		{
			name = "GrupoSQLServerProd",
			itens = {
				avail = { ping = "agent.ping", icmpping = "icmpping[,5,4000,,4000]", },
				cpu = { load = "system.cpu.load[,avg15]", system = "system.cpu.util[,system]"},
				mem = { free  = "vm.memory.size[pavailable]", },
				disk = { 
					C = "vfs.fs.size[C:,pfree]",
					D = "vfs.fs.size[D:,pfree]",
					E = "vfs.fs.size[E:,pfree]",
					F = "vfs.fs.size[F:,pfree]",
					},
			},
		},
		{
			name = "GrupoSQLServerDev",
			itens = {
				avail = { ping = "agent.ping", icmpping = "icmpping[,5,4000,,4000]", },
				cpu = { load = "system.cpu.load[,avg15]", system = "system.cpu.util[,system]"},
				mem = { free  = "vm.memory.size[pavailable]", },
				disk = { 
					C = "vfs.fs.size[C:,pfree]",
					D = "vfs.fs.size[D:,pfree]",
					E = "vfs.fs.size[E:,pfree]",
					F = "vfs.fs.size[F:,pfree]",
					},
			},
		},
		{
			name = "GrupoPostgreSQLProd",
			itens = {
				pgsql = { 
					procnum = "proc.num[,,,postgres]",
					isrunning = "psql.running[{$PGHOST},{$PGPORT},{$PGROLE},{$PGDATABASE}]",
					conn = "psql.active_connections[{$PGHOST},{$PGPORT},{$PGROLE},{$PGDATABASE}]",
					slowq = "psql.slow_queries[{$PGHOST},{$PGPORT},{$PGROLE},{$PGDATABASE},{$PGSLOWQUERY_THRESHOLD}]",
				},
				--pgsql = { running = "psql.running[{$PGHOST},{$PGPORT},{$PGROLE},{$PGDATABASE}]" , },
				avail = { ping = "agent.ping", icmpping = "icmpping[,5,4000,,4000]", },
				net = { inbound = "net.if.in[eth0]", outbound = "net.if.out[eth0]"},
				cpu = { load = "system.cpu.load[percpu,avg15]", idle = "system.cpu.util[,idle]",},
				mem = { free  = "vm.memory.size[pavailable]", },
				disk = { 
					root = "vfs.fs.size[/,pfree]",
					data = "vfs.fs.size[/data,pfree]",
					pg_xlog = "vfs.fs.size[/pg_xlog,pfree]",
					wal = "vfs.fs.size[/wal,pfree]",
					},
			},
		},
		{
			name = "RoteadoresSUREGS",
			macroexpand = {avail = false, net = true,},
			itens = {
				avail = { icmpping = "icmpping[,5,4000,,4000]", },
				net = { inbound = "ifInOctets[{$LAN_IF}]", outbound = "ifOutOctets[{$LAN_IF}]"},
			},
		},
		{
			name = "RoteadoresUA",
			macroexpand = { avail = false, net = true,},
			itens = {
				avail = { icmpping = "icmpping[,5,4000,,4000]", },
				net = { inbound = "ifInOctets[{$LAN_IF}]", outbound = "ifOutOctets[{$LAN_IF}]"},
			},
		},
		{
			name = "Firewalls",
			itens = {
				net = { 
					eth10_inbound  = "net.if.in[eth10]",  eth10_outbound  = "net.if.out[eth10]",
					eth11_inbound  = "net.if.in[eth11]",  eth11_outbound  = "net.if.out[eth11]",
					eth172_inbound = "net.if.in[eth172]", eth172_outbound = "net.if.out[eth172]",
					eth192_inbound = "net.if.in[eth192]", eth192_outbound = "net.if.out[eth192]",
					eth200_inbound = "net.if.in[eth200]", eth200_outbound = "net.if.out[eth200]",
				},
				cpu = { load = "system.cpu.load[percpu,avg15]", idle = "system.cpu.util[,idle]",},
				mem = { free  = "vm.memory.size[pavailable]", },
			},
		},
	},
}

return zabbixloaderconf
