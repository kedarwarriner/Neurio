package TestApplianceStatsByAppliance;

use warnings;
use strict;
use 5.006_001; 

use Data::Dumper;
use HTTP::Date;


sub new {
    my $class = shift;
    my $self;
    
    $self->{'neurio'}      = shift;
    $self->{'neurioTest'}  = shift;
    $self->{'neurioTools'} = shift;

    if ((!defined $self->{'neurio'}) || (!defined $self->{'neurioTest'}) || (!defined $self->{'neurioTools'})) {
      print "\nTestApplianceStatsByAppliance->new(): Neurio, NeurioTest and NeurioTools are REQUIRED parameters\n";
      return 0;
    }

    $self->{'appl_ID'} = $self->{'neurioTools'}->get_appliance_ID('heater');
    if ($self->{'appl_ID'} == 0) {
      my $test   = $self->{'neurio'}->add_Appliance($self->{'neurio'}->{'location_id'},"heater","heater test");
      $self->{'neurioTest'}->expectAPIPass(eval{$test ne ''},"Content should not have been empty",200);
      $self->{'appl_ID'} = $self->{'neurioTools'}->get_appliance_ID('heater');
    }
    $self->{'neurioTest'}->expectPass($self->{'appl_ID'},"Appliance ID","defined");
    
    bless $self, $class;
    
    return $self;
}

sub DESTROY {
    my $self = shift;
    
    print"\nDestroying ".ref($self), " instance...\n\n";

    undef $self->{'appl_ID'};
    undef $self->{'neurioTools'};
    undef $self->{'neurioTest'};
    undef $self->{'neurio'};
}


###################################################################################################
###################################################################################################
###################################################################################################
###################################################################################################



