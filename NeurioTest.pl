#!/usr/bin/perl
use strict;
use Device::Neurio;
use Device::NeurioTools;
use Device::NeurioTest;
use Text::TabularDisplay;
use HTTP::Date;
use Data::Dumper;


## Global Variables ##
my @results;
my $debug       = 0;                             # if TRUE extra debug printouts shown
my $push        = 1;                             # if TRUE logfile and summary saved to files
my $passed      = 0;                             # number of passed test cases
my $total       = 0;                             # total number of test cases
my $failed      = 0;                             # number of failed test cases
my $defect      = 0;                             # number of failed test cases with an associated defect
my $warning     = 0;                             # number of passed test cases with an associated defect
my $key         = "x2epZB74S9qq2pfy7qOvvw";
my $secret      = "5yWAqQ5iSfmmOO52Pmv7Cw";
my $sensor_id   = "0x0000C47F510180F6";          # Neurio
my $sensor_id   = "0x0013A20040B65FBF";          # powerBlaster
my $location_id = "g3t85OlA6DB8JVETyH5j-3";
my $user_id     = "NnMBNS86Qrmk1aT8eJdpzQ";

my $my_Neurio   = Device::Neurio->new($key,$secret,$sensor_id); 

die "\nFailed to authenticate\n\n" unless $my_Neurio->connect($location_id);

my $my_NeurioTools = Device::NeurioTools->new($my_Neurio,$debug);
my $my_NeurioTest  = Device::NeurioTest->new($my_Neurio,$debug,$push);

$my_Neurio->debug($debug,$my_NeurioTest->{'LOG'});

($my_NeurioTest->{'verions'},$my_NeurioTest->{'build'}) = $my_Neurio->get_version();
$my_NeurioTest->{'start_secs'} = time();
$my_NeurioTest->{'start_time'} = $my_NeurioTest->local_8601();

$my_Neurio->printLOG("<HTML><BODY><PRE>\n");
$my_Neurio->printLOG("###################################################################################\n\n");
$my_Neurio->printLOG("          Automated test script to validate Neurio API calls                       \n\n");
$my_Neurio->printLOG("  API version ".$my_NeurioTest->{'verions'}." and build ".$my_NeurioTest->{'build'}."\n");
$my_Neurio->printLOG("  API Location: ".$my_Neurio->{'base_url'}."                                       \n\n");
$my_Neurio->printLOG("  Test run beginning at: ".$my_NeurioTest->{'start_time'}."                        \n\n");
$my_Neurio->printLOG("###################################################################################\n\n");



test_fetch_User_Positive();
test_fetch_User_Negative();

test_fetch_Samples_Positive(); 
test_fetch_Samples_Negative();
#
test_fetch_Samples_Full_Positive();
test_fetch_Samples_Full_Negative();

test_fetch_Samples_Last_Live_Positive();
test_fetch_Samples_Last_Live_Negative();         # no tests

test_fetch_Samples_Recent_Live_Positive();
test_fetch_Samples_Recent_Live_Negative();

test_fetch_Energy_Stats_Positive();
test_fetch_Energy_Stats_Negative();

test_fetch_Sensor_Positive();
test_fetch_Sensor_Negative();

test_fetch_Sensors_Positive();
test_fetch_Sensors_Negative();

test_fetch_Edge_Positive();
test_fetch_Edge_Negative();

test_fetch_Cycle_Positive();
test_fetch_Cycle_Negative();

test_fetch_FullCycle_Positive();
test_fetch_FullCycle_Negative();

test_fetch_CycleGroup_Positive();
test_fetch_CycleGroup_Negative();

test_fetch_Analytics_Positive();                 # no tests
test_fetch_Analytics_Negative();

test_fetch_Appliance_Positive(); 
test_fetch_Appliance_Negative();

test_fetch_Appliance_Events_By_Location_Positive();
test_fetch_Appliance_Events_By_Location_Negative();

test_fetch_Appliance_Events_By_Appliance_Positive();
test_fetch_Appliance_Events_By_Appliance_Negative();

test_fetch_Appliance_Stats_by_Location_Positive();
test_fetch_Appliance_Stats_by_Location_Negative();

test_fetch_Appliance_Stats_by_Appliance_Positive();
test_fetch_Appliance_Stats_by_Appliance_Negative();

test_fetch_Appliance_Recent_Events_By_Location_Positive();
test_fetch_Appliance_Recent_Events_By_Location_Negative();

test_fetch_Appliance_Specs_Positive();
test_fetch_Appliance_Specs_Negative();           # no tests

test_fetch_Appliance_Status_Positive();
test_fetch_Appliance_Status_Negative();

test_Scenario_add_delete_Appliance();
test_Scenario_edit_Appliance();
test_Scenario_Location_Update(); 
test_Scenario_tag_Eventging();
test_Scenario_Cycle();



#test_RateLimiting();              # not supported yet


$my_Neurio->printLOG("\n\n");
$my_Neurio->printLOG("##############################################################################################################################\n");
$my_Neurio->printLOG("                                       Automated Test Results Summary Table                                                   \n");
$my_Neurio->printLOG("##############################################################################################################################\n\n");

$my_NeurioTest->{'end_secs'} = time();
$my_NeurioTest->{'end_time'} = $my_NeurioTest->local_8601();

my $table  = Text::TabularDisplay->new(qw(TestID TestCase Pass/Fail Defect Response(msec) Duration(sec)));
foreach my $test (@{$my_NeurioTest->{'globalResult'}}) {
  $table->add($test->{'testID'}, $test->{'title'}, $test->{'state'},$test->{'defect'},$test->{'response'},$test->{'duration'});
  $total ++;
  if ($test->{'state'}  =~ /Passed/)    { $passed++;  }
  if ($test->{'state'}  =~ /Failed/)    { $failed++;  }
  if ($test->{'state'}  =~ /Warning/)   { $warning++; }
  if ($test->{'defect'} =~ /NEURIOEXT/) { $defect++;  }
}

$my_Neurio->printLOG(printSummary());
$my_Neurio->printLOG($table->render);
$my_Neurio->printLOG("\n\n");
$my_Neurio->printLOG(printSummary());

pushSummary($push);

exit(0);


sub printSummary {
    my $output   = '';
    my $duration = $my_NeurioTest->{'end_secs'}-$my_NeurioTest->{'start_secs'};
    
    $output.= "<h3>API version ".$my_NeurioTest->{'verions'}." and build ".$my_NeurioTest->{'build'}."<br>\n";
    $output.= "API location: ".$my_Neurio->{'base_url'}."</h3>\n";
    $output.= "<PRE>\n";
    $output.= "Test run began at        : ".$my_NeurioTest->{'start_time'}."\n";
    $output.= "Test run ended at        : ".$my_NeurioTest->{'end_time'}."\n";
    $output.= "Tests ran for            : $duration secs (".sprintf("%2.2f",eval{$duration/60})." mins)\n\n";
    $output.= "Total tests run          : $total\n";
    $output.= "Total tests passed       : $passed\n";
    $output.= "Total tests failed       : $failed\n";
    $output.= "Total fails with defect  : $defect\n";
    $output.= "Total fails with warning : $warning\n";
    $output.= "Total test pass rate     : ".sprintf("%2.2f",eval{$passed/$total*100})."%\n";
    $output.= "</PRE>\n";
    
    return $output;
}

sub pushSummary {
  my $push = shift;
  if ($push) {
    open SUM, ">/var/www/results/index.html";
    print SUM "<HTML><HEAD>\n";
    print SUM "<TITLE>Automated Test Results</TITLE>\n";
    print SUM "  <script type=\"text/javascript\">\n";
    print SUM "    var _gaq = _gaq || [];\n";
    print SUM "    _gaq.push([\'_setAccount\', \'UA-39813652-1\']);\n";
    print SUM "    _gaq.push([\'_trackPageview\']);\n";
    print SUM "    (function() {\n";
    print SUM "      var ga = document.createElement(\'script\'); ga.type = \'text/javascript\'; ga.async = true;\n";
    print SUM "      ga.src = (\'https:\' == document.location.protocol ? \'https://ssl\' : \'http://www') + \'.google-analytics.com/ga.js\';\n";
    print SUM "      var s = document.getElementsByTagName(\'script\')[0]; s.parentNode.insertBefore(ga, s);\n";
    print SUM "    })();\n";
    print SUM "  </script>\n";
    print SUM "</HEAD>\n";
    print SUM "<BODY>\n";
    print SUM "<h1><center>Test Results Summary Table</center></h1>\n";
    print SUM printSummary();
    print SUM "Detailed <a href=\"log.html\"><b>log file</b></a> for current summary<br>\n";
    print SUM "Older <a href=\"logfiles\">logfiles</a><br>\n";
    print SUM "Older <a href=\"summaries\">summaries</a><br>\n";
    print SUM "<PRE>\n";
    print SUM $table->render;
    print SUM "</PRE>\n";
    print SUM printSummary();
    print SUM "Detailed <a href=\"log.html\"><b>log file</b></a> for current summary<br>\n";
    print SUM "Older <a href=\"logfiles\">logfiles</a><br>\n";
    print SUM "Older <a href=\"summaries\">summaries</a><br>\n";
    print SUM "</BODY></HTML>\n";
    close(SUM);
    my $file = $my_NeurioTest->{'end_time'};
    `cp /var/www/results/index.html /var/www/results/summaries/Summary_$file.log`;
    `cp /var/www/results/log.html   /var/www/results/logfiles/Log_$file.log`;
  }
}

###################################################################################################
###################################################################################################
###################################################################################################


sub test_RateLimiting {
  $my_Neurio->printLOG("\n");
  $my_Neurio->printLOG("##########################################\n");
  $my_Neurio->printLOG("Testing Rate Limit Remaininging (Positive)\n");
  $my_Neurio->printLOG("##########################################\n");
  
  my $title  = "Validate the Rate Limit Remaining counter";
  my $testID = "Rate_Pos_01";
  my $desc   = "Validate that the Rate Limit Remaining counter increments.";
  my $defect = undef;
  $my_NeurioTest->openTestCase($testID,$title,$desc);
  my $Before = $my_Neurio->get_rateLimitRemaining();
  print "Before\n";
  print "Remaining: ".$my_Neurio->get_rateLimitRemaining()."\n";
  print "Limit    : ".$my_Neurio->get_rateLimitLimit()."\n";
  print "Reset    : ".$my_Neurio->get_rateLimitReset()."\n";
  
  my $test   = $my_Neurio->get_version();
  my $After  = $my_Neurio->get_rateLimitRemaining();
  print "After\n";
  print "Remaining: ".$my_Neurio->get_rateLimitRemaining()."\n";
  print "Limit    : ".$my_Neurio->get_rateLimitLimit()."\n";
  print "Reset    : ".$my_Neurio->get_rateLimitReset()."\n";
  
  $my_NeurioTest->expectAPIPass($test,"Content was empty",200,$defect);
  $my_NeurioTest->expectPass(eval{($After-$Before) == 1},"Remaining Limit","increased by 1",$defect);

  $my_NeurioTest->closeTestCase();
}


###################################################################################################


sub test_fetch_User_Negative {
  $my_Neurio->printLOG("\n");
  $my_Neurio->printLOG("##################################\n");
  $my_Neurio->printLOG("Testing Users API calls (Negative)\n");
  $my_Neurio->printLOG("##################################\n");
  
  my $title  = "Fetching user data for an unknown user ID";
  my $testID = "User_Neg_01";
  my $desc   = "Validate that user data for an unknown user cannot be retrieved.";
  my $defect = undef;
  $my_NeurioTest->openTestCase($testID,$title,$desc);
  my $test   = $my_Neurio->fetch_User('abcd');
  $my_NeurioTest->expectAPIPass(eval{$test eq ''},"Content should have been empty",200,$defect);
  $my_NeurioTest->closeTestCase();


  my $title  = "Fetching user data for a valid user that is not me";
  my $testID = "User_Neg_02";
  my $desc   = "Validate that user data for a valid user that is not mine cannot be retrieved.";
  my $defect = undef;
  $my_NeurioTest->openTestCase($testID,$title,$desc);
  my $test   = $my_Neurio->fetch_User('55hiSNT3R3qRc0J4bmnzxg');                              # Ali's user ID  
  $my_NeurioTest->expectAPIPass(eval{$test eq ''},"Content should have been empty",200,$defect);
  $my_NeurioTest->closeTestCase();
}


###################################################################################################


sub test_fetch_User_Positive {
  $my_Neurio->printLOG("\n");
  $my_Neurio->printLOG("##################################\n");
  $my_Neurio->printLOG("Testing Users API calls (Positive)\n");
  $my_Neurio->printLOG("##################################\n");
  
  my $title  = "Fetching user data for a specific user ID";
  my $testID = "User_Pos_01";
  my $desc   = "Validate that my own user data can be retrieved.";
  my $defect = undef;
  $my_NeurioTest->openTestCase($testID,$title,$desc);
  my $test   = $my_Neurio->fetch_User($user_id);
  $my_NeurioTest->expectAPIPass($test,"Content was empty",200,$defect);
  $my_NeurioTest->expectPass(eval{$my_NeurioTest->validateUsers($test)},"User structure","validated",$defect);
  $my_NeurioTest->closeTestCase();


  my $title  = "Fetching user data for the current user";
  my $testID = "User_Pos_02";
  my $desc   = "Validate that current user data can be retrieved.";
  my $defect = undef;
  $my_NeurioTest->openTestCase($testID,$title,$desc);
  my $test   = $my_Neurio->fetch_User_Current();
  $my_NeurioTest->expectAPIPass($test,"Content was empty",200,$defect);
  $my_NeurioTest->expectPass(eval{$my_NeurioTest->validateUsers($test)},"User structure","validated",$defect);
  $my_NeurioTest->closeTestCase();
}


###################################################################################################


