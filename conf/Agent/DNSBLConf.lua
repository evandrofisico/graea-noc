local weatherconf = {
	-- time to live of the gathered data (in seconds)
	age = 2592000,
	-- periodicity of hitting the dns server with requests (in seconds)
	--period = 10,
	period = 60,
	memcserver = 'localhost',
	-- DNSBL providers
	reputation = "score.senderscore.com",
	dnsbl = {
		"all.s5h.net",
		"b.barracudacentral.org",
		"bl.emailbasura.org",
		"bl.spamcannibal.org",
		"bl.spamcop.net",
		"blackholes.easynet.nl",
		"blackholes.five-ten-sg.com",
		"blacklist.woody.ch",
		"bogons.cymru.com",
		"cbl.abuseat.org",
		"cdl.anti-spam.org.cn",
		"combined.abuse.ch",
		"combined.rbl.msrbl.net",
		"db.wpbl.info",
		"dnsbl-1.uceprotect.net",
		"dnsbl-2.uceprotect.net",
		"dnsbl-3.uceprotect.net",
		"dnsbl.anticaptcha.net",
		"dnsbl.cyberlogic.net",
		"dnsbl.inps.de",
		"dnsbl.sorbs.net",
		"drone.abuse.ch",
		"duinv.aupads.org",
		"dul.dnsbl.sorbs.net",
		"dyna.spamrats.com",
		"dynip.rothen.com",
		"exitnodes.tor.dnsbl.sectoor.de",
		"http.dnsbl.sorbs.net",
		"images.rbl.msrbl.net",
		"ips.backscatterer.org",
		"ix.dnsbl.manitu.net",
		"korea.services.net",
		"misc.dnsbl.sorbs.net",
		"noptr.spamrats.com",
		"orvedb.aupads.org",
		"pbl.spamhaus.org",
		"phishing.rbl.msrbl.net",
		"proxy.bl.gweep.ca",
		"psbl.surriel.com",
		"rbl.interserver.net",
		"rbl.megarbl.net",
		"relays.bl.gweep.ca",
		"relays.bl.kundenserver.de",
		"relays.nether.net",
		"sbl.spamhaus.org",
		"sbl.spamhaus.org",
		"short.rbl.jp",
		"smtp.dnsbl.sorbs.net",
		"socks.dnsbl.sorbs.net",
		"spam.abuse.ch",
		"spam.rbl.msrbl.net",
		"spam.spamrats.com",
		"spamrbl.imp.ch",
		"ubl.lashback.com",
		"ubl.unsubscore.com",
		"virbl.bit.nl",
		"virus.rbl.jp",
		"virus.rbl.msrbl.net",
		"web.dnsbl.sorbs.net",
		"wormrbl.imp.ch",
		"xbl.spamhaus.org",
		"zen.spamhaus.org",
		"zombie.dnsbl.sorbs.net",
		"dnsblchile.org",
		"fulldom.rfc-clueless.org",
		"whois.rfc-clueless.org",
		"db.wpbl.info",
		"dnsbl-1.uceprotect.net",
		"all.s5h.net",
		"bl.fmb.la",
		"blacklist.woody.ch",
		--"hostkarma.junkemailfilter.com",
		"spam.dnsbl.anonmails.de",
		"problems.dnsbl.sorbs.net",
		"safe.dnsbl.sorbs.net",
		"spam.dnsbl.sorbs.net",
		--"recent.spam.dnsbl.sorbs.net",
		--"new.spam.dnsbl.sorbs.net",
		--"old.spam.dnsbl.sorbs.net",
		"bad.psky.me",
	},
	-- ip to check
	checkip = { '200.198.220.103',},
	-- checkip = { '200.198.220.103', '200.198.220.111',},
	-- data tree name
	subtree = 'dnsbl',
	tree = 'data:',
	Tree = {
		dnsbl = {
			"dns",
			"log",
			"reputation",
		},
	},
}

return weatherconf