sub ApplianceStatsByAppliance_Pos_01 {
  my $self   = shift;
  my $title  = "Fetching appliance stats by Appliance for a date range of exactly 25 hours in minutes";
  my $testID = "ApplianceStatsByAppliance_Pos_01";
  my $desc   = "Validate that appliance stats by Appliance for a date range of exactly 1 day and 1 hour\n(25 hours) in intervals of 1 minute can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub ApplianceStatsByAppliance_Pos_02 {
  my $self   = shift;
  my $title  = "Fetching appliance stats by Appliance for a date range of exactly 25 hours in hours";
  my $testID = "ApplianceStatsByAppliance_Pos_02";
  my $desc   = "Validate that appliance stats by Appliance for a date range of exactly 1 day and 1 hour\n(25 hours) in intervals of 1 hour can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub ApplianceStatsByAppliance_Pos_03 {
  my $self   = shift;
  my $title  = "Fetching appliance stats by Appliance for a date range of exactly 1 month in days";
  my $testID = "ApplianceStatsByAppliance_Pos_03";
  my $desc   = "Validate that appliance stats by Appliance for a date range of exactly 1 month in intervals of 1 day can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->fetch_Appliances_Stats_by_Appliance($self->{'appl_ID'},'2014-11-25T09:40:00-05:00','days','2014-12-25T09:40:00-05:00',5,10,1);
  $self->{'neurioTest'}->expectAPIPass($test,"Content was empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTest'}->validateApplianceStatsByAppliance($test)},"appliance event by appliance structure","validated",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceStatsByAppliance_Pos_04 {
  my $self   = shift;
  my $title  = "Fetching appliance stats by Appliance for a date range of exactly 6 months in weeks";
  my $testID = "ApplianceStatsByAppliance_Pos_04";
  my $desc   = "Validate that appliance stats by Appliance for a date range of exactly 6 months in intervals of 1 week can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub ApplianceStatsByAppliance_Pos_05 {
  my $self   = shift;
  my $title  = "Fetching appliance stats by Appliance for a date range of exactly 1 year in months";
  my $testID = "ApplianceStatsByAppliance_Pos_05";
  my $desc   = "Validate that appliance stats by Appliance for a date range of exactly 1 year in intervals of 1 month can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub ApplianceStatsByAppliance_Pos_06 {
  my $self   = shift;
  my $title  = "Fetching appliance stats by Appliance for a date range of exactly 10 years in years";
  my $testID = "ApplianceStatsByAppliance_Pos_06";
  my $desc   = "Validate that appliance stats by Appliance for a date range of exactly 10 years in intervals of 1 year can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub ApplianceStatsByAppliance_Pos_07 {
  my $self   = shift;
  my $title  = "Fetching appliance stats by Appliance for a frequency of 1 (min)";
  my $testID = "ApplianceStatsByAppliance_Pos_07";
  my $desc   = "Validate that appliance stats by Appliance for a frequency for a minimum value of 1 can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub ApplianceStatsByAppliance_Pos_08 {
  my $self   = shift;
  my $title  = "Fetching appliance stats by Appliance for a frequency of 1000 (max)";
  my $testID = "ApplianceStatsByAppliance_Pos_08";
  my $desc   = "Validate that appliance stats by Appliance for a frequency for a maximum value of 1000 can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub ApplianceStatsByAppliance_Pos_09 {
  my $self   = shift;
  my $title  = "Fetching appliance stats by Appliance for a perPage of 1 (min)";
  my $testID = "ApplianceStatsByAppliance_Pos_09";
  my $desc   = "Validate that appliance stats by Appliance for a perPage for a minimum value of 1 can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-86400); # 1 day ago
  my $end    = $self->{'neurioTest'}->local_8601(0); 
  my $test   = $self->{'neurio'}->fetch_Appliances_Stats_by_Appliance($self->{'appl_ID'},$begin,'days',$end,500,1,1);
  $self->{'neurioTest'}->expectAPIPass($test,"Content was empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTest'}->validateApplianceStatsByAppliance($test)},"appliance event by appliance structure","validated",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceStatsByAppliance_Pos_10 {
  my $self   = shift;
  my $title  = "Fetching appliance stats by Appliance for a perPage of 500 (max)";
  my $testID = "ApplianceStatsByAppliance_Pos_10";
  my $desc   = "Validate that appliance stats by Appliance for a perPage for a maximum value of 500 can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-86400); # 1 day ago
  my $end    = $self->{'neurioTest'}->local_8601(0); 
  my $test   = $self->{'neurio'}->fetch_Appliances_Stats_by_Appliance($self->{'appl_ID'},$begin,'days',$end,500,500,1);
  $self->{'neurioTest'}->expectAPIPass($test,"Content was empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTest'}->validateApplianceStatsByAppliance($test)},"appliance event by appliance structure","validated",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceStatsByAppliance_Pos_11 {
  my $self   = shift;
  my $title  = "Fetching appliance stats by Appliance for a page of 1 (min)";
  my $testID = "ApplianceStatsByAppliance_Pos_11";
  my $desc   = "Validate that appliance stats by Appliance for a page for a minimum value of 1 can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-86400); # 1 day ago
  my $end    = $self->{'neurioTest'}->local_8601(0); 
  my $test   = $self->{'neurio'}->fetch_Appliances_Stats_by_Appliance($self->{'appl_ID'},$begin,'days',$end,500,1,1);
  $self->{'neurioTest'}->expectAPIPass($test,"Content was empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTest'}->validateApplianceStatsByAppliance($test)},"appliance event by appliance structure","validated",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceStatsByAppliance_Pos_12 {
  my $self   = shift;
  my $title  = "Fetching appliance stats by Appliance for a page of 100000 (max)";
  my $testID = "ApplianceStatsByAppliance_Pos_12";
  my $desc   = "Validate that appliance stats by Appliance for a page for a maximum value of 100000 can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-86400); # 1 day ago
  my $end    = $self->{'neurioTest'}->local_8601(0); 
  my $test   = $self->{'neurio'}->fetch_Appliances_Stats_by_Appliance($self->{'appl_ID'},$begin,'days',$end,500,1,100000);
  $self->{'neurioTest'}->expectAPIPass($test,"Content was empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTest'}->validateApplianceStatsByAppliance($test)},"appliance event by appliance structure","validated",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceStatsByAppliance_Pos_13 {
  my $self   = shift;
  my $title  = "Fetching appliance stats by Appliance for a min power of 1 (min)";
  my $testID = "ApplianceStatsByAppliance_Pos_13";
  my $desc   = "Validate that appliance stats by Appliance for a minimum value for min power of 1 can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-86400); # 1 day ago
  my $end    = $self->{'neurioTest'}->local_8601(0); 
  my $test   = $self->{'neurio'}->fetch_Appliances_Stats_by_Appliance($self->{'appl_ID'},$begin,'days',$end,1,1,10);
  $self->{'neurioTest'}->expectAPIPass($test,"Content was empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTest'}->validateApplianceStatsByAppliance($test)},"appliance event by appliance structure","validated",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceStatsByAppliance_Pos_14 {
  my $self   = shift;
  my $title  = "Fetching appliance stats by Appliance for a min power of 100000 (max)";
  my $testID = "ApplianceStatsByAppliance_Pos_14";
  my $desc   = "Validate that appliance stats by Appliance for a maximum value for min power of 100000 can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-86400); # 1 day ago
  my $end    = $self->{'neurioTest'}->local_8601(0); 
  my $test   = $self->{'neurio'}->fetch_Appliances_Stats_by_Appliance($self->{'appl_ID'},$begin,'days',$end,100000,1,10);
  $self->{'neurioTest'}->expectAPIPass($test,"Content was empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTest'}->validateApplianceStatsByAppliance($test)},"appliance event by appliance structure","validated",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceStatsByAppliance_Pos_15 {
  my $self   = shift;
  my $title  = "Fetching appliance stats by Appliance with no end date";
  my $testID = "ApplianceStatsByAppliance_Pos_15";
  my $desc   = "Validate that appliance stats by Appliance since a specific date can be retrieved\nwhen no end date is specified.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub ApplianceStatsByAppliance_Pos_16 {
  my $self   = shift;
  my $title  = "Fetching appliance stats by Appliance for a single entry per page";
  my $testID = "ApplianceStatsByAppliance_Pos_16";
  my $desc   = "Validate that appliance stats by Appliance can be fetched for 1 day for each hour\nand returned for a single sample per page.";
  my $defect = "Email May 18th";
  my $time1  = 0;
  my $time2  = 0;
  my $test;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-2160000); # 25 day ago
  my $end    = $self->{'neurioTest'}->local_8601(0);
  $test   = $self->{'neurio'}->fetch_Appliances_Stats_by_Appliance($self->{'appl_ID'},$begin,'days',$end,400,1,1);
  $self->{'neurioTest'}->expectAPIPass($test,"Content was empty",200,$defect);
  if ($self->{'neurioTest'}->expectPass(@{$test}[0],"Time1","valid",$defect)) {
    $time1 = str2time(@{$test}[0]->{'timestamp'});
  }  
  $test   = $self->{'neurio'}->fetch_Appliances_Stats_by_Appliance($self->{'appl_ID'},$begin,'days',$end,400,1,3);
  $self->{'neurioTest'}->expectAPIPass($test,"Content was empty",200,$defect);
  if ($self->{'neurioTest'}->expectPass(@{$test}[0],"Time2","valid",$defect)) {
    $time2 = str2time(@{$test}[0]->{'timestamp'});
  }
  $self->{'neurioTest'}->expectPass(eval{$time2-$time1 == 3600 },"Time difference","1 hour",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceStatsByAppliance_Pos_17 {
  my $self   = shift;
  my $title  = "Fetching appliance stats by Appliance for a default range of dates";
  my $testID = "ApplianceStatsByAppliance_Pos_17";
  my $desc   = "Validate that appliance stats by Appliance for a default range of dates can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub ApplianceStatsByAppliance_Pos_18 {
  my $self   = shift;
  my $title  = "Fetching appliance stats by Appliance for a specific ID";
  my $testID = "ApplianceStatsByAppliance_Pos_18";
  my $desc   = "Validate that appliance stats by Appliance for a specific ID can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub ApplianceStatsByAppliance_Pos_19 {
  my $self   = shift;
  my $title  = "Fetching appliance stats by Appliance for a granularity of 'unknown'";
  my $testID = "ApplianceStatsByAppliance_Pos_19";
  my $desc   = "Validate that appliance stats by Appliance for a granularity of 'unknown' can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-2160000);    # 25 days ago
  my $end    = $self->{'neurioTest'}->local_8601();
  my $test   = $self->{'neurio'}->fetch_Appliances_Stats_by_Appliance($self->{'appl_ID'},$begin,'unknown',$end);
  $self->{'neurioTest'}->expectAPIPass($test,"Content should not have been empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTest'}->validateApplianceStatsByAppliance($test)},"appliance event by appliance structure","validated",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


###################################################################################################
###################################################################################################
###################################################################################################
###################################################################################################


sub ApplianceStatsByAppliance_Neg_01 {
  my $self   = shift;
  my $title  = "Fetching appliance stats by appliance for a range greater than 25 hours in minutes";
  my $testID = "ApplianceStatsByAppliance_Neg_01";
  my $desc   = "Validate that appliance stats by appliance for a range greater than 1 day and 1 hour (25 hours) in intervals of 1 minute cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-91000); # more than 25 hours ago
  my $end    = $self->{'neurioTest'}->local_8601(0); 
  my $test   = $self->{'neurio'}->fetch_Appliances_Stats_by_Appliance($self->{'appl_ID'},$begin,'minutes',$end);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceStatsByAppliance_Neg_02 {
  my $self   = shift;
  my $title  = "Fetching appliance stats by appliance for a range greater than 25 hours in hours";
  my $testID = "ApplianceStatsByAppliance_Neg_02";
  my $desc   = "Validate that appliance stats by appliance for a range greater than 1 day and 1 hour (25 hours) in intervals of 1 hour cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-91000); # more than 25 hours ago
  my $end    = $self->{'neurioTest'}->local_8601(0); 
  my $test   = $self->{'neurio'}->fetch_Appliances_Stats_by_Appliance($self->{'appl_ID'},$begin,'hours',$end);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceStatsByAppliance_Neg_03 {
  my $self   = shift;
  my $title  = "Fetching appliance stats by appliance for a range greater than 1 month in days";
  my $testID = "ApplianceStatsByAppliance_Neg_03";
  my $desc   = "Validate that appliance stats by appliance for a range greater than 1 month in intervals of 1 day cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->fetch_Appliances_Stats_by_Appliance($self->{'appl_ID'},'2014-11-25T09:40:00-05:00','days','2014-12-26T09:40:00-05:00');
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceStatsByAppliance_Neg_04 {
  my $self   = shift;
  my $title  = "Fetching appliance stats by appliance for a range greater than 6 months in weeks";
  my $testID = "ApplianceStatsByAppliance_Neg_04";
  my $desc   = "Validate that appliance stats by appliance for a range greater than 6 months in intervals of 1 week cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->fetch_Appliances_Stats_by_Appliance($self->{'appl_ID'},'2014-06-25T09:40:00-05:00','weeks','2014-12-26T09:40:00-05:00');
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceStatsByAppliance_Neg_05 {
  my $self   = shift;
  my $title  = "Fetching appliance stats by appliance for a range greater than 1 year in months";
  my $testID = "ApplianceStatsByAppliance_Neg_05";
  my $desc   = "Validate that energy appliance by appliance for a range greater than 1 year in intervals of 1 month cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->fetch_Appliances_Stats_by_Appliance($self->{'appl_ID'},'2014-01-25T09:40:00-05:00','months','2015-02-25T09:40:00-05:00');
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceStatsByAppliance_Neg_06 {
  my $self   = shift;
  my $title  = "Fetching appliance stats by appliance for a range greater than 10 years in years";
  my $testID = "ApplianceStatsByAppliance_Neg_06";
  my $desc   = "Validate that energy appliance by appliance for a range greater than 10 years in intervals of 1 year cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->fetch_Appliances_Stats_by_Appliance($self->{'appl_ID'},'2005-01-25T09:40:00-05:00','years','2015-02-25T09:40:00-05:00');
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceStatsByAppliance_Neg_07 {
  my $self   = shift;
  my $title  = "Fetching appliance stats by Appliance for a start date with an invalid format";
  my $testID = "ApplianceStatsByAppliance_Neg_07";
  my $desc   = "Validate that appliance stats by Appliance for an invalid value for the start date cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->fetch_Appliances_Stats_by_Appliance($self->{'appl_ID'},'2015-01-35T09:00:00-05:00','minutes','2015-02-01T09:00:00-05:00');
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",404,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceStatsByAppliance_Neg_08 {
  my $self   = shift;
  my $title  = "Fetching appliance stats by Appliance for a end date with an invalid format";
  my $testID = "ApplianceStatsByAppliance_Neg_08";
  my $desc   = "Validate that appliance stats by Appliance for an invalid value for the end date cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->fetch_Appliances_Stats_by_Appliance($self->{'appl_ID'},'2015-01-01T09:00:00-05:00','minutes','2015-02-35T09:00:00-05:00');
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",404,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceStatsByAppliance_Neg_09 {
  my $self   = shift;
  my $title  = "Fetching appliance stats by Appliance for a start date later than the end date";
  my $testID = "ApplianceStatsByAppliance_Neg_09";
  my $desc   = "Validate that appliance stats by Appliance for a start date later than the end date cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hour ago
  my $end    = $self->{'neurioTest'}->local_8601(-7200); # 2 hours ago
  my $test   = $self->{'neurio'}->fetch_Appliances_Stats_by_Appliance($self->{'appl_ID'},$begin,'minutes',$end);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceStatsByAppliance_Neg_10 {
  my $self   = shift;
  my $title  = "Fetching appliance stats by Appliance for a start date in the future";
  my $testID = "ApplianceStatsByAppliance_Neg_10";
  my $desc   = "Validate that appliance stats by Appliance for a start date in the future cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(3600); # 1 hour in the future
  my $end    = $self->{'neurioTest'}->local_8601(0); 
  my $test   = $self->{'neurio'}->fetch_Appliances_Stats_by_Appliance($self->{'appl_ID'},$begin,'minutes',$end);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceStatsByAppliance_Neg_11 {
  my $self   = shift;
  my $title  = "Fetching appliance stats by Appliance for a granularity that is invalid";
  my $testID = "ApplianceStatsByAppliance_Neg_11";
  my $desc   = "Validate that appliance stats by Appliance for an invalid granularity cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hour ago
  my $end    = $self->{'neurioTest'}->local_8601(0); 
  my $test   = $self->{'neurio'}->fetch_Appliances_Stats_by_Appliance($self->{'appl_ID'},$begin,'moons',$end);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceStatsByAppliance_Neg_12 {
  my $self   = shift;
  my $title  = "Fetching appliance stats by Appliance for a frequency that is negative";
  my $testID = "ApplianceStatsByAppliance_Neg_12";
  my $desc   = "Validate that appliance stats by Appliance for a negative value of frequency cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub ApplianceStatsByAppliance_Neg_13 {
  my $self   = shift;
  my $title  = "Fetching appliance stats by Appliance for a frequency of zero";
  my $testID = "ApplianceStatsByAppliance_Neg_13";
  my $desc   = "Validate that appliance stats by Appliance for a zero frequency cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub ApplianceStatsByAppliance_Neg_14 {
  my $self   = shift;
  my $title  = "Fetching appliance stats by Appliance for a frequency greater than 1000 (max)";
  my $testID = "ApplianceStatsByAppliance_Neg_14";
  my $desc   = "Validate that appliance stats by Appliance for a frequency greater than 1000 cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub ApplianceStatsByAppliance_Neg_15 {
  my $self   = shift;
  my $title  = "Fetching appliance stats by Appliance for a perPage value that is negative";
  my $testID = "ApplianceStatsByAppliance_Neg_15";
  my $desc   = "Validate that appliance stats by Appliance for a negative perPage value cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hours ago
  my $end    = $self->{'neurioTest'}->local_8601(0);
  my $test   = $self->{'neurio'}->fetch_Appliances_Stats_by_Appliance($self->{'appl_ID'},$begin,'minutes',$end,500,-1,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceStatsByAppliance_Neg_16 {
  my $self   = shift;
  my $title  = "Fetching appliance stats by Appliance for a perPage value that is zero";
  my $testID = "ApplianceStatsByAppliance_Neg_16";
  my $desc   = "Validate that appliance stats by Appliance for a zero perPage value cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hours ago
  my $end    = $self->{'neurioTest'}->local_8601(0);
  my $test   = $self->{'neurio'}->fetch_Appliances_Stats_by_Appliance($self->{'appl_ID'},$begin,'minutes',$end,500,0,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceStatsByAppliance_Neg_17 {
  my $self   = shift;
  my $title  = "Fetching appliance stats by Appliance for a perPage values greater than 500 (max)";
  my $testID = "ApplianceStatsByAppliance_Neg_17";
  my $desc   = "Validate that appliance stats by Appliance for a value greater than the maximum of 500 cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hours ago
  my $end    = $self->{'neurioTest'}->local_8601(0);
  my $test   = $self->{'neurio'}->fetch_Appliances_Stats_by_Appliance($self->{'appl_ID'},$begin,'minutes',$end,500,501,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceStatsByAppliance_Neg_18 {
  my $self   = shift;
  my $title  = "Fetching appliance stats by Appliance for a page value that is negative";
  my $testID = "ApplianceStatsByAppliance_Neg_18";
  my $desc   = "Validate that appliance stats by Appliance for a negative page value cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hours ago
  my $end    = $self->{'neurioTest'}->local_8601(0);
  my $test   = $self->{'neurio'}->fetch_Appliances_Stats_by_Appliance($self->{'appl_ID'},$begin,'minutes',$end,500,10,-1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceStatsByAppliance_Neg_19 {
  my $self   = shift;
  my $title  = "Fetching appliance stats by Appliance for a page value that of zero";
  my $testID = "ApplianceStatsByAppliance_Neg_19";
  my $desc   = "Validate that appliance stats by Appliance for a zero page value cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hours ago
  my $end    = $self->{'neurioTest'}->local_8601(0);
  my $test   = $self->{'neurio'}->fetch_Appliances_Stats_by_Appliance($self->{'appl_ID'},$begin,'minutes',$end,500,10,0);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceStatsByAppliance_Neg_20 {
  my $self   = shift;
  my $title  = "Fetching appliance stats by Appliance for a page value greater than 100000 (max)";
  my $testID = "ApplianceStatsByAppliance_Neg_20";
  my $desc   = "Validate that appliance stats by Appliance for a page value greater than the maximum of 100000 cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hours ago
  my $end    = $self->{'neurioTest'}->local_8601(0);
  my $test   = $self->{'neurio'}->fetch_Appliances_Stats_by_Appliance($self->{'appl_ID'},$begin,'minutes',$end,500,10,100001);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceStatsByAppliance_Neg_21 {
  my $self   = shift;
  my $title  = "Fetching appliance stats by Appliance for an appliance ID that is unknown";
  my $testID = "ApplianceStatsByAppliance_Neg_21";
  my $desc   = "Validate that appliance stats by Appliance for an unknown ID cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hours ago
  my $end    = $self->{'neurioTest'}->local_8601(0);
  my $test   = $self->{'neurio'}->fetch_Appliances_Stats_by_Appliance('abc',$begin,'minutes',$end,500,10,10);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceStatsByAppliance_Neg_22 {
  my $self   = shift;
  my $title  = "Fetching appliance stats by Appliance for a granularity of minutes and a frequency less than 5";
  my $testID = "ApplianceStatsByAppliance_Neg_22";
  my $desc   = "Validate that appliance stats by Appliance for a granularity of minutes and a frequency less than 5 cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub ApplianceStatsByAppliance_Neg_23 {
  my $self   = shift;
  my $title  = "Fetching appliance stats by Appliance for a granularity of seconds";
  my $testID = "ApplianceStatsByAppliance_Neg_23";
  my $desc   = "Validate that appliance stats by Appliance for a granularity of seconds cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-2160000);    # 25 days ago
  my $end    = $self->{'neurioTest'}->local_8601();
  my $test   = $self->{'neurio'}->fetch_Appliances_Stats_by_Appliance($self->{'appl_ID'},$begin,'seconds',$end);
  $self->{'neurioTest'}->expectAPIFail($test,"Content was empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceStatsByAppliance_Neg_24 {
  my $self   = shift;
  my $title  = "Fetching appliance stats by Appliance for a granularity of minutes";
  my $testID = "ApplianceStatsByAppliance_Neg_24";
  my $desc   = "Validate that appliance stats by Appliance for a granularity of minutes cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-2160000);    # 25 days ago
  my $end    = $self->{'neurioTest'}->local_8601();
  my $test   = $self->{'neurio'}->fetch_Appliances_Stats_by_Appliance($self->{'appl_ID'},$begin,'minutes',$end);
  $self->{'neurioTest'}->expectAPIFail($test,"Content was empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceStatsByAppliance_Neg_25 {
  my $self   = shift;
  my $title  = "Fetching appliance stats by Appliance for a granularity of hours";
  my $testID = "ApplianceStatsByAppliance_Neg_25";
  my $desc   = "Validate that appliance stats by Appliance for a granularity of hours cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-2160000);    # 25 days ago
  my $end    = $self->{'neurioTest'}->local_8601();
  my $test   = $self->{'neurio'}->fetch_Appliances_Stats_by_Appliance($self->{'appl_ID'},$begin,'hours',$end);
  $self->{'neurioTest'}->expectAPIFail($test,"Content was empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceStatsByAppliance_Neg_26 {
  my $self   = shift;
  my $title  = "Fetching appliance stats by Appliance for a period of more than 1 month";
  my $testID = "ApplianceStatsByAppliance_Neg_26";
  my $desc   = "Validate that appliance stats by Appliance for a period of more than 1 month cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-2764800);    # 32 days ago
  my $end    = $self->{'neurioTest'}->local_8601();
  my $test   = $self->{'neurio'}->fetch_Appliances_Stats_by_Appliance($self->{'appl_ID'},$begin,'days',$end);
  $self->{'neurioTest'}->expectAPIFail($test,"Content was empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceStatsByAppliance_Neg_27 {
  my $self   = shift;
  my $title  = "Fetching appliance stats by Appliance for a min power value that is negative";
  my $testID = "ApplianceStatsByAppliance_Neg_27";
  my $desc   = "Validate that appliance stats by Appliance for a negative min power value cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hours ago
  my $end    = $self->{'neurioTest'}->local_8601(0);
  my $test   = $self->{'neurio'}->fetch_Appliances_Stats_by_Appliance($self->{'appl_ID'},$begin,'minutes',$end,-500,10,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceStatsByAppliance_Neg_28 {
  my $self   = shift;
  my $title  = "Fetching appliance stats by Appliance for a min power value of zero";
  my $testID = "ApplianceStatsByAppliance_Neg_28";
  my $desc   = "Validate that appliance stats by Appliance for a zero min power value cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hours ago
  my $end    = $self->{'neurioTest'}->local_8601(0);
  my $test   = $self->{'neurio'}->fetch_Appliances_Stats_by_Appliance($self->{'appl_ID'},$begin,'minutes',$end,0,10,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceStatsByAppliance_Neg_29 {
  my $self   = shift;
  my $title  = "Fetching appliance stats by Appliance for a min power value greater than 100000 (max)";
  my $testID = "ApplianceStatsByAppliance_Neg_29";
  my $desc   = "Validate that appliance stats by Appliance for a min power value greater than the maximum of 100000 cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hours ago
  my $end    = $self->{'neurioTest'}->local_8601(0);
  my $test   = $self->{'neurio'}->fetch_Appliances_Stats_by_Appliance($self->{'appl_ID'},$begin,'minutes',$end,100001,10,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceStatsByAppliance_Neg_30 {
  my $self   = shift;
  my $title  = "Fetching appliance stats by Appliance when missing required parameters";
  my $testID = "ApplianceStatsByAppliance_Neg_30";
  my $desc   = "Validate that appliance stats by Appliance when missing required parameters cannot be retrieved.";
  my $defect = undef;
  my $test;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hours ago
  my $end    = $self->{'neurioTest'}->local_8601(0);
  $test = $self->{'neurio'}->fetch_Appliances_Stats_by_Appliance($self->{'appl_ID'},$begin,'minutes');
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",404,$defect);
  $test = $self->{'neurio'}->fetch_Appliances_Stats_by_Appliance($self->{'appl_ID'},$begin);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",404,$defect);
  $test = $self->{'neurio'}->fetch_Appliances_Stats_by_Appliance($self->{'appl_ID'});
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",404,$defect);
  $test = $self->{'neurio'}->fetch_Appliances_Stats_by_Appliance();
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",404,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


1