sub test_Scenario_Location_Update {
  $my_Neurio->printLOG("\n");
  $my_Neurio->printLOG("#################################\n");
  $my_Neurio->printLOG("Testing Location Update Scenarios\n");
  $my_Neurio->printLOG("#################################\n");
  
  my $test = $my_Neurio->fetch_Location($my_Neurio->{'location_id'});
  my $orig_name       = $test->{'name'};
  my $orig_timezone   = $test->{'timezone'};
  my $orig_energyRate = $test->{'energyRate'};
  $my_Neurio->printLOG("    User name was originally set to       : $orig_name\n");
  $my_Neurio->printLOG("    User timezone was originally set to   : $orig_timezone\n");
  $my_Neurio->printLOG("    User energyRate was originally set to : $orig_energyRate\n");
  
  
  my $title  = "Updating user name";
  my $testID = "Scenario_Location_Edit_01";
  my $desc   = "Validate that user's name can be changed.";
  my $defect = undef;
  $my_NeurioTest->openTestCase($testID,$title,$desc);
  my $test   = $my_Neurio->update_Location($my_Neurio->{'location_id'},"TestUser");
  $my_NeurioTest->expectAPIPass($test,"Content was empty",200,$defect);
  $my_NeurioTest->expectPass(eval{$my_NeurioTest->validateLocation($test)},"Location structure","validated",$defect);
  my $test   = $my_Neurio->fetch_Location($my_Neurio->{'location_id'});
  $my_Neurio->printLOG("    Fetched user name as: ".$test->{'name'}."\n");
  $my_NeurioTest->expectPass(eval{$test->{'name'} eq 'TestUser'},"user name","changed",$defect);
  $my_NeurioTest->closeTestCase();


  my $title  = "Updating user timezone";
  my $testID = "Scenario_Location_Edit_02";
  my $desc   = "Validate that user's timezone can be changed.";
  my $defect = undef;
  $my_NeurioTest->openTestCase($testID,$title,$desc);
  my $test   = $my_Neurio->update_Location($my_Neurio->{'location_id'},"TestUser","America/Vancouver");
  $my_NeurioTest->expectAPIPass($test,"Content was empty",200,$defect);
  $my_NeurioTest->expectPass(eval{$my_NeurioTest->validateLocation($test)},"Location structure","validated",$defect);
  my $test   = $my_Neurio->fetch_Location($my_Neurio->{'location_id'});
  $my_Neurio->printLOG("    Fetched user timezone as: ".$test->{'timezone'}."\n");
  $my_NeurioTest->expectPass(eval{$test->{'timezone'} eq 'America/Vancouver'},"user timezone","changed",$defect);
  $my_NeurioTest->closeTestCase();


  my $title  = "Attempt to update user timezone to an invalid timezone";
  my $testID = "Scenario_Location_Edit_03";
  my $desc   = "Validate that user's timezone cannot be set to an invalid timezone.";
  my $defect = undef;
  $my_NeurioTest->openTestCase($testID,$title,$desc);
  my $test   = $my_Neurio->update_Location($my_Neurio->{'location_id'},"TestUser","America/MooseJaw");
  $my_NeurioTest->expectAPIFail($test,"Content was empty",422,$defect);
  my $test   = $my_Neurio->fetch_Location($my_Neurio->{'location_id'});
  $my_Neurio->printLOG("    Fetched user timezone as: ".$test->{'timezone'}."\n");
  $my_NeurioTest->expectPass(eval{$test->{'timezone'} eq 'America/Vancouver'},"user timezone","changed",$defect);
  $my_NeurioTest->closeTestCase();


  my $title  = "Updating user energy rate";
  my $testID = "Scenario_Location_Edit_04";
  my $desc   = "Validate that user's energy rate can be changed.";
  my $defect = undef;
  $my_NeurioTest->openTestCase($testID,$title,$desc);
  my $test   = $my_Neurio->update_Location($my_Neurio->{'location_id'},"TestUser","America/Vancouver",1.2);
  $my_NeurioTest->expectAPIPass($test,"Content was empty",200,$defect);
  $my_NeurioTest->expectPass(eval{$my_NeurioTest->validateLocation($test)},"Location structure","validated",$defect);
  my $test   = $my_Neurio->fetch_Location($my_Neurio->{'location_id'});
  $my_Neurio->printLOG("    Fetched user energyRate as: ".$test->{'energyRate'}."\n");
  $my_NeurioTest->expectPass(eval{$test->{'energyRate'} == 1.2},"user energyRate","changed",$defect);
  $my_NeurioTest->closeTestCase();


  my $title  = "Attempt to update user energy rate to a negative value";
  my $testID = "Scenario_Location_Edit_05";
  my $desc   = "Validate that user's energy rate cannot be set to a negative value.";
  my $defect = undef;
  $my_NeurioTest->openTestCase($testID,$title,$desc);
  my $test   = $my_Neurio->update_Location($my_Neurio->{'location_id'},"TestUser","America/Vancouver",-0.1);
  $my_NeurioTest->expectAPIFail($test,"Content was empty",422,$defect);
  my $test   = $my_Neurio->fetch_Location($my_Neurio->{'location_id'});
  $my_Neurio->printLOG("    Fetched user energyRate as: ".$test->{'energyRate'}."\n");
  $my_NeurioTest->expectPass(eval{$test->{'energyRate'} eq 1.2},"user energyRate","changed",$defect);
  $my_NeurioTest->closeTestCase();


  my $title  = "Attempt to update user energy rate to a value greater than maximum";
  my $testID = "Scenario_Location_Edit_06";
  my $desc   = "Validate that user's energy rate cannot be set to a value greater than maximum.";
  my $defect = undef;
  $my_NeurioTest->openTestCase($testID,$title,$desc);
  my $test   = $my_Neurio->update_Location($my_Neurio->{'location_id'},"TestUser","America/Vancouver",1000000);
  $my_NeurioTest->expectAPIFail($test,"Content was empty",422,$defect);
  my $test   = $my_Neurio->fetch_Location($my_Neurio->{'location_id'});
  $my_Neurio->printLOG("    Fetched user energyRate as: ".$test->{'energyRate'}."\n");
  $my_NeurioTest->expectPass(eval{$test->{'energyRate'} eq 1.2},"user energyRate","changed",$defect);
  $my_NeurioTest->closeTestCase();


  my $title  = "Updating user data as it was originally";
  my $testID = "Scenario_Location_Edit_07";
  my $desc   = "Validate that user's energy rate can be changed.";
  my $defect = undef;
  $my_NeurioTest->openTestCase($testID,$title,$desc);
  my $test   = $my_Neurio->update_Location($my_Neurio->{'location_id'},$orig_name,$orig_timezone,$orig_energyRate);
  $my_NeurioTest->expectAPIPass($test,"Content was empty",200,$defect);
  $my_NeurioTest->expectPass($my_NeurioTest->validateLocation($test),"Validate location","correct",$defect);
  my $test   = $my_Neurio->fetch_Location($my_Neurio->{'location_id'});
  $my_Neurio->printLOG("    User name set to       : ".$test->{'name'}."\n");
  $my_Neurio->printLOG("    User timezone set to   : ".$test->{'timezone'}."\n");
  $my_Neurio->printLOG("    User energyRate set to : ".$test->{'energyRate'}."\n");
  $my_NeurioTest->expectPass(eval{$test->{'name'} == $orig_name and $test->{'timezone'} == $orig_timezone and $test->{'energyRate'} == $orig_energyRate},"user data","reset",$defect);
  $my_NeurioTest->closeTestCase();
}


###################################################################################################


sub test_fetch_Energy_Stats_Positive {
  use TestEnergyStats;

  $my_Neurio->printLOG("\n");
  $my_Neurio->printLOG("#########################################\n");
  $my_Neurio->printLOG("Testing Energy Stats API calls (Positive)\n");
  $my_Neurio->printLOG("#########################################\n");

  my $TestEnergyStats = TestEnergyStats->new($my_Neurio,$my_NeurioTest,$my_NeurioTools);
  
  $TestEnergyStats->EnergyStats_Pos_01();
  $TestEnergyStats->EnergyStats_Pos_02();
  $TestEnergyStats->EnergyStats_Pos_03();
  $TestEnergyStats->EnergyStats_Pos_04();
  $TestEnergyStats->EnergyStats_Pos_05();
  $TestEnergyStats->EnergyStats_Pos_06();
  $TestEnergyStats->EnergyStats_Pos_07();
  $TestEnergyStats->EnergyStats_Pos_08();
  $TestEnergyStats->EnergyStats_Pos_09();
  $TestEnergyStats->EnergyStats_Pos_10();
  $TestEnergyStats->EnergyStats_Pos_11();
  $TestEnergyStats->EnergyStats_Pos_12();
  $TestEnergyStats->EnergyStats_Pos_13();
  $TestEnergyStats->EnergyStats_Pos_14();
  $TestEnergyStats->EnergyStats_Pos_15();
  $TestEnergyStats->EnergyStats_Pos_16();
  $TestEnergyStats->EnergyStats_Pos_17();
  $TestEnergyStats->EnergyStats_Pos_18();
  $TestEnergyStats->EnergyStats_Pos_19();
}


###################################################################################################


sub test_fetch_Energy_Stats_Negative {
  use TestEnergyStats;
  
  $my_Neurio->printLOG("\n");
  $my_Neurio->printLOG("#########################################\n");
  $my_Neurio->printLOG("Testing Energy Stats API calls (Negative)\n");
  $my_Neurio->printLOG("#########################################\n");
  
  my $TestEnergyStats = TestEnergyStats->new($my_Neurio,$my_NeurioTest,$my_NeurioTools);
  
  $TestEnergyStats->EnergyStats_Neg_01();
  $TestEnergyStats->EnergyStats_Neg_02();
  $TestEnergyStats->EnergyStats_Neg_03();
  $TestEnergyStats->EnergyStats_Neg_04();
  $TestEnergyStats->EnergyStats_Neg_05();
  $TestEnergyStats->EnergyStats_Neg_06();
  $TestEnergyStats->EnergyStats_Neg_07();
  $TestEnergyStats->EnergyStats_Neg_08();
  $TestEnergyStats->EnergyStats_Neg_09();
  $TestEnergyStats->EnergyStats_Neg_10();
  $TestEnergyStats->EnergyStats_Neg_11();
  $TestEnergyStats->EnergyStats_Neg_12();
  $TestEnergyStats->EnergyStats_Neg_13();
  $TestEnergyStats->EnergyStats_Neg_14();
  $TestEnergyStats->EnergyStats_Neg_15();
  $TestEnergyStats->EnergyStats_Neg_16();
  $TestEnergyStats->EnergyStats_Neg_17();
  $TestEnergyStats->EnergyStats_Neg_18();
  $TestEnergyStats->EnergyStats_Neg_19();
  $TestEnergyStats->EnergyStats_Neg_20();
  $TestEnergyStats->EnergyStats_Neg_21();
  $TestEnergyStats->EnergyStats_Neg_22();
  $TestEnergyStats->EnergyStats_Neg_23();
  $TestEnergyStats->EnergyStats_Neg_24();
  $TestEnergyStats->EnergyStats_Neg_25();
  $TestEnergyStats->EnergyStats_Neg_26();
  $TestEnergyStats->EnergyStats_Neg_27();
  $TestEnergyStats->EnergyStats_Neg_28();
  $TestEnergyStats->EnergyStats_Neg_29();
  $TestEnergyStats->EnergyStats_Neg_30();
}


###################################################################################################


sub test_fetch_Samples_Positive {
  use TestSample;
  
  $my_Neurio->printLOG("\n");
  $my_Neurio->printLOG("####################################\n");
  $my_Neurio->printLOG("Testing Samples API calls (Positive)\n");
  $my_Neurio->printLOG("####################################\n");

  my $TestSample = TestSample->new($my_Neurio,$my_NeurioTest,$my_NeurioTools);
  
  $TestSample->Sample_Pos_01();
  $TestSample->Sample_Pos_02();
  $TestSample->Sample_Pos_03();
  $TestSample->Sample_Pos_04();
  $TestSample->Sample_Pos_05();
  $TestSample->Sample_Pos_06();
  $TestSample->Sample_Pos_07();
  $TestSample->Sample_Pos_08();
  $TestSample->Sample_Pos_09();
  $TestSample->Sample_Pos_10();
  $TestSample->Sample_Pos_11();
  $TestSample->Sample_Pos_12();
  $TestSample->Sample_Pos_13();
  $TestSample->Sample_Pos_14();
  $TestSample->Sample_Pos_15();
  $TestSample->Sample_Pos_16();
  $TestSample->Sample_Pos_17();
  $TestSample->Sample_Pos_18();
  $TestSample->Sample_Pos_19();
}


###################################################################################################


sub test_fetch_Samples_Negative {
  use TestSample;

  $my_Neurio->printLOG("\n");
  $my_Neurio->printLOG("####################################\n");
  $my_Neurio->printLOG("Testing Samples API calls (Negative)\n");
  $my_Neurio->printLOG("####################################\n");

  my $TestSample = TestSample->new($my_Neurio,$my_NeurioTest,$my_NeurioTools);
  
  $TestSample->Sample_Neg_01();
  $TestSample->Sample_Neg_02();
  $TestSample->Sample_Neg_03();
  $TestSample->Sample_Neg_04();
  $TestSample->Sample_Neg_05();
  $TestSample->Sample_Neg_06();
  $TestSample->Sample_Neg_07();
  $TestSample->Sample_Neg_08();
  $TestSample->Sample_Neg_09();
  $TestSample->Sample_Neg_10();
  $TestSample->Sample_Neg_11();
  $TestSample->Sample_Neg_12();
  $TestSample->Sample_Neg_13();
  $TestSample->Sample_Neg_14();
  $TestSample->Sample_Neg_15();
  $TestSample->Sample_Neg_16();
  $TestSample->Sample_Neg_17();
  $TestSample->Sample_Neg_18();
  $TestSample->Sample_Neg_19();
  $TestSample->Sample_Neg_20();
  $TestSample->Sample_Neg_21();
  $TestSample->Sample_Neg_22();
  $TestSample->Sample_Neg_23();
  $TestSample->Sample_Neg_24();
  $TestSample->Sample_Neg_25();
  $TestSample->Sample_Neg_26();
  $TestSample->Sample_Neg_27();
  $TestSample->Sample_Neg_28();
  $TestSample->Sample_Neg_29();
  $TestSample->Sample_Neg_30();
}


###################################################################################################


