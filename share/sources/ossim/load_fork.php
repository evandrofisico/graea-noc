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


// gambiarra: para instalar, copiar
// em 
// /usr/share/ossim/www/dashboard/sections/widgets/data/

require_once 'av_init.php';



require_once '../widget_common.php';
require_once 'common.php';

    $db       = new ossim_db();
    $conn     = $db->connect();
    $avc_list = Av_center::get_avc_list($conn);
    
    $db->close();
    
    if ($avc_list['status'] == 'error')
    {
        echo "error###"._("Error retrieving Alienvault Component");
        exit();
    }
    
    //Get Information (Status, RAM Usage, SWAP Usage and CPU Usage)
    $path = Av_center::$base_path."/regdir/*/system_status";    
    $ret     = 0;
    
    $command = 'grep -rH "percent_\|cpu=\|status=" '.$path.' | sed -e \'s/:/\//\' | cut -d "/" -f 6,8';
            
    exec ($command, $output, $ret);
    
    if ($ret !== 0)
    {
        echo "error###"._('Error retrieving Alienvault Component');
        exit();
    }
    
    $output_data = array();
    foreach ($output as $data)
    {
        $data   = explode('/', $data);
        $values = explode('=', $data[1]);
        
        $uuid  = trim($data[0]);
        $field = trim($values[0]);
                
        $output_data[$uuid][$field] = trim($values[1]);
    }

	foreach ($avc_list["data"] as $id => $hostdata){
        	$output_data[$id]["hostname"] = $hostdata["hostname"];
	}
    
	print(json_encode($output_data));
?>
