<?php
/*
 +-------------------------------------------------------------------------+
 | Copyright (C) 2004-2008 The Cacti Group                                 |
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
 | Cacti: The Complete RRDTool-based Graphing Solution                     |
 +-------------------------------------------------------------------------+
 | This code is designed, written, and maintained by the Cacti Group. See  |
 | about.php and/or the AUTHORS file for specific developer information.   |
 +-------------------------------------------------------------------------+
 | http://www.cacti.net/                                                   |
 +-------------------------------------------------------------------------+
*/

$guest_account = true;
/* since we'll have additional headers, tell php when to flush them */
ob_start();
// para instalar, copiar para /usr/share/cacti/site/ e
// adicionar em global_arrays
// include/global_arrays.php:      "graph_xport_json.php" => 7,


include("./include/auth.php");
include_once("./lib/rrd.php");

/* ================= input validation ================= */
input_validate_input_number(get_request_var("graph_start"));
input_validate_input_number(get_request_var("graph_end"));
input_validate_input_number(get_request_var("graph_height"));
input_validate_input_number(get_request_var("graph_width"));
input_validate_input_number(get_request_var("local_graph_id"));
input_validate_input_number(get_request_var("rra_id"));
/* ==================================================== */

/* flush the headers now */
ob_end_clean();

session_write_close();

$graph_data_array = array();

/* override: graph start time (unix time) */
if (!empty($_GET["graph_start"]) && $_GET["graph_start"] < 1600000000) {
	$graph_data_array["graph_start"] = $_GET["graph_start"];
}

/* override: graph end time (unix time) */
if (!empty($_GET["graph_end"]) && $_GET["graph_end"] < 1600000000) {
	$graph_data_array["graph_end"] = $_GET["graph_end"];
}

/* override: graph height (in pixels) */
if (!empty($_GET["graph_height"]) && $_GET["graph_height"] < 3000) {
	$graph_data_array["graph_height"] = $_GET["graph_height"];
}

/* override: graph width (in pixels) */
if (!empty($_GET["graph_width"]) && $_GET["graph_width"] < 3000) {
	$graph_data_array["graph_width"] = $_GET["graph_width"];
}

/* override: skip drawing the legend? */
if (!empty($_GET["graph_nolegend"])) {
	$graph_data_array["graph_nolegend"] = $_GET["graph_nolegend"];
}

/* print RRDTool graph source? */
if (!empty($_GET["show_source"])) {
	$graph_data_array["print_source"] = $_GET["show_source"];
}

// test exporting in the most stupid possible way
//$graph_data_array["export"] = true;
//$graph_data_array["print_source"] = true;

$graph_info = db_fetch_row("SELECT * FROM graph_templates_graph WHERE local_graph_id='" . $_REQUEST["local_graph_id"] . "'");

/* for bandwidth, NThPercentile */
$xport_meta = array();

/* Get graph export */
//$xport_array = rrdtool_function_xport($_GET["local_graph_id"], $_GET["rra_id"], $graph_data_array, $xport_meta);
//$jsondata = json_encode(rrdtool_function_xport($_GET["local_graph_id"], $_GET["rra_id"], $graph_data_array, $xport_meta));
$data_array= @rrdtool_function_xport($_GET["local_graph_id"], $_GET["rra_id"], $graph_data_array, $xport_meta);

$json_array = array();

$json_array["meta"] = $data_array["meta"];
/*
 * Now, get to treat data to build a simpler json
 * structure:
 * [meta]
 * [datasets]-> array de arrays
 * 	[0]->	colname
 * 		maxval
 * 		minval
 * 		average
 * 		data-> array com chave = tempo, valor = dado
 */
// set on the meta array the global max value
$maxarray = array();
$minarray = array();

// building datasets array
foreach($data_array["meta"]["legend"] as $colname => $coldata){
	
	$json_array["datasets"][$coldata]["avg"] = 0;
	foreach($data_array["data"] as $i => $darray){
		if( $darray[$colname] == "NaN"){
			$json_array["datasets"][$coldata]["data"][$darray["timestamp"]] = 0;
		} else {
			$json_array["datasets"][$coldata]["data"][$darray["timestamp"]] = $darray[$colname];
			$json_array["datasets"][$coldata]["cur"] = $darray[$colname];
		}
		$json_array["datasets"][$coldata]["avg"] += ($darray[$colname])/$data_array["meta"]["rows"];
	}
	$json_array["datasets"][$coldata]["max"] = max($json_array["datasets"][$coldata]["data"]);
	$json_array["datasets"][$coldata]["min"] = min($json_array["datasets"][$coldata]["data"]);
	$json_array["datasets"][$coldata]["name"] = $colname;
	$maxarray[] = $json_array["datasets"][$coldata]["max"];
	$minarray[] = $json_array["datasets"][$coldata]["min"];
	if(isset($_GET['simplemode'])){
		unset($json_array["datasets"][$coldata]["data"]);
	}
}

$json_array["meta"]["globalmin"] = min($maxarray);
$json_array["meta"]["globalmax"] = max($maxarray);

print(json_encode($json_array));

/* log the memory usage */
if (read_config_option("log_verbosity") >= POLLER_VERBOSITY_MEDIUM) {
	cacti_log("The Peak Graph XPORT Memory Usage was '" . memory_get_peak_usage() . "'", FALSE, "WEBUI");
}

?>