sub test_fetch_Samples_Full_Positive {
  use TestFullSample;

  $my_Neurio->printLOG("\n");
  $my_Neurio->printLOG("#########################################\n");
  $my_Neurio->printLOG("Testing Full Samples API calls (Positive)\n");
  $my_Neurio->printLOG("#########################################\n");
  
  my $TestFullSample = TestFullSample->new($my_Neurio,$my_NeurioTest,$my_NeurioTools);
  
  $TestFullSample->FullSample_Pos_01();
  $TestFullSample->FullSample_Pos_02();
  $TestFullSample->FullSample_Pos_03();
  $TestFullSample->FullSample_Pos_04();
  $TestFullSample->FullSample_Pos_05();
  $TestFullSample->FullSample_Pos_06();
  $TestFullSample->FullSample_Pos_07();
  $TestFullSample->FullSample_Pos_08();
  $TestFullSample->FullSample_Pos_09();
  $TestFullSample->FullSample_Pos_10();
  $TestFullSample->FullSample_Pos_11();
  $TestFullSample->FullSample_Pos_12();
  $TestFullSample->FullSample_Pos_13();
  $TestFullSample->FullSample_Pos_14();
  $TestFullSample->FullSample_Pos_15();
  $TestFullSample->FullSample_Pos_16();
  $TestFullSample->FullSample_Pos_17();
  $TestFullSample->FullSample_Pos_18();
  $TestFullSample->FullSample_Pos_19();
}


###################################################################################################


sub test_fetch_Samples_Full_Negative {
  use TestFullSample;

  $my_Neurio->printLOG("\n");
  $my_Neurio->printLOG("#########################################\n");
  $my_Neurio->printLOG("Testing Full Samples API calls (Negative)\n");
  $my_Neurio->printLOG("#########################################\n");

  my $TestFullSample = TestFullSample->new($my_Neurio,$my_NeurioTest,$my_NeurioTools);
  
  $TestFullSample->FullSample_Neg_01();
  $TestFullSample->FullSample_Neg_02();
  $TestFullSample->FullSample_Neg_03();
  $TestFullSample->FullSample_Neg_04();
  $TestFullSample->FullSample_Neg_05();
  $TestFullSample->FullSample_Neg_06();
  $TestFullSample->FullSample_Neg_07();
  $TestFullSample->FullSample_Neg_08();
  $TestFullSample->FullSample_Neg_09();
  $TestFullSample->FullSample_Neg_10();
  $TestFullSample->FullSample_Neg_11();
  $TestFullSample->FullSample_Neg_12();
  $TestFullSample->FullSample_Neg_13();
  $TestFullSample->FullSample_Neg_14();
  $TestFullSample->FullSample_Neg_15();
  $TestFullSample->FullSample_Neg_16();
  $TestFullSample->FullSample_Neg_17();
  $TestFullSample->FullSample_Neg_18();
  $TestFullSample->FullSample_Neg_19();
  $TestFullSample->FullSample_Neg_20();
  $TestFullSample->FullSample_Neg_21();
  $TestFullSample->FullSample_Neg_22();
  $TestFullSample->FullSample_Neg_23();
  $TestFullSample->FullSample_Neg_24();
  $TestFullSample->FullSample_Neg_25();
  $TestFullSample->FullSample_Neg_26();
  $TestFullSample->FullSample_Neg_27();
  $TestFullSample->FullSample_Neg_28();
  $TestFullSample->FullSample_Neg_29();
  $TestFullSample->FullSample_Neg_30();
}


###################################################################################################


sub test_fetch_Samples_Last_Live_Positive {
  $my_Neurio->printLOG("\n");
  $my_Neurio->printLOG("##############################################\n");
  $my_Neurio->printLOG("Testing Last Live Samples API calls (Positive)\n");
  $my_Neurio->printLOG("##############################################\n");
  
  my $title  = "Fetching last live sample";
  my $testID = "LastLiveSample_Pos_01";
  my $desc   = "Validate that the last live sample can be retrieved.";
  my $defect = undef;
  $my_NeurioTest->openTestCase($testID,$title,$desc);
  my $test   = $my_Neurio->fetch_Samples_Last_Live();
  $my_NeurioTest->expectAPIPass($test,"Content was empty",200,$defect);
  $my_NeurioTest->expectPass($my_NeurioTest->validateSample($test),"Validate Sample","correct",$defect);
  $my_NeurioTest->closeTestCase();
}

###################################################################################################


sub test_fetch_Samples_Last_Live_Negative {
  $my_Neurio->printLOG("\n");
  $my_Neurio->printLOG("##############################################\n");
  $my_Neurio->printLOG("Testing Last Live Samples API calls (Negative)\n");
  $my_Neurio->printLOG("##############################################\n");
}


###################################################################################################


sub test_fetch_Samples_Recent_Live_Positive {
  $my_Neurio->printLOG("\n");
  $my_Neurio->printLOG("################################################\n");
  $my_Neurio->printLOG("Testing Recent Live Samples API calls (Positive)\n");
  $my_Neurio->printLOG("################################################\n");
  
  my $title  = "Fetching recent live samples";
  my $testID = "RecentLiveSample_Pos_01";
  my $desc   = "Validate that recent live sample can be retrieved with no parameter\n(should be 2 minutes or 120 samples).";
  my $defect = undef;
  $my_NeurioTest->openTestCase($testID,$title,$desc);
  my $test   = $my_Neurio->fetch_Samples_Recent_Live();
  $my_NeurioTest->expectAPIPass($test,"Content was empty",200,$defect);
  $my_NeurioTest->expectPass($my_NeurioTest->validateSamples($test),"validate samples","correct",$defect);
  $my_NeurioTest->closeTestCase();


  my $title  = "Fetching recent live samples since a specified date";
  my $testID = "RecentLiveSample_Pos_02";
  my $desc   = "Validate that recent live sample since a specific date can be retrieved.";
  my $defect = undef;
  $my_NeurioTest->openTestCase($testID,$title,$desc);
  my $begin  = $my_NeurioTest->local_8601(-60);
  my $test   = $my_Neurio->fetch_Samples_Recent_Live($begin);
  $my_NeurioTest->expectAPIPass($test,"Content was empty",200,$defect);
  $my_NeurioTest->expectPass($my_NeurioTest->validateSamples($test),"Validate samples","correct",$defect); 
  $my_NeurioTest->closeTestCase();
}


###################################################################################################


sub test_fetch_Samples_Recent_Live_Negative {
  $my_Neurio->printLOG("\n");
  $my_Neurio->printLOG("################################################\n");
  $my_Neurio->printLOG("Testing Recent Live Samples API calls (Negative)\n");
  $my_Neurio->printLOG("################################################\n");
  
  my $title  = "Fetching recent live samples for an invalid date format";
  my $testID = "RecentLiveSample_Neg_01";
  my $desc   = "Validate that recent live samples for an invalid format for the date cannot be retrieved.";
  my $defect = undef;
  $my_NeurioTest->openTestCase($testID,$title,$desc);
  my $test   = $my_Neurio->fetch_Samples_Recent_Live('2015-02-35T09:40:00-05:00');
  $my_NeurioTest->expectAPIFail($test,"Content should have been empty",400,$defect);
  $my_NeurioTest->closeTestCase();


  my $title  = "Fetching recent live samples for an date in the future";
  my $testID = "RecentLiveSample_Neg_02";
  my $desc   = "Validate that recent live samples for a date in the future cannot be retrieved.";
  my $defect = "NEURIOEXT-35/NEURIOKS-1987";
  $my_NeurioTest->openTestCase($testID,$title,$desc);
  my $begin  = $my_NeurioTest->local_8601(3600);                      # 1 hour from now
  my $test   = $my_Neurio->fetch_Samples_Recent_Live($begin);
  $my_NeurioTest->expectAPIFail($test,"Content should have been empty",400,$defect);
  $my_NeurioTest->closeTestCase();
}


###################################################################################################


sub test_fetch_Appliance_Positive {
  $my_Neurio->printLOG("\n");
  $my_Neurio->printLOG("######################################\n");
  $my_Neurio->printLOG("Testing Appliance API calls (Positive)\n");
  $my_Neurio->printLOG("######################################\n");
  
  my $title  = "Fetching appliance ID";
  my $defect = undef;
  $my_Neurio->printLOG("\n$title\n");
  my $appl_ID = $my_NeurioTools->get_appliance_ID('heater');
  if ($appl_ID == 0) {
    my $test   = $my_Neurio->add_Appliance($my_Neurio->{'location_id'},"heater","heater test");
    $my_NeurioTest->expectAPIPass(eval{$test ne ''},"Content should not have been empty",200);
    $appl_ID = $my_NeurioTools->get_appliance_ID('heater');
  }
  $my_Neurio->printLOG("  appliance ID: $appl_ID - ");
  $my_NeurioTest->expectPass($appl_ID,"Appliance ID","defined",$defect);


  my $title  = "Fetching appliances";
  my $testID = "Appliance_Pos_01";
  my $desc   = "Validate that appliances can be retrieved.";
  my $defect = undef;
  $my_NeurioTest->openTestCase($testID,$title,$desc);
  my $test   = $my_Neurio->fetch_Appliances();
  $my_NeurioTest->expectAPIPass($test,"Content should not have been empty",200,$defect);
  $my_NeurioTest->expectPass($my_NeurioTest->validateAppliances($test),"Validate appliances","correct",$defect);
  $my_NeurioTest->closeTestCase();


  my $title  = "Fetching appliance data for a specific appliance";
  my $testID = "Appliance_Pos_02";
  my $desc   = "Validate that appliance data for a specific appliance can be retrieved.";
  my $defect = undef;
  $my_NeurioTest->openTestCase($testID,$title,$desc);
  my $test   = $my_Neurio->fetch_Appliance($appl_ID);
  $my_NeurioTest->expectAPIPass($test,"Content should not have been empty",200,$defect);
  $my_NeurioTest->expectPass($my_NeurioTest->validateAppliance($test),"validate appliances","correct",$defect);
  $my_NeurioTest->closeTestCase();
}


###################################################################################################


sub test_fetch_Appliance_Negative {
  $my_Neurio->printLOG("\n");
  $my_Neurio->printLOG("######################################\n");
  $my_Neurio->printLOG("Testing Appliance API calls (Negative)\n");
  $my_Neurio->printLOG("######################################\n");
  
  my $title  = "Fetching appliance data for an appliance ID that is invalid";
  my $testID = "Appliance_Neg_01";
  my $desc   = "Validate that appliance data for an invalid appliance ID cannot be retrieved.";
  my $defect = undef;
  $my_NeurioTest->openTestCase($testID,$title,$desc);
  my $test   = $my_Neurio->fetch_Appliance('abc');
  $my_NeurioTest->expectAPIFail($test,"Content should not have been empty",404,$defect);
  $my_NeurioTest->closeTestCase();
}

###################################################################################################


sub test_fetch_Appliance_Events_By_Location_Positive {
  use TestApplianceEventsByLocation;
  
  $my_Neurio->printLOG("\n");
  $my_Neurio->printLOG("#########################################################\n");
  $my_Neurio->printLOG("Testing Appliance Events by Location API calls (Positive)\n");
  $my_Neurio->printLOG("#########################################################\n");

  my $TestApplianceEventsByLocation = TestApplianceEventsByLocation->new($my_Neurio,$my_NeurioTest,$my_NeurioTools);
  
  $TestApplianceEventsByLocation->ApplianceEventsByLocation_Pos_01();
  $TestApplianceEventsByLocation->ApplianceEventsByLocation_Pos_02();
  $TestApplianceEventsByLocation->ApplianceEventsByLocation_Pos_03();
  $TestApplianceEventsByLocation->ApplianceEventsByLocation_Pos_04();
  $TestApplianceEventsByLocation->ApplianceEventsByLocation_Pos_05();
  $TestApplianceEventsByLocation->ApplianceEventsByLocation_Pos_06();
  $TestApplianceEventsByLocation->ApplianceEventsByLocation_Pos_07();
  $TestApplianceEventsByLocation->ApplianceEventsByLocation_Pos_08();
  $TestApplianceEventsByLocation->ApplianceEventsByLocation_Pos_09();
  $TestApplianceEventsByLocation->ApplianceEventsByLocation_Pos_10();
  $TestApplianceEventsByLocation->ApplianceEventsByLocation_Pos_11();
  $TestApplianceEventsByLocation->ApplianceEventsByLocation_Pos_12();
  $TestApplianceEventsByLocation->ApplianceEventsByLocation_Pos_13();
  $TestApplianceEventsByLocation->ApplianceEventsByLocation_Pos_14();
  $TestApplianceEventsByLocation->ApplianceEventsByLocation_Pos_15();
  $TestApplianceEventsByLocation->ApplianceEventsByLocation_Pos_16();
  $TestApplianceEventsByLocation->ApplianceEventsByLocation_Pos_17();
  $TestApplianceEventsByLocation->ApplianceEventsByLocation_Pos_18();
  $TestApplianceEventsByLocation->ApplianceEventsByLocation_Pos_19();
}


###################################################################################################


sub test_fetch_Appliance_Events_By_Appliance_Positive {
  use TestApplianceEventsByAppliance;
  
  $my_Neurio->printLOG("\n");
  $my_Neurio->printLOG("##########################################################\n");
  $my_Neurio->printLOG("Testing Appliance Events by Appliance API calls (Positive)\n");
  $my_Neurio->printLOG("##########################################################\n");

  my $TestApplianceEventsByAppliance = TestApplianceEventsByAppliance->new($my_Neurio,$my_NeurioTest,$my_NeurioTools);
  
  $TestApplianceEventsByAppliance->ApplianceEventsByAppliance_Pos_01();
  $TestApplianceEventsByAppliance->ApplianceEventsByAppliance_Pos_02();
  $TestApplianceEventsByAppliance->ApplianceEventsByAppliance_Pos_03();
  $TestApplianceEventsByAppliance->ApplianceEventsByAppliance_Pos_04();
  $TestApplianceEventsByAppliance->ApplianceEventsByAppliance_Pos_05();
  $TestApplianceEventsByAppliance->ApplianceEventsByAppliance_Pos_06();
  $TestApplianceEventsByAppliance->ApplianceEventsByAppliance_Pos_07();
  $TestApplianceEventsByAppliance->ApplianceEventsByAppliance_Pos_08();
  $TestApplianceEventsByAppliance->ApplianceEventsByAppliance_Pos_09();
  $TestApplianceEventsByAppliance->ApplianceEventsByAppliance_Pos_10();
  $TestApplianceEventsByAppliance->ApplianceEventsByAppliance_Pos_11();
  $TestApplianceEventsByAppliance->ApplianceEventsByAppliance_Pos_12();
  $TestApplianceEventsByAppliance->ApplianceEventsByAppliance_Pos_13();
  $TestApplianceEventsByAppliance->ApplianceEventsByAppliance_Pos_14();
  $TestApplianceEventsByAppliance->ApplianceEventsByAppliance_Pos_15();
  $TestApplianceEventsByAppliance->ApplianceEventsByAppliance_Pos_16();
  $TestApplianceEventsByAppliance->ApplianceEventsByAppliance_Pos_17();
  $TestApplianceEventsByAppliance->ApplianceEventsByAppliance_Pos_18();
  $TestApplianceEventsByAppliance->ApplianceEventsByAppliance_Pos_19();
}


