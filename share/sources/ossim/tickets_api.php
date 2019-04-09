<?php
/**
*
* License:
*
* Copyright (c) 2003-2006 ossim.net
* Copyright (c) 2007-2013 AlienVault
* All rights reserved.
*
* This package is free software; you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation; version 2 dated June, 1991.
* You may not use, modify or distribute this program under any other version
* of the GNU General Public License.
*
* This package is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this package; if not, write to the Free Software
* Foundation, Inc., 51 Franklin St, Fifth Floor, Boston,
* MA  02110-1301  USA
*
*
* On Debian GNU/Linux systems, the complete text of the GNU General
* Public License can be found in `/usr/share/common-licenses/GPL-2'.
*
* Otherwise you can read it here: http://www.gnu.org/licenses/gpl-2.0.txt
*
*/
require_once 'av_init.php';


require_once '../widget_common.php';


//Checking if we have permissions to go through this section

//Session::logcheck("dashboard-menu", "ControlPanelExecutive");
//Session::logcheck("analysis-menu", "IncidentsIncidents");

//End of permissions		
		
		
//Setting DB connection			
$db    = new ossim_db();
$conn  = $db->connect();

//Getting the current user
//$user  = Session::get_session_user();
$user = GET("user");
$id    = GET("id");

//This is the type of security widget.
$type  = GET("type");

if (ossim_error()) 
{
    die(ossim_error());
}
// //echo "<pre>";
// //print_r($user);
// //echo "</pre>";

/* 
2014-12-29 gambiarra extra-horrenda

	Como o código original supõe que o usuário está logado para acessar dentro da sessão uma lista, temos 2 opções:
	1) Copiar o codigo que faz a busca de usuarios de dentro da classe Incident para ignorar esta restrição
	   e fazer todos os acessos com a permissão de administrador

	2) Injetar uma sessão com permissões adequadas

	Como uma das coisas que seria bem legar ter de dentro do alienvault é a lista de usuários, vamos pelo caminho 1 inicialmente

2015-02-04 documentando gambiarra

	Além deste arquivo, apenas uma linha e alterada no resto do sistema, no arquivo
	/usr/share/ossim/include/classes/incident.inc, onde é chamado
        $user_list = self::get_allowed_users($conn, $user);//Users that I can view their tickets
	alterar para:
        $user_list = static::get_allowed_users($conn, $user);//Users that I can view their tickets

	Esta alteração permite que nossa função chame a versão alterada do método ao invez
	da versão original, que usa sessões para verificar lista de usuários.
*/


class IncidentFork extends Incident
{

   public function get_all_users($conn)
   {
        //PERMS
        $user_list         = array();

	$query = "select login from users";
    	$rs = $conn->Execute($query);

        while (!$rs->EOF)
        {	
            $user_list[] = $rs->fields['login'];
            
            $rs->MoveNext();
        }   
        return $user_list;
   }

