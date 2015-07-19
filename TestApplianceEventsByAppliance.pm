package TestApplianceEventsByAppliance;

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
      print "\nTestApplianceEventsByAppliance->new(): Neurio, NeurioTest and NeurioTools are REQUIRED parameters\n";
      return 0;
    }

    $self->{'appl_ID'} = $self->{'neurioTools'}->get_appliance_ID('heater');
    if ($self->{'appl_ID'} == 0) {
      my $test = $self->{'neurio'}->add_Appliance($self->{'neurio'}->{'location_id'},"heater","heater test");
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

sub ApplianceEventsByAppliance_Pos_01 {
  my $self   = shift;
  my $title  = "Fetching appliance events by Appliance for a date range of exactly 25 hours in minutes";
  my $testID = "ApplianceEventsByAppliance_Pos_01";
  my $desc   = "Validate that appliance events by Appliance for a date range of exactly 1 day and 1 hour\n(25 hours) in intervals of 1 minute can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurioTest'}->expectPass($self->{'appl_ID'},"Appliance ID","defined");
  my $begin  = $self->{'neurioTest'}->local_8601(-90000); # 25 hours ago
  my $end    = $self->{'neurioTest'}->local_8601(0); 
  my $test   = $self->{'neurio'}->fetch_Appliances_Events_by_Appliance($self->{'appl_ID'},$begin,$end,500,1,1);
  $self->{'neurioTest'}->expectAPIPass($test,"Content was empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTest'}->validateApplianceEventsByAppliance($test)},"Appliance by appliance structure","validated",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceEventsByAppliance_Pos_02 {
  my $self   = shift;
  my $title  = "Fetching appliance events by Appliance for a date range of exactly 25 hours in hours";
  my $testID = "ApplianceEventsByAppliance_Pos_02";
  my $desc   = "Validate that appliance events by Appliance for a date range of exactly 1 day and 1 hour\n(25 hours) in intervals of 1 hour can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub ApplianceEventsByAppliance_Pos_03 {
  my $self   = shift;
  my $title  = "Fetching appliance events by Appliance for a date range of exactly 1 month in days";
  my $testID = "ApplianceEventsByAppliance_Pos_03";
  my $desc   = "Validate that appliance events by Appliance for a date range of exactly 1 month in intervals of 1 day can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub ApplianceEventsByAppliance_Pos_04 {
  my $self   = shift;
  my $title  = "Fetching appliance events by Appliance for a date range of exactly 6 months in weeks";
  my $testID = "ApplianceEventsByAppliance_Pos_04";
  my $desc   = "Validate that appliance events by Appliance for a date range of exactly 6 months in intervals of 1 week can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub ApplianceEventsByAppliance_Pos_05 {
  my $self   = shift;
  my $title  = "Fetching appliance events by Appliance for a date range of exactly 1 year in months";
  my $testID = "ApplianceEventsByAppliance_Pos_05";
  my $desc   = "Validate that appliance events by Appliance for a date range of exactly 1 year in intervals of 1 month can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub ApplianceEventsByAppliance_Pos_06 {
  my $self   = shift;
  my $title  = "Fetching appliance events by Appliance for a date range of exactly 10 years in years";
  my $testID = "ApplianceEventsByAppliance_Pos_06";
  my $desc   = "Validate that appliance events by Appliance for a date range of exactly 10 years in intervals of 1 year can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub ApplianceEventsByAppliance_Pos_07 {
  my $self   = shift;
  my $title  = "Fetching appliance events by Appliance for a frequency of 1 (min)";
  my $testID = "ApplianceEventsByAppliance_Pos_07";
  my $desc   = "Validate that appliance events by Appliance for a frequency for a minimum value of 1 can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub ApplianceEventsByAppliance_Pos_08 {
  my $self   = shift;
  my $title  = "Fetching appliance events by Appliance for a frequency of 1000 (max)";
  my $testID = "ApplianceEventsByAppliance_Pos_08";
  my $desc   = "Validate that appliance events by Appliance for a frequency for a maximum value of 1000 can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub ApplianceEventsByAppliance_Pos_09 {
  my $self   = shift;
  my $title  = "Fetching appliance events by Appliance for a perPage of 1 (min)";
  my $testID = "ApplianceEventsByAppliance_Pos_09";
  my $desc   = "Validate that appliance events by Appliance for a perPage for a minimum value of 1 can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurioTest'}->expectPass($self->{'appl_ID'},"Appliance ID","defined");
  my $begin  = $self->{'neurioTest'}->local_8601(-86400); # 1 day ago
  my $end    = $self->{'neurioTest'}->local_8601(0); 
  my $test   = $self->{'neurio'}->fetch_Appliances_Events_by_Appliance($self->{'appl_ID'},$begin,$end,500,1,1);
  $self->{'neurioTest'}->expectAPIPass($test,"Content was empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTest'}->validateApplianceEventsByAppliance($test)},"Appliance event by appliance structure","validated",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceEventsByAppliance_Pos_10 {
  my $self   = shift;
  my $title  = "Fetching appliance events by Appliance for a perPage of 500 (max)";
  my $testID = "ApplianceEventsByAppliance_Pos_10";
  my $desc   = "Validate that appliance events by Appliance for a perPage for a maximum value of 500 can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurioTest'}->expectPass($self->{'appl_ID'},"Appliance ID","defined");
  my $begin  = $self->{'neurioTest'}->local_8601(-86400); # 1 day ago
  my $end    = $self->{'neurioTest'}->local_8601(0); 
  my $test   = $self->{'neurio'}->fetch_Appliances_Events_by_Appliance($self->{'appl_ID'},$begin,$end,500,500,1);
  $self->{'neurioTest'}->expectAPIPass($test,"Content was empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTest'}->validateApplianceEventsByAppliance($test)},"Appliance event by appliance structure","validated",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceEventsByAppliance_Pos_11 {
  my $self   = shift;
  my $title  = "Fetching appliance events by Appliance for a page of 1 (min)";
  my $testID = "ApplianceEventsByAppliance_Pos_11";
  my $desc   = "Validate that appliance events by Appliance for a page for a minimum value of 1 can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurioTest'}->expectPass($self->{'appl_ID'},"Appliance ID","defined");
  my $begin  = $self->{'neurioTest'}->local_8601(-86400); # 1 day ago
  my $end    = $self->{'neurioTest'}->local_8601(0); 
  my $test   = $self->{'neurio'}->fetch_Appliances_Events_by_Appliance($self->{'appl_ID'},$begin,$end,500,1,1);
  $self->{'neurioTest'}->expectAPIPass($test,"Content was empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTest'}->validateApplianceEventsByAppliance($test)},"Appliance event by appliance structure","validated",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceEventsByAppliance_Pos_12 {
  my $self   = shift;
  my $title  = "Fetching appliance events by Appliance for a page of 100000 (max)";
  my $testID = "ApplianceEventsByAppliance_Pos_12";
  my $desc   = "Validate that appliance events by Appliance for a page for a maximum value of 100000 can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurioTest'}->expectPass($self->{'appl_ID'},"Appliance ID","defined");
  my $begin  = $self->{'neurioTest'}->local_8601(-86400); # 1 day ago
  my $end    = $self->{'neurioTest'}->local_8601(0); 
  my $test   = $self->{'neurio'}->fetch_Appliances_Events_by_Appliance($self->{'appl_ID'},$begin,$end,500,1,100000);
  $self->{'neurioTest'}->expectAPIPass($test,"Content was empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTest'}->validateApplianceEventsByAppliance($test)},"appliance events by appliance structure","validated",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceEventsByAppliance_Pos_13 {
  my $self   = shift;
  my $title  = "Fetching appliance events by Appliance for a min power of 1 (min)";
  my $testID = "ApplianceEventsByAppliance_Pos_13";
  my $desc   = "Validate that appliance events by Appliance for a minimum value for min power of 1 can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurioTest'}->expectPass($self->{'appl_ID'},"Appliance ID","defined");
  my $begin  = $self->{'neurioTest'}->local_8601(-86400); # 1 day ago
  my $end    = $self->{'neurioTest'}->local_8601(0); 
  my $test   = $self->{'neurio'}->fetch_Appliances_Events_by_Appliance($self->{'appl_ID'},$begin,$end,1,1,10);
  $self->{'neurioTest'}->expectAPIPass($test,"Content was empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTest'}->validateApplianceEventsByAppliance($test)},"appliance event by appliance structure","validated",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceEventsByAppliance_Pos_14 {
  my $self   = shift;
  my $title  = "Fetching appliance events by Appliance for a min power of 100000 (max)";
  my $testID = "ApplianceEventsByAppliance_Pos_14";
  my $desc   = "Validate that appliance events by Appliance for a maximum value for min power of 100000 can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurioTest'}->expectPass($self->{'appl_ID'},"Appliance ID","defined");
  my $begin  = $self->{'neurioTest'}->local_8601(-86400); # 1 day ago
  my $end    = $self->{'neurioTest'}->local_8601(0); 
  my $test   = $self->{'neurio'}->fetch_Appliances_Events_by_Appliance($self->{'appl_ID'},$begin,$end,100000,1,10);
  $self->{'neurioTest'}->expectAPIPass($test,"Content was empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTest'}->validateApplianceEventsByAppliance($test)},"appliance event by appliance structure","validated",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceEventsByAppliance_Pos_15 {
  my $self   = shift;
  my $title  = "Fetching appliance events by Appliance with no end date";
  my $testID = "ApplianceEventsByAppliance_Pos_15";
  my $desc   = "Validate that appliance events by Appliance since a specific date can be retrieved\nwhen no end date is specified.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub ApplianceEventsByAppliance_Pos_16 {
  my $self   = shift;
  my $title  = "Fetching appliance events by Appliance for a single entry per page";
  my $testID = "ApplianceEventsByAppliance_Pos_16";
  my $desc   = "Validate that appliance events by Appliance can be fetched for 1 day for each hour\nand returned for a single sample per page.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub ApplianceEventsByAppliance_Pos_17 {
  my $self   = shift;
  my $title  = "Fetching appliance events by Appliance for a default range of dates";
  my $testID = "ApplianceEventsByAppliance_Pos_17";
  my $desc   = "Validate that appliance events by Appliance for a default range of dates can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub ApplianceEventsByAppliance_Pos_18 {
  my $self   = shift;
  my $title  = "Fetching appliance events by Appliance for a specific ID";
  my $testID = "ApplianceEventsByAppliance_Pos_18";
  my $desc   = "Validate that appliance events by Appliance for a specific ID can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub ApplianceEventsByAppliance_Pos_19 {
  my $self   = shift;
  my $title  = "Fetching appliance events by Appliance for a granularity of 'unknown'";
  my $testID = "ApplianceEventsByAppliance_Pos_19";
  my $desc   = "Validate that appliance events by Appliance for a granularity of 'unknown' can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}



###################################################################################################
###################################################################################################
###################################################################################################
###################################################################################################

sub ApplianceEventsByAppliance_Neg_01 {
  my $self   = shift;
  my $title  = "Fetching appliance events by Appliance for a range greater than 25 hours in minutes";
  my $testID = "ApplianceEventsByAppliance_Neg_01";
  my $desc   = "Validate that appliance events by Appliance for a range greater than 1 day and 1 hour (25 hours) in intervals of 1 minute cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub ApplianceEventsByAppliance_Neg_02 {
  my $self   = shift;
  my $title  = "Fetching appliance events by Appliance for a range greater than 25 hours in hours";
  my $testID = "ApplianceEventsByAppliance_Neg_02";
  my $desc   = "Validate that appliance events by Appliance for a range greater than 1 day and 1 hour (25 hours) in intervals of 1 hour cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-91000); # more than 25 hours ago
  my $end    = $self->{'neurioTest'}->local_8601(0); 
  my $test   = $self->{'neurio'}->fetch_Appliances_Events_by_Appliance($self->{'appl_ID'},$begin,$end);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceEventsByAppliance_Neg_03 {
  my $self   = shift;
  my $title  = "Fetching appliance events by Appliance for a range greater than 1 month in days";
  my $testID = "ApplianceEventsByAppliance_Neg_03";
  my $desc   = "Validate that appliance events by Appliance for a range greater than 1 month in intervals of 1 day cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub ApplianceEventsByAppliance_Neg_04 {
  my $self   = shift;
  my $title  = "Fetching appliance events by Appliance for a range greater than 6 months in weeks";
  my $testID = "ApplianceEventsByAppliance_Neg_04";
  my $desc   = "Validate that appliance events by Appliance for a range greater than 6 months in intervals of 1 week cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub ApplianceEventsByAppliance_Neg_05 {
  my $self   = shift;
  my $title  = "Fetching appliance events by Appliance for a range greater than 1 year in months";
  my $testID = "ApplianceEventsByAppliance_Neg_05";
  my $desc   = "Validate that energy appliance by location for a range greater than 1 year in intervals of 1 month cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub ApplianceEventsByAppliance_Neg_06 {
  my $self   = shift;
  my $title  = "Fetching appliance events by Appliance for a range greater than 10 years in years";
  my $testID = "ApplianceEventsByAppliance_Neg_06";
  my $desc   = "Validate that energy appliance by location for a range greater than 10 years in intervals of 1 year cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub ApplianceEventsByAppliance_Neg_07 {
  my $self   = shift;
  my $title  = "Fetching appliance events by Appliance for a start date with an invalid format";
  my $testID = "ApplianceEventsByAppliance_Neg_07";
  my $desc   = "Validate that appliance events by Appliance for an invalid value for the start date cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->fetch_Appliances_Events_by_Appliance($self->{'appl_ID'},'2015-01-35T09:00:00-05:00','2015-02-01T09:00:00-05:00');
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",404,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceEventsByAppliance_Neg_08 {
  my $self   = shift;
  my $title  = "Fetching appliance events by Appliance for a end date with an invalid format";
  my $testID = "ApplianceEventsByAppliance_Neg_08";
  my $desc   = "Validate that appliance events by Appliance for an invalid value for the end date cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->fetch_Appliances_Events_by_Appliance($self->{'appl_ID'},'2015-01-01T09:00:00-05:00','2015-02-35T09:00:00-05:00');
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",404,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceEventsByAppliance_Neg_09 {
  my $self   = shift;
  my $title  = "Fetching appliance events by Appliance for a start date later than the end date";
  my $testID = "ApplianceEventsByAppliance_Neg_09";
  my $desc   = "Validate that appliance events by Appliance for a start date later than the end date cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hour ago
  my $end    = $self->{'neurioTest'}->local_8601(-7200); # 2 hours ago
  my $test   = $self->{'neurio'}->fetch_Appliances_Events_by_Appliance($self->{'appl_ID'},$begin,$end);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceEventsByAppliance_Neg_10 {
  my $self   = shift;
  my $title  = "Fetching appliance events by Appliance for a start date in the future";
  my $testID = "ApplianceEventsByAppliance_Neg_10";
  my $desc   = "Validate that appliance events by Appliance for a start date in the future cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(3600); # 1 hour in the future
  my $end    = $self->{'neurioTest'}->local_8601(0); 
  my $test   = $self->{'neurio'}->fetch_Appliances_Events_by_Appliance($self->{'appl_ID'},$begin,$end);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceEventsByAppliance_Neg_11 {
  my $self   = shift;
  my $title  = "Fetching appliance events by Appliance for a granularity that is invalid";
  my $testID = "ApplianceEventsByAppliance_Neg_11";
  my $desc   = "Validate that appliance events by Appliance for an invalid granularity cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub ApplianceEventsByAppliance_Neg_12 {
  my $self   = shift;
  my $title  = "Fetching appliance events by Appliance for a frequency that is negative";
  my $testID = "ApplianceEventsByAppliance_Neg_12";
  my $desc   = "Validate that appliance events by Appliance for a negative value of frequency cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub ApplianceEventsByAppliance_Neg_13 {
  my $self   = shift;
  my $title  = "Fetching appliance events by Appliance for a frequency of zero";
  my $testID = "ApplianceEventsByAppliance_Neg_13";
  my $desc   = "Validate that appliance events by Appliance for a zero frequency cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub ApplianceEventsByAppliance_Neg_14 {
  my $self   = shift;
  my $title  = "Fetching appliance events by Appliance for a frequency greater than 1000 (max)";
  my $testID = "ApplianceEventsByAppliance_Neg_14";
  my $desc   = "Validate that appliance events by Appliance for a frequency greater than 1000 cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub ApplianceEventsByAppliance_Neg_15 {
  my $self   = shift;
  my $title  = "Fetching appliance events by Appliance for a perPage value that is negative";
  my $testID = "ApplianceEventsByAppliance_Neg_15";
  my $desc   = "Validate that appliance events by Appliance for a negative perPage value cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hours ago
  my $end    = $self->{'neurioTest'}->local_8601(0);
  my $test   = $self->{'neurio'}->fetch_Appliances_Events_by_Appliance($self->{'appl_ID'},$begin,$end,500,-1,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceEventsByAppliance_Neg_16 {
  my $self   = shift;
  my $title  = "Fetching appliance events by Appliance for a perPage value that is zero";
  my $testID = "ApplianceEventsByAppliance_Neg_16";
  my $desc   = "Validate that appliance events by Appliance for a zero perPage value cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hours ago
  my $end    = $self->{'neurioTest'}->local_8601(0);
  my $test   = $self->{'neurio'}->fetch_Appliances_Events_by_Appliance($self->{'appl_ID'},$begin,$end,500,0,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceEventsByAppliance_Neg_17 {
  my $self   = shift;
  my $title  = "Fetching appliance events by Appliance for a perPage values greater than 1000 (max)";
  my $testID = "ApplianceEventsByAppliance_Neg_17";
  my $desc   = "Validate that appliance events by Appliance for a value greater than the maximum of 1000 cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hours ago
  my $end    = $self->{'neurioTest'}->local_8601(0);
  my $test   = $self->{'neurio'}->fetch_Appliances_Events_by_Appliance($self->{'appl_ID'},$begin,$end,500,1001,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceEventsByAppliance_Neg_18 {
  my $self   = shift;
  my $title  = "Fetching appliance events by Appliance for a page value that is negative";
  my $testID = "ApplianceEventsByAppliance_Neg_18";
  my $desc   = "Validate that appliance events by Appliance for a negative page value cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hours ago
  my $end    = $self->{'neurioTest'}->local_8601(0);
  my $test   = $self->{'neurio'}->fetch_Appliances_Events_by_Appliance($self->{'appl_ID'},$begin,$end,500,10,-1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceEventsByAppliance_Neg_19 {
  my $self   = shift;
  my $title  = "Fetching appliance events by Appliance for a page value that of zero";
  my $testID = "ApplianceEventsByAppliance_Neg_19";
  my $desc   = "Validate that appliance events by Appliance for a zero page value cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hours ago
  my $end    = $self->{'neurioTest'}->local_8601(0);
  my $test   = $self->{'neurio'}->fetch_Appliances_Events_by_Appliance($self->{'appl_ID'},$begin,$end,500,10,0);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceEventsByAppliance_Neg_20 {
  my $self   = shift;
  my $title  = "Fetching appliance events by Appliance for a page value greater than 100000 (max)";
  my $testID = "ApplianceEventsByAppliance_Neg_20";
  my $desc   = "Validate that appliance events by Appliance for a page value greater than the maximum of 100000 cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hours ago
  my $end    = $self->{'neurioTest'}->local_8601(0);
  my $test   = $self->{'neurio'}->fetch_Appliances_Events_by_Appliance($self->{'appl_ID'},$begin,$end,500,10,100001);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceEventsByAppliance_Neg_21 {
  my $self   = shift;
  my $title  = "Fetching appliance events by Appliance for an appliance ID that is unknown";
  my $testID = "ApplianceEventsByAppliance_Neg_21";
  my $desc   = "Validate that appliance events by Appliance for an unknown appliance ID cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hours ago
  my $test   = $self->{'neurio'}->fetch_Appliances_Events_Recent('abc',$begin,500,10,1);
  $self->{'neurioTest'}->expectAPIPass(defined $test,"Content should have been empty",200,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceEventsByAppliance_Neg_22 {
  my $self   = shift;
  my $title  = "Fetching appliance events by Appliance for a granularity of minutes and a frequency less than 5";
  my $testID = "ApplianceEventsByAppliance_Neg_22";
  my $desc   = "Validate that appliance events by Appliance for a granularity of minutes and a frequency less than 5 cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub ApplianceEventsByAppliance_Neg_23 {
  my $self   = shift;
  my $title  = "Fetching appliance events by Appliance for a granularity of seconds";
  my $testID = "ApplianceEventsByAppliance_Neg_23";
  my $desc   = "Validate that appliance events by Appliance for a granularity of seconds cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub ApplianceEventsByAppliance_Neg_24 {
  my $self   = shift;
  my $title  = "Fetching appliance events by Appliance for a granularity of minutes";
  my $testID = "ApplianceEventsByAppliance_Neg_24";
  my $desc   = "Validate that appliance events by Appliance for a granularity of minutes cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub ApplianceEventsByAppliance_Neg_25 {
  my $self   = shift;
  my $title  = "Fetching appliance events by Appliance for a granularity of hours";
  my $testID = "ApplianceEventsByAppliance_Neg_25";
  my $desc   = "Validate that appliance events by Appliance for a granularity of hours cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub ApplianceEventsByAppliance_Neg_26 {
  my $self   = shift;
  my $title  = "Fetching appliance events by Appliance for a period of more than 1 month";
  my $testID = "ApplianceEventsByAppliance_Neg_26";
  my $desc   = "Validate that appliance events by Appliance for a period of more than 1 month cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub ApplianceEventsByAppliance_Neg_27 {
  my $self   = shift;
  my $title  = "Fetching appliance events by Appliance for a min power value that is negative";
  my $testID = "ApplianceEventsByAppliance_Neg_27";
  my $desc   = "Validate that appliance events by Appliance for a negative min power value cannot be retrieved.";
  my $defect = "NEURIOEXT-37/NEURIOKS-1653";
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hours ago
  my $end    = $self->{'neurioTest'}->local_8601(0);
  my $test   = $self->{'neurio'}->fetch_Appliances_Events_by_Appliance($self->{'appl_ID'},$begin,$end,-500,10,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceEventsByAppliance_Neg_28 {
  my $self   = shift;
  my $title  = "Fetching appliance events by Appliance for a min power value of zero";
  my $testID = "ApplianceEventsByAppliance_Neg_28";
  my $desc   = "Validate that appliance events by Appliance for a zero min power value cannot be retrieved.";
  my $defect = "NEURIOEXT-37/NEURIOKS-1653";
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hours ago
  my $end    = $self->{'neurioTest'}->local_8601(0);
  my $test   = $self->{'neurio'}->fetch_Appliances_Events_by_Appliance($self->{'appl_ID'},$begin,$end,0,10,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceEventsByAppliance_Neg_29 {
  my $self   = shift;
  my $title  = "Fetching appliance events by Appliance for a min power value greater than 100000 (max)";
  my $testID = "ApplianceEventsByAppliance_Neg_29";
  my $desc   = "Validate that appliance events by Appliance for a min power value greater than the maximum of 100000 cannot be retrieved.";
  my $defect = "NEURIOEXT-37/NEURIOKS-1653";
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hours ago
  my $end    = $self->{'neurioTest'}->local_8601(0);
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->fetch_Appliances_Events_by_Appliance($self->{'appl_ID'},$begin,$end,100001,10,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ApplianceEventsByAppliance_Neg_30 {
  my $self   = shift;
  my $title  = "Fetching appliance events by Appliance when missing required parameters";
  my $testID = "ApplianceEventsByAppliance_Neg_30";
  my $desc   = "Validate that appliance events by Appliance when missing required parameters cannot be retrieved.";
  my $defect = "NEURIOEXT-41/NEURIOKS-1651";
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hours ago
  my $end    = $self->{'neurioTest'}->local_8601(0);
  my $test;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $test = $self->{'neurio'}->fetch_Appliances_Events_by_Appliance($self->{'appl_ID'},$begin);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",422,$defect);
  $test = $self->{'neurio'}->fetch_Appliances_Events_by_Appliance($self->{'appl_ID'});
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",422,$defect);
  $test = $self->{'neurio'}->fetch_Appliances_Events_by_Appliance();
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",404,$defect);
  $self->{'neurioTest'}->closeTestCase();
}

1