###################################################################################################


sub test_fetch_Appliance_Recent_Events_By_Location_Positive {
  use TestApplianceRecentEventsByLocation;

  $my_Neurio->printLOG("\n");
  $my_Neurio->printLOG("################################################################\n");
  $my_Neurio->printLOG("Testing Appliance Recent Events by Location API calls (Positive)\n");
  $my_Neurio->printLOG("################################################################\n");

  my $TestApplianceRecentEventsByLocation = TestApplianceRecentEventsByLocation->new($my_Neurio,$my_NeurioTest,$my_NeurioTools);
  
  $TestApplianceRecentEventsByLocation->ApplianceRecentEventsByLocation_Pos_01();
  $TestApplianceRecentEventsByLocation->ApplianceRecentEventsByLocation_Pos_02();
  $TestApplianceRecentEventsByLocation->ApplianceRecentEventsByLocation_Pos_03();
  $TestApplianceRecentEventsByLocation->ApplianceRecentEventsByLocation_Pos_04();
  $TestApplianceRecentEventsByLocation->ApplianceRecentEventsByLocation_Pos_05();
  $TestApplianceRecentEventsByLocation->ApplianceRecentEventsByLocation_Pos_06();
  $TestApplianceRecentEventsByLocation->ApplianceRecentEventsByLocation_Pos_07();
  $TestApplianceRecentEventsByLocation->ApplianceRecentEventsByLocation_Pos_08();
  $TestApplianceRecentEventsByLocation->ApplianceRecentEventsByLocation_Pos_09();
  $TestApplianceRecentEventsByLocation->ApplianceRecentEventsByLocation_Pos_10();
  $TestApplianceRecentEventsByLocation->ApplianceRecentEventsByLocation_Pos_11();
  $TestApplianceRecentEventsByLocation->ApplianceRecentEventsByLocation_Pos_12();
  $TestApplianceRecentEventsByLocation->ApplianceRecentEventsByLocation_Pos_13();
  $TestApplianceRecentEventsByLocation->ApplianceRecentEventsByLocation_Pos_14();
  $TestApplianceRecentEventsByLocation->ApplianceRecentEventsByLocation_Pos_15();
  $TestApplianceRecentEventsByLocation->ApplianceRecentEventsByLocation_Pos_16();
  $TestApplianceRecentEventsByLocation->ApplianceRecentEventsByLocation_Pos_17();
  $TestApplianceRecentEventsByLocation->ApplianceRecentEventsByLocation_Pos_18();
  $TestApplianceRecentEventsByLocation->ApplianceRecentEventsByLocation_Pos_19();
}


###################################################################################################


sub test_fetch_Appliance_Specs_Positive {
  $my_Neurio->printLOG("\n");
  $my_Neurio->printLOG("############################################\n");
  $my_Neurio->printLOG("Testing Appliance Specs API calls (Positive)\n");
  $my_Neurio->printLOG("############################################\n");
  
  my $title  = "Fetching appliance ID";
  my $defect = undef;
  $my_Neurio->printLOG("\n$title\n");
  my $appl_ID = $my_NeurioTools->get_appliance_ID('heater');
  $my_Neurio->printLOG("  Applliance ID: $appl_ID - ");
  $my_NeurioTest->expectPass($appl_ID,"Appliance ID","defined",$defect);


  my $title  = "Fetching appliance specs";
  my $testID = "ApplianceSpecs_Pos_01";
  my $desc   = "Validate that appliance specs can be retrieved.";
  my $defect = undef;
  $my_NeurioTest->openTestCase($testID,$title,$desc);
  my $test   = $my_Neurio->fetch_Appliances_Specs();
  $my_NeurioTest->expectAPIPass($test,"Content should not have been empty",200,$defect);
  $my_NeurioTest->expectPass($my_NeurioTest->validateApplianceSpecs($test),"validate appliance specs","correct",$defect);
  $my_NeurioTest->closeTestCase();
}

  
###################################################################################################


sub test_fetch_Appliance_Specs_Negative {
  $my_Neurio->printLOG("\n");
  $my_Neurio->printLOG("############################################\n");
  $my_Neurio->printLOG("Testing Appliance Specs API calls (Negative)\n");
  $my_Neurio->printLOG("############################################\n");
  
}

  
###################################################################################################


sub test_fetch_Appliance_Status_Positive {
  $my_Neurio->printLOG("\n");
  $my_Neurio->printLOG("#############################################\n");
  $my_Neurio->printLOG("Testing Appliance Status API calls (Positive)\n");
  $my_Neurio->printLOG("#############################################\n");
  
  my $title  = "Fetching appliance ID";
  my $defect = undef;
  $my_Neurio->printLOG("\n$title\n");
  my $appl_ID = $my_NeurioTools->get_appliance_ID('heater');
  $my_Neurio->printLOG("  appliance ID: $appl_ID - ");
  $my_NeurioTest->expectPass($appl_ID,"Appliance ID","defined",$defect);


  my $title  = "Fetching appliance status for a specific location";
  my $testID = "ApplianceStatus_Pos_01";
  my $desc   = "Validate that appliance status for a specific location can be retrieved.";
  my $defect = undef;
  $my_NeurioTest->openTestCase($testID,$title,$desc);
  my $test   = $my_Neurio->fetch_Appliances_Status($my_Neurio->{'location_id'});
  $my_NeurioTest->expectAPIPass($test,"Content should not have been empty",200,$defect);
  $my_NeurioTest->expectPass($my_NeurioTest->validateApplianceStatus($test),"validate appliance status","correct",$defect);
  $my_NeurioTest->closeTestCase();
}


###################################################################################################


sub test_fetch_Appliance_Status_Negative {
  $my_Neurio->printLOG("\n");
  $my_Neurio->printLOG("#############################################\n");
  $my_Neurio->printLOG("Testing Appliance Status API calls (Negative)\n");
  $my_Neurio->printLOG("#############################################\n");
  
  my $title  = "Fetching appliance status for an invalid location";
  my $testID = "ApplianceStatus_Neg_01";
  my $desc   = "Validate that appliance status for an invalid location returns an empty response.";
  my $defect = undef;
  $my_NeurioTest->openTestCase($testID,$title,$desc);
  my $test   = $my_Neurio->fetch_Appliances_Status('abc');
  $my_NeurioTest->expectAPIPass(eval{@{$test} == undef},"Content should be empty",200,$defect);
  $my_NeurioTest->closeTestCase();
}


###################################################################################################


sub test_fetch_Appliance_Stats_by_Appliance_Positive {
  use TestApplianceStatsByAppliance;

  $my_Neurio->printLOG("\n");
  $my_Neurio->printLOG("#########################################################\n");
  $my_Neurio->printLOG("Testing Appliance Stats by Appliance API calls (Positive)\n");
  $my_Neurio->printLOG("#########################################################\n");

  my $TestApplianceStatsByAppliance = TestApplianceStatsByAppliance->new($my_Neurio,$my_NeurioTest,$my_NeurioTools);
  
  $TestApplianceStatsByAppliance->ApplianceStatsByAppliance_Pos_01();
  $TestApplianceStatsByAppliance->ApplianceStatsByAppliance_Pos_02();
  $TestApplianceStatsByAppliance->ApplianceStatsByAppliance_Pos_03();
  $TestApplianceStatsByAppliance->ApplianceStatsByAppliance_Pos_04();
  $TestApplianceStatsByAppliance->ApplianceStatsByAppliance_Pos_05();
  $TestApplianceStatsByAppliance->ApplianceStatsByAppliance_Pos_06();
  $TestApplianceStatsByAppliance->ApplianceStatsByAppliance_Pos_07();
  $TestApplianceStatsByAppliance->ApplianceStatsByAppliance_Pos_08();
  $TestApplianceStatsByAppliance->ApplianceStatsByAppliance_Pos_09();
  $TestApplianceStatsByAppliance->ApplianceStatsByAppliance_Pos_10();
  $TestApplianceStatsByAppliance->ApplianceStatsByAppliance_Pos_11();
  $TestApplianceStatsByAppliance->ApplianceStatsByAppliance_Pos_12();
  $TestApplianceStatsByAppliance->ApplianceStatsByAppliance_Pos_13();
  $TestApplianceStatsByAppliance->ApplianceStatsByAppliance_Pos_14();
  $TestApplianceStatsByAppliance->ApplianceStatsByAppliance_Pos_15();
  $TestApplianceStatsByAppliance->ApplianceStatsByAppliance_Pos_16();
  $TestApplianceStatsByAppliance->ApplianceStatsByAppliance_Pos_17();
  $TestApplianceStatsByAppliance->ApplianceStatsByAppliance_Pos_18();
  $TestApplianceStatsByAppliance->ApplianceStatsByAppliance_Pos_19();
}
  


###################################################################################################


sub test_fetch_Appliance_Stats_by_Appliance_Negative {
  use TestApplianceStatsByAppliance;
  
  $my_Neurio->printLOG("\n");
  $my_Neurio->printLOG("#########################################################\n");
  $my_Neurio->printLOG("Testing Appliance Stats by Appliance API calls (Negative)\n");
  $my_Neurio->printLOG("#########################################################\n");

  my $TestApplianceStatsByAppliance = TestApplianceStatsByAppliance->new($my_Neurio,$my_NeurioTest,$my_NeurioTools);
  
  $TestApplianceStatsByAppliance->ApplianceStatsByAppliance_Neg_01();
  $TestApplianceStatsByAppliance->ApplianceStatsByAppliance_Neg_02();
  $TestApplianceStatsByAppliance->ApplianceStatsByAppliance_Neg_03();
  $TestApplianceStatsByAppliance->ApplianceStatsByAppliance_Neg_04();
  $TestApplianceStatsByAppliance->ApplianceStatsByAppliance_Neg_05();
  $TestApplianceStatsByAppliance->ApplianceStatsByAppliance_Neg_06();
  $TestApplianceStatsByAppliance->ApplianceStatsByAppliance_Neg_07();
  $TestApplianceStatsByAppliance->ApplianceStatsByAppliance_Neg_08();
  $TestApplianceStatsByAppliance->ApplianceStatsByAppliance_Neg_09();
  $TestApplianceStatsByAppliance->ApplianceStatsByAppliance_Neg_10();
  $TestApplianceStatsByAppliance->ApplianceStatsByAppliance_Neg_11();
  $TestApplianceStatsByAppliance->ApplianceStatsByAppliance_Neg_12();
  $TestApplianceStatsByAppliance->ApplianceStatsByAppliance_Neg_13();
  $TestApplianceStatsByAppliance->ApplianceStatsByAppliance_Neg_14();
  $TestApplianceStatsByAppliance->ApplianceStatsByAppliance_Neg_15();
  $TestApplianceStatsByAppliance->ApplianceStatsByAppliance_Neg_16();
  $TestApplianceStatsByAppliance->ApplianceStatsByAppliance_Neg_17();
  $TestApplianceStatsByAppliance->ApplianceStatsByAppliance_Neg_18();
  $TestApplianceStatsByAppliance->ApplianceStatsByAppliance_Neg_19();
  $TestApplianceStatsByAppliance->ApplianceStatsByAppliance_Neg_20();
  $TestApplianceStatsByAppliance->ApplianceStatsByAppliance_Neg_21();
  $TestApplianceStatsByAppliance->ApplianceStatsByAppliance_Neg_22();
  $TestApplianceStatsByAppliance->ApplianceStatsByAppliance_Neg_23();
  $TestApplianceStatsByAppliance->ApplianceStatsByAppliance_Neg_24();
  $TestApplianceStatsByAppliance->ApplianceStatsByAppliance_Neg_25();
  $TestApplianceStatsByAppliance->ApplianceStatsByAppliance_Neg_26();
  $TestApplianceStatsByAppliance->ApplianceStatsByAppliance_Neg_27();
  $TestApplianceStatsByAppliance->ApplianceStatsByAppliance_Neg_28();
  $TestApplianceStatsByAppliance->ApplianceStatsByAppliance_Neg_29();
  $TestApplianceStatsByAppliance->ApplianceStatsByAppliance_Neg_30();
}


###################################################################################################

sub test_fetch_Appliance_Stats_by_Location_Positive {
  use TestApplianceStatsByLocation;
  
  $my_Neurio->printLOG("\n");
  $my_Neurio->printLOG("########################################################\n");
  $my_Neurio->printLOG("Testing Appliance Stats by Location API calls (Positive)\n");
  $my_Neurio->printLOG("########################################################\n");

  my $TestApplianceStatsByLocation = TestApplianceStatsByLocation->new($my_Neurio,$my_NeurioTest,$my_NeurioTools);
  
  $TestApplianceStatsByLocation->ApplianceStatsByLocation_Pos_01();
  $TestApplianceStatsByLocation->ApplianceStatsByLocation_Pos_02();
  $TestApplianceStatsByLocation->ApplianceStatsByLocation_Pos_03();
  $TestApplianceStatsByLocation->ApplianceStatsByLocation_Pos_04();
  $TestApplianceStatsByLocation->ApplianceStatsByLocation_Pos_05();
  $TestApplianceStatsByLocation->ApplianceStatsByLocation_Pos_06();
  $TestApplianceStatsByLocation->ApplianceStatsByLocation_Pos_07();
  $TestApplianceStatsByLocation->ApplianceStatsByLocation_Pos_08();
  $TestApplianceStatsByLocation->ApplianceStatsByLocation_Pos_09();
  $TestApplianceStatsByLocation->ApplianceStatsByLocation_Pos_10();
  $TestApplianceStatsByLocation->ApplianceStatsByLocation_Pos_11();
  $TestApplianceStatsByLocation->ApplianceStatsByLocation_Pos_12();
  $TestApplianceStatsByLocation->ApplianceStatsByLocation_Pos_13();
  $TestApplianceStatsByLocation->ApplianceStatsByLocation_Pos_14();
  $TestApplianceStatsByLocation->ApplianceStatsByLocation_Pos_15();
  $TestApplianceStatsByLocation->ApplianceStatsByLocation_Pos_16();
  $TestApplianceStatsByLocation->ApplianceStatsByLocation_Pos_17();
  $TestApplianceStatsByLocation->ApplianceStatsByLocation_Pos_18();
  $TestApplianceStatsByLocation->ApplianceStatsByLocation_Pos_19();
}