    public function get_allowed_users($conn, $user_t)
    {
        $list    = array();

        $pro     = Session::is_pro();
        $myself  = 'admin';

        //PERMS
        $user_perms         = array();

	$query = "select login from users";
    	$rs = $conn->Execute($query);

        while (!$rs->EOF)
        {	
            $user_perms[$rs->fields['login']] = $rs->fields['login'];
            
            $rs->MoveNext();
        }   
        
        $entities_to_assign = Session::get_entities_to_assign($conn);

        if (empty($user_perms[$myself]))
        { 
            $user_perms[$myself]=$myself;
        } // add myself

        //Admin or all assets
        if (empty($user_t) || Session::is_admin($conn, $user_t))
        {
            return $user_perms;
        }
        
        if (!$pro)
        {
            if(!empty($user_perms))
            {
                return array_intersect($user_perms, array($user_t => $user_t));
            } 
            else
            {
                return array($user_t => $user_t);
            }
        }


        //Entity
        if (valid_hex32($user_t))
        {
            $list               = Acl::get_all_users_by_entity($conn, $user_t);
            $my_entities_childs = Acl::get_entity_childs($conn, $user_t);
            
            if (is_array($my_entities_childs))
            {
                foreach ($my_entities_childs as $entity_id)
                {
                    $list[$entity_id] = $entity_id;
                }
            }
        }
        else
        {
            // Entity Admin
            if (Acl::is_proadmin($conn, $user_t))
            {
                //Get my brothers

                $list = Acl::get_brothers($conn, $user_t);

                $my_entities = Acl::get_my_entities($conn, $user_t, FALSE);

                if (is_array($my_entities) && !empty($my_entities))
                {
                    foreach ($my_entities as $k => $v)
                    {
                        $list[$k] = $k;
                        foreach ($v['children'] as $child_e)
                        {
                            //Users child entity
                            $list[$child_e] = $child_e;
                            $entity_users = Acl::get_users_by_entity($conn, $child_e);

                            foreach ($entity_users as $e_users)
                            {
                                $list[$e_users['login']] = $e_users['login'];
                            }
                        }
                    }
                }
            }
            else
            {
                $my_entities = Acl::get_my_entities($conn, $user_t, FALSE);

                if(is_array($my_entities))
                {
                    foreach($my_entities as $id => $entity)
                    {
                        $list[$id] = $id;
                    }
                }
            }
        }

        $list[$user_t] = $user_t;

        if(!empty($user_perms) && !empty($list))
        {
            return array_intersect($user_perms, $list);
        }
        elseif(!empty($user_perms))
        {
            return $user_perms;
        }
        else
        {
            return $list;
        }
    }
}

$assets = array();

/*
*
*	The code below is copied from /panel and will have to be adapted to the new DB structutre of the 4.0 version, that's why it is not commented.
*
*/
session_write_close();
//Now the widget's data will be calculated depending of the widget's type. 
$returndata = array();
switch($type)
{
	case 'ticketStatus':    
		$returndata = IncidentFork::incidents_by_status($conn, $assets, $user);
		break;
		
        case 'ticketStatusAll':
  	        $userlist = IncidentFork::get_all_users($conn);
		foreach($userlist as $user) {
			$returndata[$user] = IncidentFork::incidents_by_status($conn, $assets, $user);
		}
		break;

	case 'ticketResolutionTime':
		
		$ttl_groups = array();
						
		$list       = IncidentFork::incidents_by_resolution_time($conn, $assets, $user);                
		$ttl_groups = array("1"=>0, "2"=>0, "3"=>0, "4"=>0, "5"=>0, "6"=>0);
		
		$total_days = 0;
		$day_count  = null;
						
		foreach ($list as $incident) 
		{
			$ttl_secs    = $incident->get_life_time('s');
			$days        = round($ttl_secs/60/60/24);
			$total_days += $days;
			$ay_count++;
			
			if ($days < 1) 
			{
			    $days = 1;
			}
			
			if ($days > 6) 
			{
			$days = 6;
			}

			@$ttl_groups[$days]++;
		}
		
		$label  = array( Util::html_entities2utf8(_("1 Day")),
		                 Util::html_entities2utf8(_("2 Days")),
		                 Util::html_entities2utf8(_("3 Days")),
		                 Util::html_entities2utf8(_("4 Days")),
		                 Util::html_entities2utf8(_("5 Days")),
		                 Util::html_entities2utf8(_("6+ Days"))
                        );
		
		for ($i=1;$i<7;$i++){
			$returndata[ $label[$i] ] =  $ttl_groups[$i];
		}
		
		break;
		
		
	case 'ticketsByPriority':                
					
		$list = IncidentFork::incidents_by_priority($conn, $assets, $user);							

		if (is_array($list) && !empty($list)) 
		{
			foreach ($list as $priority => $v) 
			{
				if ($v > 0)
				{
					$returndata[$priority ] =  $v;
				}
			}
		}
		break;
}

$db->close();
print(json_encode($returndata)."\n");
print_r($data);
