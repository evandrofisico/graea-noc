--[[
vamos nessa versao separar a captura de dados do processamento dos dados de log

Ao invez de executar diretamente as funcoes de tratamento de dados, o modulo de log
apenas executa a filtragem das entradas de log e o enfileiramento destas como jobs
em filas do beanstalkd. Assim, parte do codigo executavel que esta presente como
codigo dos plugins passa a ser "codigo de configuracao", se eh que isso faz sentido.


Com isso torna-se possivel isolar o processamento dos logs da analise estatistica
e adicionalmente a arquitetura da aplicacao se torna mais simples, pois ao invez de
uma arquitetura com dependencia em callbacks (estou olhando para voce, node.js) que 
torna mais complexo acompanhar o fluxo do programa, temos um fluxo continuo.

--]]
local datadaemonconf = {
	tree = "data:",
	-- beanstalkd
	bstalkdserver = 'localhost',
	bstalkdport = 11300,
	-- memcached
	memcserver = 'localhost',
	memcport = 11211,

	plugins = { 
		'MailSent', 	
		'SpamStats', 	
	},

	filters = {
		["mailsender postfix/qmgr"] 	= "MailSent",
		["mailreceiver postfix/smtpd"] 	= "SpamStats",
		["mailreceiver amavis"] 		= "SpamStats",
		["mailreceiver opendkim"] 	= "SpamStats",
	},

	matchFilters = {
		["snoopy"] = "snoopy", 
		["sshd"]   = "sshlogon",
	}


}
return datadaemonconf