###################################################################################################


sub test_fetch_Appliance_Stats_by_Location_Negative {
  use TestApplianceStatsByLocation;

  $my_Neurio->printLOG("\n");
  $my_Neurio->printLOG("########################################################\n");
  $my_Neurio->printLOG("Testing Appliance Stats by Location API calls (Negative)\n");
  $my_Neurio->printLOG("########################################################\n");

  my $TestApplianceStatsByLocation = TestApplianceStatsByLocation->new($my_Neurio,$my_NeurioTest,$my_NeurioTools);
  
  $TestApplianceStatsByLocation->ApplianceStatsByLocation_Neg_01();
  $TestApplianceStatsByLocation->ApplianceStatsByLocation_Neg_02();
  $TestApplianceStatsByLocation->ApplianceStatsByLocation_Neg_03();
  $TestApplianceStatsByLocation->ApplianceStatsByLocation_Neg_04();
  $TestApplianceStatsByLocation->ApplianceStatsByLocation_Neg_05();
  $TestApplianceStatsByLocation->ApplianceStatsByLocation_Neg_06();
  $TestApplianceStatsByLocation->ApplianceStatsByLocation_Neg_07();
  $TestApplianceStatsByLocation->ApplianceStatsByLocation_Neg_08();
  $TestApplianceStatsByLocation->ApplianceStatsByLocation_Neg_09();
  $TestApplianceStatsByLocation->ApplianceStatsByLocation_Neg_10();
  $TestApplianceStatsByLocation->ApplianceStatsByLocation_Neg_11();
  $TestApplianceStatsByLocation->ApplianceStatsByLocation_Neg_12();
  $TestApplianceStatsByLocation->ApplianceStatsByLocation_Neg_13();
  $TestApplianceStatsByLocation->ApplianceStatsByLocation_Neg_14();
  $TestApplianceStatsByLocation->ApplianceStatsByLocation_Neg_15();
  $TestApplianceStatsByLocation->ApplianceStatsByLocation_Neg_16();
  $TestApplianceStatsByLocation->ApplianceStatsByLocation_Neg_17();
  $TestApplianceStatsByLocation->ApplianceStatsByLocation_Neg_18();
  $TestApplianceStatsByLocation->ApplianceStatsByLocation_Neg_19();
  $TestApplianceStatsByLocation->ApplianceStatsByLocation_Neg_20();
  $TestApplianceStatsByLocation->ApplianceStatsByLocation_Neg_21();
  $TestApplianceStatsByLocation->ApplianceStatsByLocation_Neg_22();
  $TestApplianceStatsByLocation->ApplianceStatsByLocation_Neg_23();
  $TestApplianceStatsByLocation->ApplianceStatsByLocation_Neg_24();
  $TestApplianceStatsByLocation->ApplianceStatsByLocation_Neg_25();
  $TestApplianceStatsByLocation->ApplianceStatsByLocation_Neg_26();
  $TestApplianceStatsByLocation->ApplianceStatsByLocation_Neg_27();
  $TestApplianceStatsByLocation->ApplianceStatsByLocation_Neg_28();
  $TestApplianceStatsByLocation->ApplianceStatsByLocation_Neg_29();
  $TestApplianceStatsByLocation->ApplianceStatsByLocation_Neg_30();
}


###################################################################################################

sub test_fetch_Appliance_Events_By_Location_Negative {
  use TestApplianceEventsByLocation;

  $my_Neurio->printLOG("\n");
  $my_Neurio->printLOG("#########################################################\n");
  $my_Neurio->printLOG("Testing Appliance Events by Location API calls (Negative)\n");
  $my_Neurio->printLOG("#########################################################\n");

  my $TestApplianceEventsByLocation = TestApplianceEventsByLocation->new($my_Neurio,$my_NeurioTest,$my_NeurioTools);
  
  $TestApplianceEventsByLocation->ApplianceEventsByLocation_Neg_01();
  $TestApplianceEventsByLocation->ApplianceEventsByLocation_Neg_02();
  $TestApplianceEventsByLocation->ApplianceEventsByLocation_Neg_03();
  $TestApplianceEventsByLocation->ApplianceEventsByLocation_Neg_04();
  $TestApplianceEventsByLocation->ApplianceEventsByLocation_Neg_05();
  $TestApplianceEventsByLocation->ApplianceEventsByLocation_Neg_06();
  $TestApplianceEventsByLocation->ApplianceEventsByLocation_Neg_07();
  $TestApplianceEventsByLocation->ApplianceEventsByLocation_Neg_08();
  $TestApplianceEventsByLocation->ApplianceEventsByLocation_Neg_09();
  $TestApplianceEventsByLocation->ApplianceEventsByLocation_Neg_10();
  $TestApplianceEventsByLocation->ApplianceEventsByLocation_Neg_11();
  $TestApplianceEventsByLocation->ApplianceEventsByLocation_Neg_12();
  $TestApplianceEventsByLocation->ApplianceEventsByLocation_Neg_13();
  $TestApplianceEventsByLocation->ApplianceEventsByLocation_Neg_14();
  $TestApplianceEventsByLocation->ApplianceEventsByLocation_Neg_15();
  $TestApplianceEventsByLocation->ApplianceEventsByLocation_Neg_16();
  $TestApplianceEventsByLocation->ApplianceEventsByLocation_Neg_17();
  $TestApplianceEventsByLocation->ApplianceEventsByLocation_Neg_18();
  $TestApplianceEventsByLocation->ApplianceEventsByLocation_Neg_19();
  $TestApplianceEventsByLocation->ApplianceEventsByLocation_Neg_20();
  $TestApplianceEventsByLocation->ApplianceEventsByLocation_Neg_21();
  $TestApplianceEventsByLocation->ApplianceEventsByLocation_Neg_22();
  $TestApplianceEventsByLocation->ApplianceEventsByLocation_Neg_23();
  $TestApplianceEventsByLocation->ApplianceEventsByLocation_Neg_24();
  $TestApplianceEventsByLocation->ApplianceEventsByLocation_Neg_25();
  $TestApplianceEventsByLocation->ApplianceEventsByLocation_Neg_26();
  $TestApplianceEventsByLocation->ApplianceEventsByLocation_Neg_27();
  $TestApplianceEventsByLocation->ApplianceEventsByLocation_Neg_28();
  $TestApplianceEventsByLocation->ApplianceEventsByLocation_Neg_29();
  $TestApplianceEventsByLocation->ApplianceEventsByLocation_Neg_30();
}


###################################################################################################


sub test_fetch_Appliance_Events_By_Appliance_Negative {
  use TestApplianceEventsByAppliance;
  
  $my_Neurio->printLOG("\n");
  $my_Neurio->printLOG("##########################################################\n");
  $my_Neurio->printLOG("Testing Appliance Events by Appliance API calls (Negative)\n");
  $my_Neurio->printLOG("##########################################################\n");

  my $TestApplianceEventsByAppliance = TestApplianceEventsByAppliance->new($my_Neurio,$my_NeurioTest,$my_NeurioTools);
  
  $TestApplianceEventsByAppliance->ApplianceEventsByAppliance_Neg_01();
  $TestApplianceEventsByAppliance->ApplianceEventsByAppliance_Neg_02();
  $TestApplianceEventsByAppliance->ApplianceEventsByAppliance_Neg_03();
  $TestApplianceEventsByAppliance->ApplianceEventsByAppliance_Neg_04();
  $TestApplianceEventsByAppliance->ApplianceEventsByAppliance_Neg_05();
  $TestApplianceEventsByAppliance->ApplianceEventsByAppliance_Neg_06();
  $TestApplianceEventsByAppliance->ApplianceEventsByAppliance_Neg_07();
  $TestApplianceEventsByAppliance->ApplianceEventsByAppliance_Neg_08();
  $TestApplianceEventsByAppliance->ApplianceEventsByAppliance_Neg_09();
  $TestApplianceEventsByAppliance->ApplianceEventsByAppliance_Neg_10();
  $TestApplianceEventsByAppliance->ApplianceEventsByAppliance_Neg_11();
  $TestApplianceEventsByAppliance->ApplianceEventsByAppliance_Neg_12();
  $TestApplianceEventsByAppliance->ApplianceEventsByAppliance_Neg_13();
  $TestApplianceEventsByAppliance->ApplianceEventsByAppliance_Neg_14();
  $TestApplianceEventsByAppliance->ApplianceEventsByAppliance_Neg_15();
  $TestApplianceEventsByAppliance->ApplianceEventsByAppliance_Neg_16();
  $TestApplianceEventsByAppliance->ApplianceEventsByAppliance_Neg_17();
  $TestApplianceEventsByAppliance->ApplianceEventsByAppliance_Neg_18();
  $TestApplianceEventsByAppliance->ApplianceEventsByAppliance_Neg_19();
  $TestApplianceEventsByAppliance->ApplianceEventsByAppliance_Neg_20();
  $TestApplianceEventsByAppliance->ApplianceEventsByAppliance_Neg_21();
  $TestApplianceEventsByAppliance->ApplianceEventsByAppliance_Neg_22();
  $TestApplianceEventsByAppliance->ApplianceEventsByAppliance_Neg_23();
  $TestApplianceEventsByAppliance->ApplianceEventsByAppliance_Neg_24();
  $TestApplianceEventsByAppliance->ApplianceEventsByAppliance_Neg_25();
  $TestApplianceEventsByAppliance->ApplianceEventsByAppliance_Neg_26();
  $TestApplianceEventsByAppliance->ApplianceEventsByAppliance_Neg_27();
  $TestApplianceEventsByAppliance->ApplianceEventsByAppliance_Neg_28();
  $TestApplianceEventsByAppliance->ApplianceEventsByAppliance_Neg_29();
  $TestApplianceEventsByAppliance->ApplianceEventsByAppliance_Neg_30();
}


###################################################################################################


sub test_fetch_Appliance_Recent_Events_By_Location_Negative {
  use TestApplianceRecentEventsByLocation;
  
  $my_Neurio->printLOG("\n");
  $my_Neurio->printLOG("################################################################\n");
  $my_Neurio->printLOG("Testing Appliance Recent Evnets by Location API calls (Negative)\n");
  $my_Neurio->printLOG("################################################################\n");

  my $TestApplianceRecentEventsByLocation = TestApplianceRecentEventsByLocation->new($my_Neurio,$my_NeurioTest,$my_NeurioTools);
  
  $TestApplianceRecentEventsByLocation->ApplianceRecentEventsByLocation_Neg_01();
  $TestApplianceRecentEventsByLocation->ApplianceRecentEventsByLocation_Neg_02();
  $TestApplianceRecentEventsByLocation->ApplianceRecentEventsByLocation_Neg_03();
  $TestApplianceRecentEventsByLocation->ApplianceRecentEventsByLocation_Neg_04();
  $TestApplianceRecentEventsByLocation->ApplianceRecentEventsByLocation_Neg_05();
  $TestApplianceRecentEventsByLocation->ApplianceRecentEventsByLocation_Neg_06();
  $TestApplianceRecentEventsByLocation->ApplianceRecentEventsByLocation_Neg_07();
  $TestApplianceRecentEventsByLocation->ApplianceRecentEventsByLocation_Neg_08();
  $TestApplianceRecentEventsByLocation->ApplianceRecentEventsByLocation_Neg_09();
  $TestApplianceRecentEventsByLocation->ApplianceRecentEventsByLocation_Neg_10();
  $TestApplianceRecentEventsByLocation->ApplianceRecentEventsByLocation_Neg_11();
  $TestApplianceRecentEventsByLocation->ApplianceRecentEventsByLocation_Neg_12();
  $TestApplianceRecentEventsByLocation->ApplianceRecentEventsByLocation_Neg_13();
  $TestApplianceRecentEventsByLocation->ApplianceRecentEventsByLocation_Neg_14();
  $TestApplianceRecentEventsByLocation->ApplianceRecentEventsByLocation_Neg_15();
  $TestApplianceRecentEventsByLocation->ApplianceRecentEventsByLocation_Neg_16();
  $TestApplianceRecentEventsByLocation->ApplianceRecentEventsByLocation_Neg_17();
  $TestApplianceRecentEventsByLocation->ApplianceRecentEventsByLocation_Neg_18();
  $TestApplianceRecentEventsByLocation->ApplianceRecentEventsByLocation_Neg_19();
  $TestApplianceRecentEventsByLocation->ApplianceRecentEventsByLocation_Neg_20();
  $TestApplianceRecentEventsByLocation->ApplianceRecentEventsByLocation_Neg_21();
  $TestApplianceRecentEventsByLocation->ApplianceRecentEventsByLocation_Neg_22();
  $TestApplianceRecentEventsByLocation->ApplianceRecentEventsByLocation_Neg_23();
  $TestApplianceRecentEventsByLocation->ApplianceRecentEventsByLocation_Neg_24();
  $TestApplianceRecentEventsByLocation->ApplianceRecentEventsByLocation_Neg_25();
  $TestApplianceRecentEventsByLocation->ApplianceRecentEventsByLocation_Neg_26();
  $TestApplianceRecentEventsByLocation->ApplianceRecentEventsByLocation_Neg_27();
  $TestApplianceRecentEventsByLocation->ApplianceRecentEventsByLocation_Neg_28();
  $TestApplianceRecentEventsByLocation->ApplianceRecentEventsByLocation_Neg_29();
  $TestApplianceRecentEventsByLocation->ApplianceRecentEventsByLocation_Neg_30();
}


###################################################################################################


sub test_fetch_Cycle_Positive {
  use TestCycle;
  
  $my_Neurio->printLOG("\n");
  $my_Neurio->printLOG("##################################\n");
  $my_Neurio->printLOG("Testing Cycle API calls (Positive)\n");
  $my_Neurio->printLOG("##################################\n");

  my $TestCycle = TestCycle->new($my_Neurio,$my_NeurioTest,$my_NeurioTools);
  
  $TestCycle->Cycle_Pos_01();
  $TestCycle->Cycle_Pos_02();
  $TestCycle->Cycle_Pos_03();
  $TestCycle->Cycle_Pos_04();
  $TestCycle->Cycle_Pos_05();
  $TestCycle->Cycle_Pos_06();
  $TestCycle->Cycle_Pos_07();
  $TestCycle->Cycle_Pos_08();
  $TestCycle->Cycle_Pos_09();
  $TestCycle->Cycle_Pos_10();
  $TestCycle->Cycle_Pos_11();
  $TestCycle->Cycle_Pos_12();
  $TestCycle->Cycle_Pos_13();
  $TestCycle->Cycle_Pos_14();
  $TestCycle->Cycle_Pos_15();
  $TestCycle->Cycle_Pos_16();
  $TestCycle->Cycle_Pos_17();
  $TestCycle->Cycle_Pos_18();
  $TestCycle->Cycle_Pos_19();
}


