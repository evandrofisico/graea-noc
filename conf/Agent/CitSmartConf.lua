local citismartloaderconf = {
	-- time to live of the gathered data (in seconds)
	age = 2592000,
	-- periodicity of hitting the database with queries (in seconds)
	period = 120,
	memcserver = 'localhost',
	-- zabbix server configuration
	dbserver = 'citdb.evandrofisi.co',
	dbuser = 'user_citsmart',
	dbpass = 'password',
	dbname = 'bd_citsmart',
	query = [[ select
    ss.idsolicitacaoservico as id,
    solic.login as solicitante,
    resp.login as responsavel,
    ss.idprioridade as prioridade, -- de 1 a 5, menor para maior
    ss.prazohh*60*60+ss.prazomm*60 as prazosegundos,
    date_part('epoch',ss.datahorainicio)+3*60*60 as abertura,
    ss.descricao as descricao -- limitado inicialmente para 100 caracteres, se necessáo pode ser alterado
from
    solicitacaoservico ss
    join grupo g on ss.idgrupoatual = g.idgrupo
    join usuario solic on ss.idresponsavel = solic.idusuario
    left join usuario resp on ss.idusuarioresponsavelatual = resp.idusuario
where
    g.idgrupo = %d -- 16 representa o grupo GEASI-NUBAD
    and ss.situacao in ('EmAndamento', 'Reaberta')
order by
    ss.idprioridade,
    ss.datahorainicio;
	]],

	groups = {
		GRPDB = 16,
		GRPSO = 3,
	},


	-- data tree name
	subtree = 'citismart',
	tree = 'data:',
}

return citismartloaderconf
