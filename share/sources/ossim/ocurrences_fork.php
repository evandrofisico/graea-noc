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


ini_set('memory_limit', '1024M');
set_time_limit(300);

//require_once 'av_init.php';
require_once '../widget_common.php';
require_once 'common.php';

//Session::logcheck("dashboard-menu", "IPReputation");

$reputation = new Reputation();
$type       = GET("type");
$id	= GET("id");

//$rep_file = trim(`grep "reputation" /etc/ossim/server/config.xml | perl -npe 's/.*\"(.*)\".*/$1/'`);

if ($reputation->existReputation()) 
{
	list($ips, $cou, $order, $total) = $reputation->get_data($id);


	if ($type == "ocurrences") {
		$data  = array();
		$order = array_splice($order,0,10);
		foreach($order as $type => $ocurrences) 
		{
			$data[$type] = $ocurrences;
		}
        	print(json_encode($data));
	}
	elseif($type == "country") {
		$country = array();
		$cou = array_splice($cou, 0, 10);			
		foreach ($cou as $c => $value)
		{ 
			$info = explode(";", $c);

			if ($info[1] != '') 
			{
				$country[$info[1]] = $value;
			}
		}
        print(json_encode($country));
	}
}
else
{
	print("no data available");
}
?>