###################################################################################################


sub test_fetch_Cycle_Negative {
  use TestCycle;
  
  $my_Neurio->printLOG("\n");
  $my_Neurio->printLOG("##################################\n");
  $my_Neurio->printLOG("Testing Cycle API calls (Negative)\n");
  $my_Neurio->printLOG("##################################\n");

  my $TestCycle = TestCycle->new($my_Neurio,$my_NeurioTest,$my_NeurioTools);
  
  $TestCycle->Cycle_Neg_01();
  $TestCycle->Cycle_Neg_02();
  $TestCycle->Cycle_Neg_03();
  $TestCycle->Cycle_Neg_04();
  $TestCycle->Cycle_Neg_05();
  $TestCycle->Cycle_Neg_06();
  $TestCycle->Cycle_Neg_07();
  $TestCycle->Cycle_Neg_08();
  $TestCycle->Cycle_Neg_09();
  $TestCycle->Cycle_Neg_10();
  $TestCycle->Cycle_Neg_11();
  $TestCycle->Cycle_Neg_12();
  $TestCycle->Cycle_Neg_13();
  $TestCycle->Cycle_Neg_14();
  $TestCycle->Cycle_Neg_15();
  $TestCycle->Cycle_Neg_16();
  $TestCycle->Cycle_Neg_17();
  $TestCycle->Cycle_Neg_18();
  $TestCycle->Cycle_Neg_19();
  $TestCycle->Cycle_Neg_20();
  $TestCycle->Cycle_Neg_21();
  $TestCycle->Cycle_Neg_22();
  $TestCycle->Cycle_Neg_23();
  $TestCycle->Cycle_Neg_24();
  $TestCycle->Cycle_Neg_25();
  $TestCycle->Cycle_Neg_26();
  $TestCycle->Cycle_Neg_27();
  $TestCycle->Cycle_Neg_28();
  $TestCycle->Cycle_Neg_29();
  $TestCycle->Cycle_Neg_30();
}


###################################################################################################


sub test_fetch_FullCycle_Positive {
  use TestFullCycle;

  $my_Neurio->printLOG("\n");
  $my_Neurio->printLOG("#######################################\n");
  $my_Neurio->printLOG("Testing FULL Cycle API calls (Positive)\n");
  $my_Neurio->printLOG("#######################################\n");

  my $TestFullCycle = TestFullCycle->new($my_Neurio,$my_NeurioTest,$my_NeurioTools);
  
  $TestFullCycle->FullCycle_Pos_01();
  $TestFullCycle->FullCycle_Pos_02();
  $TestFullCycle->FullCycle_Pos_03();
  $TestFullCycle->FullCycle_Pos_04();
  $TestFullCycle->FullCycle_Pos_05();
  $TestFullCycle->FullCycle_Pos_06();
  $TestFullCycle->FullCycle_Pos_07();
  $TestFullCycle->FullCycle_Pos_08();
  $TestFullCycle->FullCycle_Pos_09();
  $TestFullCycle->FullCycle_Pos_10();
  $TestFullCycle->FullCycle_Pos_11();
  $TestFullCycle->FullCycle_Pos_12();
  $TestFullCycle->FullCycle_Pos_13();
  $TestFullCycle->FullCycle_Pos_14();
  $TestFullCycle->FullCycle_Pos_15();
  $TestFullCycle->FullCycle_Pos_16();
  $TestFullCycle->FullCycle_Pos_17();
  $TestFullCycle->FullCycle_Pos_18();
  $TestFullCycle->FullCycle_Pos_19();
}


###################################################################################################


sub test_fetch_FullCycle_Negative {
  use TestFullCycle;

  $my_Neurio->printLOG("\n");
  $my_Neurio->printLOG("#######################################\n");
  $my_Neurio->printLOG("Testing FULL Cycle API calls (Negative)\n");
  $my_Neurio->printLOG("#######################################\n");

  my $TestFullCycle = TestFullCycle->new($my_Neurio,$my_NeurioTest,$my_NeurioTools);
  
  $TestFullCycle->FullCycle_Neg_01();
  $TestFullCycle->FullCycle_Neg_02();
  $TestFullCycle->FullCycle_Neg_03();
  $TestFullCycle->FullCycle_Neg_04();
  $TestFullCycle->FullCycle_Neg_05();
  $TestFullCycle->FullCycle_Neg_06();
  $TestFullCycle->FullCycle_Neg_07();
  $TestFullCycle->FullCycle_Neg_08();
  $TestFullCycle->FullCycle_Neg_09();
  $TestFullCycle->FullCycle_Neg_10();
  $TestFullCycle->FullCycle_Neg_11();
  $TestFullCycle->FullCycle_Neg_12();
  $TestFullCycle->FullCycle_Neg_13();
  $TestFullCycle->FullCycle_Neg_14();
  $TestFullCycle->FullCycle_Neg_15();
  $TestFullCycle->FullCycle_Neg_16();
  $TestFullCycle->FullCycle_Neg_17();
  $TestFullCycle->FullCycle_Neg_18();
  $TestFullCycle->FullCycle_Neg_19();
  $TestFullCycle->FullCycle_Neg_20();
  $TestFullCycle->FullCycle_Neg_21();
  $TestFullCycle->FullCycle_Neg_22();
  $TestFullCycle->FullCycle_Neg_23();
  $TestFullCycle->FullCycle_Neg_24();
  $TestFullCycle->FullCycle_Neg_25();
  $TestFullCycle->FullCycle_Neg_26();
  $TestFullCycle->FullCycle_Neg_27();
  $TestFullCycle->FullCycle_Neg_28();
  $TestFullCycle->FullCycle_Neg_29();
  $TestFullCycle->FullCycle_Neg_30();
}


###################################################################################################


sub test_fetch_CycleGroup_Positive {
  $my_Neurio->printLOG("\n");
  $my_Neurio->printLOG("#########################################\n");
  $my_Neurio->printLOG("Testing Cycle Groups API calls (Positive)\n");
  $my_Neurio->printLOG("#########################################\n");
  
  my $title  = "Fetching a cycle group ID";
  my $defect = undef;
  $my_Neurio->printLOG($title."\n");;
  my $cycle_group_ID = $my_NeurioTools->get_cycle_group_ID();
  $my_NeurioTest->expectPass($cycle_group_ID,"CYcle_Group_ID","defined",$defect);

  my $title  = "Fetching cycle group data by sensor";
  my $testID = "CycleGroup_Pos_01";
  my $desc   = "Validate that all cycle groups for a specific sensor can be retrieved.";
  my $defect = undef;
  $my_NeurioTest->openTestCase($testID,$title,$desc);
  my $test   = $my_Neurio->fetch_Cycle_Groups_by_Sensor();
  $my_NeurioTest->expectAPIPass($test,"Content was empty",200,$defect);
  $my_NeurioTest->expectPass(eval{$my_NeurioTest->validateCycleGroups($test)},"Cycle Group structure","validated",$defect);
  $my_NeurioTest->closeTestCase();

  my $title  = "Fetching cycle group data for a specific cycle group ID";
  my $testID = "CycleGroup_Pos_02";
  my $desc   = "Validate that data for specific cycle group ID can be retrieved.";
  my $defect = undef;
  $my_NeurioTest->openTestCase($testID,$title,$desc);
  my $test   = $my_Neurio->fetch_Cycle_Group($cycle_group_ID);
  $my_NeurioTest->expectAPIPass($test,"Content was empty",200,$defect);
  $my_NeurioTest->expectPass(eval{$my_NeurioTest->validateCycleGroup($test)},"Cycle Group structure","validated",$defect);
  $my_NeurioTest->closeTestCase();
}


###################################################################################################


sub test_fetch_CycleGroup_Negative {
  $my_Neurio->printLOG("\n");
  $my_Neurio->printLOG("#########################################\n");
  $my_Neurio->printLOG("Testing Cycle Groups API calls (Negative)\n");
  $my_Neurio->printLOG("#########################################\n");
  
  my $title  = "Fetching cycle group data for a cycle group ID that is unknown";
  my $testID = "CycleGroup_Neg_01";
  my $desc   = "Validate that data for an unknown cycle group ID cannot be retrieved.";
  my $defect = undef;
  $my_NeurioTest->openTestCase($testID,$title,$desc);
  my $test   = $my_Neurio->fetch_Cycle_Group('abc');
  $my_NeurioTest->expectAPIFail($test,"Content should have been empty",404,$defect);
  $my_NeurioTest->closeTestCase();
}


###################################################################################################


sub test_fetch_Edge_Positive {
  $my_Neurio->printLOG("\n");
  $my_Neurio->printLOG("#################################\n");
  $my_Neurio->printLOG("Testing Edge API calls (Positive)\n");
  $my_Neurio->printLOG("#################################\n");
  
  my $title  = "Fetching an Edge ID";
  my $defect = undef;
  $my_Neurio->printLOG($title."\n");;
  my $edge_ID = $my_NeurioTools->get_edge_ID();
  $my_NeurioTest->expectPass($edge_ID,"Edge_ID","defined",$defect);


  my $title  = "Fetching data for a specific Edge";
  my $testID = "Edge_Pos_01";
  my $desc   = "Validate that data for a specific edge can be retrieved.";
  my $defect = undef;
  $my_NeurioTest->openTestCase($testID,$title,$desc);
  my $test   = $my_Neurio->fetch_Edge($edge_ID);
  $my_NeurioTest->expectAPIPass($test,"Content was empty",200,$defect);
  $my_NeurioTest->expectPass(eval{$my_NeurioTest->validateEdge($test)},"Edge structure","validated",$defect);
  $my_NeurioTest->closeTestCase();
}

###################################################################################################


sub test_fetch_Edge_Negative {
  $my_Neurio->printLOG("\n");
  $my_Neurio->printLOG("#################################\n");
  $my_Neurio->printLOG("Testing Edge API calls (Negative)\n");
  $my_Neurio->printLOG("#################################\n");
  
  
  my $title  = "Fetching data for an undefined EdgeId";
  my $testID = "Edge_Neg_01";
  my $desc   = "Validate that data for an undefined EdgeId cannot be retrieved.";
  my $defect = undef;
  $my_NeurioTest->openTestCase($testID,$title,$desc);
  my $test   = $my_Neurio->fetch_Edge('abc');
  $my_NeurioTest->expectAPIFail($test,"Content was empty",405,$defect);
  $my_NeurioTest->closeTestCase();
 }
 
 
###################################################################################################


sub test_fetch_Sensors_Positive {
  use TestSensors;
  
  $my_Neurio->printLOG("\n");
  $my_Neurio->printLOG("####################################\n");
  $my_Neurio->printLOG("Testing Sensors API calls (Positive)\n");
  $my_Neurio->printLOG("####################################\n");

  my $TestSensors = TestSensors->new($my_Neurio,$my_NeurioTest,$my_NeurioTools);
  
  $TestSensors->Sensors_Pos_01();
  $TestSensors->Sensors_Pos_02();
  $TestSensors->Sensors_Pos_03();
  $TestSensors->Sensors_Pos_04();
  $TestSensors->Sensors_Pos_05();
  $TestSensors->Sensors_Pos_06();
  $TestSensors->Sensors_Pos_07();
  $TestSensors->Sensors_Pos_08();
  $TestSensors->Sensors_Pos_09();
  $TestSensors->Sensors_Pos_10();
  $TestSensors->Sensors_Pos_11();
  $TestSensors->Sensors_Pos_12();
  $TestSensors->Sensors_Pos_13();
  $TestSensors->Sensors_Pos_14();
  $TestSensors->Sensors_Pos_15();
  $TestSensors->Sensors_Pos_16();
  $TestSensors->Sensors_Pos_17();
  $TestSensors->Sensors_Pos_18();
  $TestSensors->Sensors_Pos_19();
}



###################################################################################################


sub test_fetch_Sensor_Negative {
  $my_Neurio->printLOG("\n");
  $my_Neurio->printLOG("###################################\n");
  $my_Neurio->printLOG("Testing Sensor API calls (Negative)\n");
  $my_Neurio->printLOG("###################################\n");
  
  
  my $title  = "Fetching sensor data for an undefined sensor";
  my $testID = "Sensor_Neg_01";
  my $desc   = "Validate that sensor data for an unknown sensor cannot be retrieved.";
  my $defect = undef;
  $my_NeurioTest->openTestCase($testID,$title,$desc);
  my $test   = $my_Neurio->fetch_Sensor('abcd');
  $my_NeurioTest->expectAPIFail(eval{$test eq ''},"Content should have been empty",404,$defect);
  $my_NeurioTest->closeTestCase();
}


###################################################################################################


sub test_fetch_Sensor_Positive {
  $my_Neurio->printLOG("\n");
  $my_Neurio->printLOG("###################################\n");
  $my_Neurio->printLOG("Testing Sensor API calls (Positive)\n");
  $my_Neurio->printLOG("###################################\n");
  
  
  my $title  = "Fetching data for my sensor";
  my $testID = "Sensor_Pos_01";
  my $desc   = "Validate that the data my own sensor can be retrieved\nand that the structure of the sensor and channel data is correct.";
  my $defect = undef;
  $my_NeurioTest->openTestCase($testID,$title,$desc);
  my $test   = $my_Neurio->fetch_Sensor($my_Neurio->{'sensor_id'});
  $my_NeurioTest->expectAPIPass($test,"Content was empty",200,$defect);
  $my_NeurioTest->expectPass($my_NeurioTest->validateSensor($test),"validate sensor","correct",$defect);
  $my_NeurioTest->closeTestCase();


  my $title  = "Fetching sensor data for a valid sensor that is not mine";
  my $testID = "Sensor_Pos_02";
  my $desc   = "Validate that sensor data for a valid sensor that is not mine can be retrieved.";
  my $defect = undef;
  $my_NeurioTest->openTestCase($testID,$title,$desc);
  my $test   = $my_Neurio->fetch_Sensor('0x0013A20040B6611E'); 
  $my_NeurioTest->expectAPIPass($test,"Content was empty",200,$defect);
  $my_NeurioTest->expectPass($my_NeurioTest->validateSensor($test),"validate sensor","correct",$defect);
  $my_NeurioTest->closeTestCase();
}


