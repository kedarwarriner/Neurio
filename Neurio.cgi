#!/usr/bin/perl
use strict;
use My_Config;
use Device::Neurio;
use Device::NeurioTools;
use Data::Dumper;

my $my_Neurio = Device::Neurio->new($key,$secret,$sensor_id);  #$key, $secret and $sensor_id come from My_Config.pm

$my_Neurio->connect();

my $my_NeurioTools = Device::NeurioTools->new($my_Neurio);

$my_NeurioTools->set_ISO8601_timezone();
$my_NeurioTools->set_flat_rate(0.08);

my $startdate      = $my_NeurioTools->get_ISO8601_date(eval(time()-86400))."T"."00:00:00-04:00";
my $enddate        = $my_NeurioTools->get_ISO8601(eval(time()-86400));
my $cost_yesterday = sprintf("%2.2f",$my_NeurioTools->get_flat_cost($startdate,"minutes",$enddate,"5","500","1"));

my $startdate      = $my_NeurioTools->get_ISO8601_date(time())."T"."00:00:00-04:00";
my $enddate        = $my_NeurioTools->get_ISO8601_date(time())."T".$my_NeurioTools->get_ISO8601_time(time());
my $cost_today     = sprintf("%2.2f",$my_NeurioTools->get_flat_cost($startdate,"minutes",$enddate,"5","500","1"));

print "Content-type: text/html\n\n";
print "<html><head>\n";
print "  <title>Power cost comparisson</title>\n";
print "</HEAD><body>\n";
print "<pre>\n";
print "         Yesterday our electriciy from midnight until ".$my_NeurioTools->get_ISO8601_time(time())." had cost us <b><font size=4>\$$cost_yesterday</font></b><br>\n";
print "             Today our electriciy from midnight until ".$my_NeurioTools->get_ISO8601_time(time())." has cost us <b><font size=4>\$$cost_today</b></font><br>\n";
print "</pre>\n";
print "</body></HTML>\n";

undef $my_NeurioTools;
undef $my_Neurio;


