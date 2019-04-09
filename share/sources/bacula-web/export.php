<?php
/*
  +-------------------------------------------------------------------------+
  | Copyright (C) 2004 Juan Luis Frances Jimenez						    |
  | Copyright 2010-2013, Davide Franco			                            |
  |                                                                         |
  | This program is free software; you can redistribute it and/or           |
  | modify it under the terms of the GNU General Public License             |
  | as published by the Free Software Foundation; either version 2          |
  | of the License, or (at your option) any later version.                  |
  |                                                                         |
  | This program is distributed in the hope that it will be useful,         |
  | but WITHOUT ANY WARRANTY; without even the implied warranty of          |
  | MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           |
  | GNU General Public License for more details.                            |
  +-------------------------------------------------------------------------+
 */
session_start();
include_once( 'core/global.inc.php' );

// Initialise view and model
$view 	= new CView();
$dbSql 	= null;

$dbSql = new Bweb($view);

// Custom period for dashboard
$custom_period = array( LAST_DAY, NOW);		// defautl period is last day
//print_r($_GET);

if($_GET["type"] == "jobs"){
	$jobs_status = array('Running', 'Completed', 'Waiting', 'Failed', 'Canceled');
	$jobs_status_data = array();

	foreach ($jobs_status as $status) {
		$jobs_count 		= Jobs_Model::count_Jobs( $dbSql->db_link, $custom_period, strtolower($status) );
		$jobs_status_data[$status] = $jobs_count;
	}

	print(json_encode($jobs_status_data));
}
elseif($_GET["type"] == "volumes"){
	$volumes = $dbSql->GetVolumeList();
	print(json_encode($volumes));
}

?>