###################################################################################################


sub test_fetch_Sensors_Negative {
  use TestSensors;
  
  $my_Neurio->printLOG("\n");
  $my_Neurio->printLOG("####################################\n");
  $my_Neurio->printLOG("Testing Sensors API calls (Negative)\n");
  $my_Neurio->printLOG("####################################\n");

  my $TestSensors = TestSensors->new($my_Neurio,$my_NeurioTest,$my_NeurioTools);
  
  $TestSensors->Sensors_Neg_01();
  $TestSensors->Sensors_Neg_02();
  $TestSensors->Sensors_Neg_03();
  $TestSensors->Sensors_Neg_04();
  $TestSensors->Sensors_Neg_05();
  $TestSensors->Sensors_Neg_06();
  $TestSensors->Sensors_Neg_07();
  $TestSensors->Sensors_Neg_08();
  $TestSensors->Sensors_Neg_09();
  $TestSensors->Sensors_Neg_10();
  $TestSensors->Sensors_Neg_11();
  $TestSensors->Sensors_Neg_12();
  $TestSensors->Sensors_Neg_13();
  $TestSensors->Sensors_Neg_14();
  $TestSensors->Sensors_Neg_15();
  $TestSensors->Sensors_Neg_16();
  $TestSensors->Sensors_Neg_17();
  $TestSensors->Sensors_Neg_18();
  $TestSensors->Sensors_Neg_19();
  $TestSensors->Sensors_Neg_20();
  $TestSensors->Sensors_Neg_21();
  $TestSensors->Sensors_Neg_22();
  $TestSensors->Sensors_Neg_23();
  $TestSensors->Sensors_Neg_24();
  $TestSensors->Sensors_Neg_25();
  $TestSensors->Sensors_Neg_26();
  $TestSensors->Sensors_Neg_27();
  $TestSensors->Sensors_Neg_28();
  $TestSensors->Sensors_Neg_29();
  $TestSensors->Sensors_Neg_30();
}


###################################################################################################

sub test_fetch_Analytics_Positive {
  $my_Neurio->printLOG("\n");
  $my_Neurio->printLOG("######################################\n");
  $my_Neurio->printLOG("Testing Analitics API calls (Positive)\n");
  $my_Neurio->printLOG("######################################\n");
  
}


###################################################################################################

sub test_fetch_Analytics_Negative {
  $my_Neurio->printLOG("\n");
  $my_Neurio->printLOG("######################################\n");
  $my_Neurio->printLOG("Testing Analitics API calls (Negative)\n");
  $my_Neurio->printLOG("######################################\n");

  my $title  = "Fetching analyitics";
  my $testID = "Analytics_Neg_01";
  my $desc   = "Validate that data for an unknown analytic cannot be retrieved.";
  my $defect = undef;
  $my_NeurioTest->openTestCase($testID,$title,$desc);
  my $test   = $my_Neurio->fetch_Analytics("abc");
  $my_NeurioTest->expectAPIFail($test,"Content should have been empty",500,$defect);
  $my_NeurioTest->closeTestCase();
}


###################################################################################################

sub test_Scenario_add_delete_Appliance {
  use TestScenarioApplianceAddDelete;
  
  $my_Neurio->printLOG("\n");
  $my_Neurio->printLOG("######################################\n");
  $my_Neurio->printLOG("Testing Appliance Add/Delete Scenarios\n");
  $my_Neurio->printLOG("######################################\n");

  my $TestScenarioApplianceAddDelete = TestScenarioApplianceAddDelete->new($my_Neurio,$my_NeurioTest,$my_NeurioTools);
  
  $TestScenarioApplianceAddDelete->ScenarioApplianceAddDelete_01();
  $TestScenarioApplianceAddDelete->ScenarioApplianceAddDelete_02();
  $TestScenarioApplianceAddDelete->ScenarioApplianceAddDelete_03();
  $TestScenarioApplianceAddDelete->ScenarioApplianceAddDelete_04();
  $TestScenarioApplianceAddDelete->ScenarioApplianceAddDelete_05();
  $TestScenarioApplianceAddDelete->ScenarioApplianceAddDelete_06();
  $TestScenarioApplianceAddDelete->ScenarioApplianceAddDelete_07();
  $TestScenarioApplianceAddDelete->ScenarioApplianceAddDelete_08();
  $TestScenarioApplianceAddDelete->ScenarioApplianceAddDelete_09();
  $TestScenarioApplianceAddDelete->ScenarioApplianceAddDelete_10();
  $TestScenarioApplianceAddDelete->ScenarioApplianceAddDelete_11();
  $TestScenarioApplianceAddDelete->ScenarioApplianceAddDelete_12();
  $TestScenarioApplianceAddDelete->ScenarioApplianceAddDelete_13();
  $TestScenarioApplianceAddDelete->ScenarioApplianceAddDelete_14();
  $TestScenarioApplianceAddDelete->ScenarioApplianceAddDelete_15();
  $TestScenarioApplianceAddDelete->ScenarioApplianceAddDelete_16();
  $TestScenarioApplianceAddDelete->ScenarioApplianceAddDelete_17();
  $TestScenarioApplianceAddDelete->ScenarioApplianceAddDelete_18();
  $TestScenarioApplianceAddDelete->ScenarioApplianceAddDelete_19();
  $TestScenarioApplianceAddDelete->ScenarioApplianceAddDelete_20();
  $TestScenarioApplianceAddDelete->ScenarioApplianceAddDelete_21();
  $TestScenarioApplianceAddDelete->ScenarioApplianceAddDelete_22();
  $TestScenarioApplianceAddDelete->ScenarioApplianceAddDelete_23();
  $TestScenarioApplianceAddDelete->ScenarioApplianceAddDelete_24();
  $TestScenarioApplianceAddDelete->ScenarioApplianceAddDelete_25();
  $TestScenarioApplianceAddDelete->ScenarioApplianceAddDelete_26();
  $TestScenarioApplianceAddDelete->ScenarioApplianceAddDelete_27();
}


###################################################################################################

sub test_Scenario_edit_Appliance {
  $my_Neurio->printLOG("\n");
  $my_Neurio->printLOG("################################\n");
  $my_Neurio->printLOG("Testing Appliance Edit Scenarios\n");
  $my_Neurio->printLOG("################################\n");


  my $title  = "Delete all test appliances";
  my $testID = "Scenario_edit_Appliance_01";
  my $desc   = "Cleanup by deleting all appliances with the word 'test' in their label.";
  my $defect = undef;
  $my_NeurioTest->openTestCase($testID,$title,$desc);
  my $test   = $my_Neurio->fetch_Appliances();
  $my_NeurioTest->expectAPIPass($test,"Content should not have been empty",200,$defect);
  my $i      = 0;
  foreach my $appl (@{$test}) {
    if ($test->[$i]->{'label'} =~ /test/) {
      $my_Neurio->printLOG("  Deleting test appliance <".$test->[$i]->{'name'}."> with label <".$test->[$i]->{'label'}.">\n");
      my $test = $my_Neurio->delete_Appliance($test->[$i]->{'id'});
      $my_NeurioTest->expectAPIPass(eval{$test eq ''},"Content should not have been empty",204,$defect);
    } else {
      $my_Neurio->printLOG("  Found non-test appliance <".$test->[$i]->{'name'}."> with label <".$test->[$i]->{'label'}.">\n");
    }
  	$i++;
  }
  $my_NeurioTest->closeTestCase();


  my $title  = "Add a new appliance";
  my $testID = "Scenario_edit_Appliance_02";
  my $desc   = "Validate that a new appliance can be added.";
  my $defect = undef;
  $my_NeurioTest->openTestCase($testID,$title,$desc);
  my $test   = $my_Neurio->add_Appliance($my_Neurio->{'location_id'},"toaster","toaster test");
  $my_NeurioTest->expectAPIPass(eval{$test ne ''},"Content should not have been empty",200,$defect);
  $my_NeurioTest->expectPass(eval{$test->{'label'} eq 'toaster test'},"'toaster test' label","created",$defect);
  my $appl = $my_NeurioTools->get_appliance_ID("toaster","toaster test");
  $my_NeurioTest->expectPass($appl,"toaster Appliance","defined",$defect);
  $my_NeurioTest->closeTestCase();


  my $title  = "Change appliance label to non-alphanumeric characters";
  my $testID = "Scenario_edit_Appliance_03";
  my $desc   = "Validate that an existing appliance can have its label changed to non-alpanumeric characters.";
  my $defect = undef;
  my $label  = "~!@#$%^&*()_+-={}|[]\:;'<>?,./";
  $my_NeurioTest->openTestCase($testID,$title,$desc);
  my $appl   = $my_NeurioTools->get_appliance_ID("toaster","toaster test");
  my $test   = $my_Neurio->edit_Appliance($appl,"toaster",$label);
  $my_NeurioTest->expectAPIPass(eval{$test ne ''},"Content should NOT have been empty",200,$defect);
  $my_NeurioTest->expectPass(eval{$my_NeurioTools->get_appliance_ID("toaster",$label) eq $appl},"toaster label", "changed",$defect);
  $my_NeurioTest->expectPass(eval{$my_NeurioTools->get_appliance_ID("toaster","toaster test") == 0},"toaster label", "changed",$defect);
  $my_NeurioTest->closeTestCase();


  my $title  = "Change appliance tag to non-alphanumeric characters";
  my $testID = "Scenario_edit_Appliance_04";
  my $desc   = "Validate that an existing appliance can have its tag changed to non-alpanumeric characters.";
  my $defect = undef;
  my @tags    = ( "~!@#$%^&*()_+-={}|[]\:;'<>?,./" );
  $my_NeurioTest->openTestCase($testID,$title,$desc);
  my $appl   = $my_NeurioTools->get_appliance_ID("toaster",$label);
  my $test   = $my_Neurio->edit_Appliance($appl,"toaster","toaster test",@tags);
  $my_NeurioTest->expectAPIPass(eval{$test ne ''},"Content should NOT have been empty",200,$defect);
  $my_NeurioTest->expectPass(eval{$my_NeurioTools->get_appliance_ID("toaster",$label) == 0},"toaster", "label changed",$defect);
  $my_NeurioTest->closeTestCase();


  my $title  = "Change appliance back to alphanumeric characters";
  my $testID = "Scenario_edit_Appliance_05";
  my $desc   = "Validate that an existing appliance can have its label and tag changed back to alpanumeric characters.";
  my $defect = undef;
  $my_NeurioTest->openTestCase($testID,$title,$desc);
  my $appl   = $my_NeurioTools->get_appliance_ID("toaster",$label);
  my $test   = $my_Neurio->edit_Appliance($appl,"toaster","toaster test", ("tag1"));
  $my_NeurioTest->expectAPIPass(eval{$test ne ''},"Content should NOT have been empty",200,$defect);
  $my_NeurioTest->expectPass(eval{$my_NeurioTools->get_appliance_ID("toaster","toaster test") == 0},"toaster", "label changed",$defect);
  $my_NeurioTest->closeTestCase();


  my $title  = "Change appliance name";
  my $testID = "Scenario_edit_Appliance_06";
  my $desc   = "Validate that an existing toaster can be changed to a heater.";
  my $defect = undef;
  $my_NeurioTest->openTestCase($testID,$title,$desc);
  my $appl   = $my_NeurioTools->get_appliance_ID("toaster","toaster test");
  my $test   = $my_Neurio->edit_Appliance($appl,"heater","toaster test");
  $my_NeurioTest->expectAPIPass(eval{$test ne ''},"Content should NOT have been empty",200,$defect);
  $my_NeurioTest->expectPass(eval{$my_NeurioTools->get_appliance_ID("heater","toaster test") == 0},"toaster", "name changed",$defect);
  $my_NeurioTest->closeTestCase();


  my $title   = "Maximum length of appliance label";
  my $testID  = "Scenario_edit_Appliance_07";
  my $desc    = "Validate that the maximum length for the label field of an appliance is 128 characters.";
  my $defect  = undef;
  my $label   = "This new ApplianceLabel is exactly 128 characters in length to be able to test the maximum size of an appliance label in the API";
  my $test;
  $my_NeurioTest->openTestCase($testID,$title,$desc);
  my $appl = $my_NeurioTools->get_appliance_ID("heater","toaster test");
  $test = $my_Neurio->edit_Appliance($appl,"heater",$label);
  $my_NeurioTest->expectAPIPass(eval{$test ne ''},"Content should not have been empty",200,$defect);
  $test= $my_Neurio->fetch_Appliance($appl);
  $my_NeurioTest->expectAPIPass(eval{$test ne ''},"Content should not have been empty",200,$defect);
  $my_NeurioTest->expectPass(eval{$test->{'label'} eq $label},"toaster test","set to 128 characters",$defect);
  $my_Neurio->printLOG("    Expected label to be <$label>\n");
  $my_Neurio->printLOG("    Found label to be    <".$test->{'label'}.">\n");
  $test = $my_Neurio->edit_Appliance($appl,"heater",$label."A");
  $my_NeurioTest->expectAPIFail(eval{$test eq ''},"Content should have been empty",500,$defect);
  $test = $my_Neurio->fetch_Appliance($appl);
  $my_NeurioTest->expectAPIPass(eval{$test ne ''},"Content should not have been empty",200,$defect);
  $my_NeurioTest->expectPass(eval{$test->{'label'} eq $label},"toaster test label","set to more than 128 characters",$defect);
  $my_Neurio->printLOG("    Expected label to be <$label>\n");
  $my_Neurio->printLOG("    Found label to be    <".$test->{'label'}.">\n");
  $my_NeurioTest->closeTestCase();


  my $title   = "Maximum number of tags for an appliance";
  my $testID  = "Scenario_edit_Appliance_08";
  my $desc    = "Validate the maximum number of tags for an appliance is 32 tags.";
  my $defect  = undef;
  my @tags    = ( "tag1", "tag2", "tag3", "tag4", "tag5", "tag6", "tag7", "tag8", "tag9", "tag10","tag11","tag12",
                  "tag13","tag14","tag15","tag16","tag17","tag18","tag19","tag20","tag21","tag22","tag23","tag24",
                  "tag25","tag26","tag27","tag28","tag29","tag30","tag31","tag32" );
  my $test;
  $my_NeurioTest->openTestCase($testID,$title,$desc);
  my $appl = $my_NeurioTools->get_appliance_ID("heater","toaster test");
  $test = $my_Neurio->edit_Appliance($appl,"heater","toaster test",@tags);
  $my_NeurioTest->expectAPIPass(eval{$test ne ''},"Content should not have been empty",200,$defect);
  $test = $my_Neurio->fetch_Appliance($appl);
  $my_NeurioTest->expectAPIPass(eval{$test ne ''},"Content should not have been empty",200,$defect);
  $my_NeurioTest->expectPass(eval{@{$test->{'tags'}} == @tags},"heater tags","edited to include 32 tags",$defect);
  $my_Neurio->printLOG("    Expected tags to be ".scalar @tags."\n");
  $my_Neurio->printLOG("    Found tags to be    ".scalar @{$test->{'tags'}}."\n");
  push (@tags,"tag33");
  $test   = $my_Neurio->edit_Appliance($appl,"heater","toaster test",@tags);
  $my_NeurioTest->expectAPIFail(eval{$test eq ''},"Content should have been empty",500,$defect);
  $test   = $my_Neurio->fetch_Appliance($appl);
  $my_NeurioTest->expectAPIPass(eval{$test ne ''},"Content should not have been empty",200,$defect);
  $my_NeurioTest->expectPass(eval{@{$test->{'tags'}} != @tags},"heater tags","were not set more than 32 tags",$defect);
  $my_Neurio->printLOG("    Expected tags to be ".scalar @tags."\n");
  $my_Neurio->printLOG("    Found tags to be    ".scalar @{$test->{'tags'}}."\n");
  $my_NeurioTest->closeTestCase();


  my $title  = "Delete an appliance whose name was changed";
  my $testID = "Scenario_edit_Appliance_09";
  my $desc   = "Validate that an appliance that used to be a toaster but was changed to aheater can be deleted.";
  my $defect = undef;
  $my_NeurioTest->openTestCase($testID,$title,$desc);
  my $appl   = $my_NeurioTools->get_appliance_ID("heater","toaster test");
  my $test   = $my_Neurio->delete_Appliance($appl);
  $my_NeurioTest->expectAPIPass(eval{$test eq ''},"Content should NOT have been empty",204,$defect);
  $my_NeurioTest->expectPass(eval{$my_NeurioTools->get_appliance_ID("heater","toaster test") == 0},"heater", "removed",$defect);
  $my_NeurioTest->closeTestCase();
}

###################################################################################################

sub test_Scenario_Cycle {
  $my_Neurio->printLOG("\n");
  $my_Neurio->printLOG("#######################\n");
  $my_Neurio->printLOG("Testing Cycle Scenarios\n");
  $my_Neurio->printLOG("#######################\n");

  my $title  = "Verify Cycle refers to group and group refers to cycle";
  my $testID = "Scenario_Cycle_01";
  my $desc   = "Verify that a Cycle refers to a groupID which also refers back to the cycle";
  my $defect = undef;
  $my_NeurioTest->openTestCase($testID,$title,$desc);
  my $test   = $my_Neurio->fetch_Cycles_by_Sensor();
  foreach my $cycle (@{$test}) {
    $my_Neurio->printLOG("\n");
    my $cycleId1      = $cycle->{'id'};                                 # extract cycleId from cycle
    my $cycleGroupId1 = $cycle->{'groupId'};                            # extract cycleGroupId from cycle
    my $tmpCycle      = $my_Neurio->fetch_Cycle($cycleId1);             # fetch Cycle ID
    my $cycleId2      = $tmpCycle->{'id'};                              # extract cycleGroupId from cycle
    my $cycleGroupId2 = $tmpCycle->{'groupId'};                         # extract cycleId from cyclegroup
    my $tmpCycleGroup = $my_Neurio->fetch_Cycle_Group($cycleGroupId1);  # fetch Cycle Group ID
    my $cycleGroupId3 = $tmpCycleGroup->{'id'};                         # extract cycleId from cyclegroup
    $my_Neurio->printLOG("    Cycle ID 1 : $cycleId1\n");
    $my_Neurio->printLOG("    Cycle ID 2 : $cycleId2\n");
    $my_NeurioTest->expectPass(eval{$cycleId1 eq $cycleId2},"Cycle IDs","equal",$defect);
    $my_Neurio->printLOG("    Cycle Group ID 1 : $cycleGroupId1\n");
    $my_Neurio->printLOG("    Cycle Group ID 2 : $cycleGroupId2\n");
    $my_NeurioTest->expectPass(eval{$cycleGroupId1 eq $cycleGroupId2},"Cycle Group IDs","equal",$defect);
    $my_Neurio->printLOG("    Cycle Group ID 3 : $cycleGroupId3\n");
    $my_NeurioTest->expectPass(eval{$cycleGroupId2 eq $cycleGroupId3},"Cycle Group IDs","equal",$defect);
  }
  $my_NeurioTest->closeTestCase();


#  my $title  = "Verify that a cycle can be added";
#  my $testID = "Scenario_Cycle_02";
#  my $desc   = "Verify that a Cycle can be added";
#  my $defect = undef;
#  $my_NeurioTest->openTestCase($testID,$title,$desc);
#  my $test   = $my_Neurio->fetch_Cycles_by_Sensor();
#  foreach my $cycle (@{$test}) {
#  	print Dumper($cycle);
#  	exit(0);

}

###################################################################################################

sub test_Scenario_tag_Eventging {
  $my_Neurio->printLOG("\n");
  $my_Neurio->printLOG("###############################\n");
  $my_Neurio->printLOG("Testing Event Tagging Scenarios\n");
  $my_Neurio->printLOG("###############################\n");


  my $title  = "Delete all test appliances";
  my $testID = "Scenario_tag_Eventging_01";
  my $desc   = "Cleanup by deleting all appliances with the word 'test' in their label.";
  my $defect = undef;
  my $i      = 0;
  $my_NeurioTest->openTestCase($testID,$title,$desc);
  my $test   = $my_Neurio->fetch_Appliances();
  $my_NeurioTest->expectAPIPass($test,"Content should not have been empty",200,$defect);
  foreach my $appl (@{$test}) {
    if ($test->[$i]->{'label'} =~ /test/) {
      $my_Neurio->printLOG("  Deleting test appliance $i <".$test->[$i]->{'name'}."> with label <".$test->[$i]->{'label'}.">\n");
      my $test = $my_Neurio->delete_Appliance($test->[$i]->{'id'});
      $my_NeurioTest->expectAPIPass(eval{$test eq ''},"Content should not have been empty",204,$defect);
    } else {
      $my_Neurio->printLOG("  Found non-test appliance <".$test->[$i]->{'name'}."> with label <".$test->[$i]->{'label'}.">\n");
    }
  	$i++;
  }
  $my_NeurioTest->closeTestCase();



  my $title  = "Tagging a single appliance event";
  my $testID = "Scenario_tag_Eventging_02";
  my $desc   = "Validate that a single appliance event can be tagged.";
  my $defect = undef;
  $my_NeurioTest->openTestCase($testID,$title,$desc);
  my $events        = $my_Neurio->fetch_Appliances_Events_Recent($my_Neurio->{'location_id'});
  my $event         = $events->[0]; 
  my $initial_name  = $event->{'appliance'}->{'name'};
  my $initial_label = $event->{'appliance'}->{'label'};
  my $initial_tags  = $event->{'appliance'}->{'tags'};
  $event->{'appliance'}->{'name'}  = "stove";
  $event->{'appliance'}->{'label'} = "stove test";
  $event->{'appliance'}->{'tags'}  = ["kitchen","range"];
  my $test    = $my_Neurio->tag_Event($event,0);
  $my_NeurioTest->expectAPIPass($test,"Content was empty",200,$defect);
  my $events      = $my_Neurio->fetch_Appliances_Events_Recent($my_Neurio->{'location_id'});
  my $event       = $events->[0]; 
  my $final_name  = $event->{'appliance'}->{'name'};
  my $final_label = $event->{'appliance'}->{'label'};
  my $final_tags  = $event->{'appliance'}->{'tags'};
  $my_NeurioTest->expectPass(eval{$initial_name      ne 'stove'},      "Initial name","correct");
  $my_NeurioTest->expectPass(eval{$initial_label     ne 'stove test'}, "Initial label","correct");
  $my_NeurioTest->expectPass(eval{$initial_tags->[0] ne "kitchen"},    "Initial tag 1","correct");
  $my_NeurioTest->expectPass(eval{$initial_tags->[1] ne "range"},      "Initial tag 2","correct");
  $my_NeurioTest->expectPass(eval{$final_name        eq 'stove'},      "Final name","correct");
  $my_NeurioTest->expectPass(eval{$final_label       eq 'stove test'}, "Final label","correct");
  $my_NeurioTest->expectPass(eval{$final_tags->[0]   eq "kitchen"},    "Final tag 1","correct");
  $my_NeurioTest->expectPass(eval{$final_tags->[1]   eq "range"},      "Final tag 2","correct");
  $my_NeurioTest->closeTestCase();



  my $title  = "Tagging of similar appliance events";
  my $testID = "Scenario_tag_Eventging_03";
  my $desc   = "Validate that an appliance event can be tagged using the 'similarEvents' flag.";
  my $defect = undef;
  $my_NeurioTest->openTestCase($testID,$title,$desc);
  my $events        = $my_Neurio->fetch_Appliances_Events_Recent($my_Neurio->{'location_id'});
  my $event         = $events->[0]; 
  my $initial_name  = $event->{'appliance'}->{'name'};
  my $initial_label = $event->{'appliance'}->{'label'};
  my $initial_tags  = $event->{'appliance'}->{'tags'};
  $event->{'appliance'}->{'name'}  = "heater";
  $event->{'appliance'}->{'label'} = "heater test";
  $event->{'appliance'}->{'tags'}  = ["baseboard","basement"];
  my $test        = $my_Neurio->tag_Event($event,1);
  $my_NeurioTest->expectAPIPass($test,"Content was empty",200,$defect);
  my $events      = $my_Neurio->fetch_Appliances_Events_Recent($my_Neurio->{'location_id'});
  my $event       = $events->[0]; 
  my $final_name  = $event->{'appliance'}->{'name'};
  my $final_label = $event->{'appliance'}->{'label'};
  my $final_tags  = $event->{'appliance'}->{'tags'};
  $my_NeurioTest->expectPass(eval{$initial_name      eq 'stove'},       "Initial name","correct");
  $my_NeurioTest->expectPass(eval{$initial_label     eq 'stove test'},  "Initial label","correct");
  $my_NeurioTest->expectPass(eval{$initial_tags->[0] eq "kitchen"},     "Initial tag 1","correct");
  $my_NeurioTest->expectPass(eval{$initial_tags->[1] eq "range"},       "Initial tag 2","correct");
  $my_NeurioTest->expectPass(eval{$final_name        eq 'heater'},      "Final name","correct");
  $my_NeurioTest->expectPass(eval{$final_label       eq 'heater test'}, "Final label","correct");
  $my_NeurioTest->expectPass(eval{$final_tags->[0]   eq "baseboard"},   "Final tag 1","correct");
  $my_NeurioTest->expectPass(eval{$final_tags->[1]   eq "basement"},    "Final tag 2","correct");
  $my_NeurioTest->closeTestCase();


  my $title  = "Tagging of event with an invalid appliance";
  my $testID = "Scenario_tag_Eventging_04";
  my $desc   = "Validate that an event cannot be tagged as an invalid appliance.";
  my $defect = undef;
  $my_NeurioTest->openTestCase($testID,$title,$desc);
  my $events = $my_Neurio->fetch_Appliances_Events_Recent($my_Neurio->{'location_id'});
  my $event  = $events->[0]; 
  $event->{'appliance'}->{'name'}  = "couch";
  $event->{'appliance'}->{'label'} = "couch test";
  $event->{'appliance'}->{'tags'}  = ["livingroom","sofa"];
  my $test        = $my_Neurio->tag_Event($event,'a');
  $my_NeurioTest->expectAPIFail($test,"Content was empty",422,$defect);
  $my_NeurioTest->closeTestCase();


  my $title  = "Confirmation and unconfirmation of event tagging";
  my $testID = "Scenario_tag_Eventging_05";
  my $desc   = "Validate confirmation and unconfirmation of event tagging.";
  my $defect = undef;
  $my_NeurioTest->openTestCase($testID,$title,$desc);
  my $events   = $my_Neurio->fetch_Appliances_Events_Recent($my_Neurio->{'location_id'});
  my $event    = $events->[0]; 
  if ($event->{'isConfirmed'} eq JSON::false) {
    $my_Neurio->printLOG("\n  Event was NOT already confirmed, so confirming and then unconfirming it\n");
    my $test     = $my_Neurio->tag_Event_confirm($event);
    $my_NeurioTest->expectAPIPass($test,"Content was empty",200,$defect);
    my $events   = $my_Neurio->fetch_Appliances_Events_Recent($my_Neurio->{'location_id'});
    my $event    = $events->[0]; 
    $my_NeurioTest->expectPass(eval{$event->{'isConfirmed'} eq JSON::true}, "Initial isConfirmed state","true");
    my $test     = $my_Neurio->tag_Event_unconfirm($event->{'id'});
    $my_NeurioTest->expectAPIPass($test,"Content was empty",200,$defect);
    my $events   = $my_Neurio->fetch_Appliances_Events_Recent($my_Neurio->{'location_id'});
    my $event    = $events->[0]; 
    $my_NeurioTest->expectPass(eval{$event->{'isConfirmed'} eq JSON::false}, "Final isConfirmed state","false");
  } else {
    $my_Neurio->printLOG("\n  Event was already confirmed, so unconfirming and then confirming it\n");
    my $test     = $my_Neurio->tag_Event_unconfirm($event);
    $my_NeurioTest->expectAPIPass($test,"Content was empty",200,$defect);
    my $events   = $my_Neurio->fetch_Appliances_Events_Recent($my_Neurio->{'location_id'});
    my $event    = $events->[0]; 
    $my_NeurioTest->expectPass(eval{$event->{'isConfirmed'} eq JSON::false}, "Initial isConfirmed state","false");
    my $test     = $my_Neurio->tag_Event_confirm($event);
    $my_NeurioTest->expectAPIPass($test,"Content was empty",200,$defect);
    my $events   = $my_Neurio->fetch_Appliances_Events_Recent($my_Neurio->{'location_id'});
    my $event    = $events->[0]; 
    $my_NeurioTest->expectPass(eval{$event->{'isConfirmed'} eq JSON::true}, "Final isConfirmed state","true");
  }  	
  $my_NeurioTest->closeTestCase();
}



