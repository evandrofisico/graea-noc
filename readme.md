#Graea Network Operation center (NOC) Display system

Have you ever seen those big displays on fancy network operation centers, monitoring datacenters, especially on movies? This is an open source set of data aggregators and display widgets. The included configuration files are used to extract data from [Zabbix](https://www.zabbix.com/), [Alienvault](https://www.alienvault.com/) (after some patching) and logs streamed through syslog.

The purpose of the Graea agreggator system is to aquire, organize and display information that is critical to an network support/DevOps team. As such, it can agreggate and format information from different sources, like monitoring systems such as Zabbix and nagios, SIEMs such as AlienVault and more.

The system is designed to be modular, with multiple possible visualization plattforms. Currently, the only production level visualization plattform is by using [conky](https://github.com/brndnmtthws/conky).

## Source Structure

The source is structured as follows:

On the root directory, there are followinf folders:

* data: location of sqlite databases used by data aquiring plugins
* datadaemon: executable/configuration files for the data aquiring daemon
* etc: configuration data/inicialization scripts for the visualization widgets
* lib: source code for the datadaemon and visualization plugins, plus themes
* share: data files (images, countries flags and source code to "glue" APIs to extract data


# Architeture:

The system is designed to be composed of modules, each with a different kind of purpose:
* Data viewing modules:
 * conky visualization widgets
* Data gathering modules:
 * Agent modules, actively connect to data sources through REST APIs, webservices, databases or even scrappers, runs on top of (luajit2)[http://luajit.org]
 * Log and NLog modules, parse and generate statistics from syslog messages, depends on (syslogintr)[https://github.com/spc476/syslogintr]

## Cache
As each of those modules is run on different threads and even machines, we use memcached as message cache. Each value is recorded on a key/value structure, starting with the prefix 'data:'.
A plugin register a namespace, and all of its data is on a tree with the namespace as the trunk. 
For example, the zabbix plugin registers the zabbix namespace, and each server group is one sub-branch. If you register the plugin to gather data of a group called postgres, containing servers dev01, dev02 and prod01,data for each of the servers could be accessed by the key
```
data:zabbix.postgres.dev01
data:zabbix.postgres.dev02
data:zabbix.postgres.prod01
```
and each item as a subkey.

The plugins can also record a json structure, and our current loader, EventLoader, can distinguish between plain text and json, and when retrieving from the server produces a table with the correct structure.
Along with the cache, plugins can also use permanent data storage by using sqlite3 databases located on data/ using the luasql module.

## Widgets:

The data visualisation is made by using a set of widgets, each designed for a different kind of data. The widget modules reside in lib/view

* BigMessage: Large message, occupying the whole screen and playing a sound related to the event level
* ClockWidget: Clock, with circular hand indicators and a weather indicator line
* DrawText: Basic library for drawing text in a selected font/size/orientation. Used by all other widgets
* Graph: Simple bar/line graph library
* Label: The largest widget, used to plot a box with an indicator line on the side with multiple kinds of information display, such as:
 * imageGraph: box containing one image, a title and a value
 * textWidget: two lines of text, one as a title and one as a description
 * singleGraph: box with a title and a bargraph to show a percentage of a value
 * dualGraph: like singleGraph, but with two bargraphs
* ListItem: Bullet points list, with each line containing a name and a value pair
* Mapa: Country map with labels indicating information about a location status
* MultiGauge: multiple gauge-like indicators
* PieChart: Hollow centered piechart-like widget, with a ListItem on the side to show values
* SquareCloud: Much like the Label, with a grid like layout, but with the purpose to show larger amounts of itens, each with a circle indicating a percentage of use of some resource (available memory, network use, etc)
* weatherIcons: simple table to map unicode glyphs used on our weather font

# Data Loaders:


