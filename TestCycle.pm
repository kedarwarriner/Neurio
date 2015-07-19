package TestCycle;

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
      print "\nTestCycle->new(): Neurio, NeurioTest and NeurioTools are REQUIRED parameters\n";
      return 0;
    }
    
    $self->{'cycle_ID'} = $self->{'neurioTools'}->get_cycle_ID();
    $self->{'neurioTest'}->expectPass($self->{'cycle_ID'},"Cycle_ID","defined");

    bless $self, $class;
    
    return $self;
}

sub DESTROY {
    my $self = shift;
    
    print"\nDestroying ".ref($self), " instance...\n\n";

    undef $self->{'cycle_ID'};
    undef $self->{'neurioTools'};
    undef $self->{'neurioTest'};
    undef $self->{'neurio'};
}


###################################################################################################
###################################################################################################
###################################################################################################
###################################################################################################

sub Cycle_Pos_01 {
  my $self   = shift;
  my $title  = "Fetching cycle data for a date range of exactly 25 hours in minutes";
  my $testID = "Cycle_Pos_01";
  my $desc   = "Validate that cycle data for a date range of exactly 1 day and 1 hour\n(25 hours) in intervals of 1 minute can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-90000); # 25 hours ago
  my $end    = $self->{'neurioTest'}->local_8601(0);
  my $test   = $self->{'neurio'}->fetch_Cycles_by_Sensor($begin, $end);
  $self->{'neurioTest'}->expectAPIPass($test,"Content was empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTest'}->validateCycles($test)},"cycle structure","validated",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Cycle_Pos_02 {
  my $self   = shift;
  my $title  = "Fetching cycle data for a date range of exactly 25 hours in hours";
  my $testID = "Cycle_Pos_02";
  my $desc   = "Validate that cycle data for a date range of exactly 1 day and 1 hour\n(25 hours) in intervals of 1 hour can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Cycle_Pos_03 {
  my $self   = shift;
  my $title  = "Fetching cycle data for a date range of exactly 1 month in days";
  my $testID = "Cycle_Pos_03";
  my $desc   = "Validate that cycle data for a date range of exactly 1 month in intervals of 1 day can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Cycle_Pos_04 {
  my $self   = shift;
  my $title  = "Fetching cycle data for a date range of exactly 6 months in weeks";
  my $testID = "Cycle_Pos_04";
  my $desc   = "Validate that cycle data for a date range of exactly 6 months in intervals of 1 week can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Cycle_Pos_05 {
  my $self   = shift;
  my $title  = "Fetching cycle data for a date range of exactly 1 year in months";
  my $testID = "Cycle_Pos_05";
  my $desc   = "Validate that cycle data for a date range of exactly 1 year in intervals of 1 month can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Cycle_Pos_06 {
  my $self   = shift;
  my $title  = "Fetching cycle data for a date range of exactly 10 years in years";
  my $testID = "Cycle_Pos_06";
  my $desc   = "Validate that cycle data for a date range of exactly 10 years in intervals of 1 year can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Cycle_Pos_07 {
  my $self   = shift;
  my $title  = "Fetching cycle data for a frequency of 1 (min)";
  my $testID = "Cycle_Pos_07";
  my $desc   = "Validate that cyclee data for a frequency for a minimum value of 1 can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Cycle_Pos_08 {
  my $self   = shift;
  my $title  = "Fetching cycle data for a frequency of 1000 (max)";
  my $testID = "Cycle_Pos_08";
  my $desc   = "Validate that cycle data for a frequency for a maximum value of 1000 can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Cycle_Pos_09 {
  my $self   = shift;
  my $title  = "Fetching cycle data for a perPage of 1 (min)";
  my $testID = "Cycle_Pos_09";
  my $desc   = "Validate that cycle data for a perPage for a minimum value of 1 can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hour ago
  my $end    = $self->{'neurioTest'}->local_8601(0); 
  my $test   = $self->{'neurio'}->fetch_Cycles_by_Sensor($begin,$end,1,1);
  $self->{'neurioTest'}->expectAPIPass($test,"Content was empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTest'}->validateCycles($test)},"cycle structure","validated",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Cycle_Pos_10 {
  my $self   = shift;
  my $title  = "Fetching cycle data for a perPage of 500 (max)";
  my $testID = "Cycle_Pos_10";
  my $desc   = "Validate that cycle data for a perPage for a maximum value of 500 can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hour ago
  my $end    = $self->{'neurioTest'}->local_8601(0); 
  my $test   = $self->{'neurio'}->fetch_Cycles_by_Sensor($begin,$end,500,1);
  $self->{'neurioTest'}->expectAPIPass($test,"Content was empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTest'}->validateCycles($test)},"cycle structure","validated",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Cycle_Pos_11 {
  my $self   = shift;
  my $title  = "Fetching cycle data for a page of 1 (min)";
  my $testID = "Cycle_Pos_11";
  my $desc   = "Validate that cycle data for a page for a minimum value of 1 can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hour ago
  my $end    = $self->{'neurioTest'}->local_8601(0); 
  my $test   = $self->{'neurio'}->fetch_Cycles_by_Sensor($begin,$end,1,1);
  $self->{'neurioTest'}->expectAPIPass($test,"Content was empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTest'}->validateCycles($test)},"cycle structure","validated",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Cycle_Pos_12 {
  my $self   = shift;
  my $title  = "Fetching cycle data for a page of 100000 (max)";
  my $testID = "Cycle_Pos_12";
  my $desc   = "Validate that cycle data for a page for a maximum value of 100000 can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hour ago
  my $end    = $self->{'neurioTest'}->local_8601(0); 
  my $test   = $self->{'neurio'}->fetch_Cycles_by_Sensor($begin,$end,1,100000);
  $self->{'neurioTest'}->expectAPIPass($test,"Content was empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTest'}->validateCycles($test)},"cycle structure","validated",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Cycle_Pos_13 {
  my $self   = shift;
  my $title  = "Fetching cycle data for a minimum value for min power of 1 (min)";
  my $testID = "Cycle_Pos_13";
  my $desc   = "Validate that cycle data for a minimum value of min power can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Cycle_Pos_14 {
  my $self   = shift;
  my $title  = "Fetching cycle data for a maximum value for min power of 100000 (max)";
  my $testID = "Cycle_Pos_14";
  my $desc   = "Validate that cycle data for a maximum value for min poiwer of 100000 can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Cycle_Pos_15 {
  my $self   = shift;
  my $title  = "Fetching cycle data with no end date";
  my $testID = "Cycle_Pos_15";
  my $desc   = "Validate that cycle data since a specific date can be retrieved\nwhen no end date is specified.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-864000); # 10 days ago
  my $test   = $self->{'neurio'}->fetch_Cycles_by_Sensor($begin);
  $self->{'neurioTest'}->expectAPIPass($test,"Content was empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTest'}->validateCycles($test)},"cycle structure","validated",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Cycle_Pos_16 {
  my $self   = shift;
  my $title  = "Fetching cycle data for cycles for a single entry per page";
  my $testID = "Cycle_Pos_16";
  my $desc   = "Validate that cycle data for a single entry per page";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Cycle_Pos_17 {
  my $self   = shift;
  my $title  = "Fetching cycle data for a specific sensor for the default range of dates";
  my $testID = "Cycle_Pos_17";
  my $desc   = "Validate that cycle data for a specific sensor for the default date range can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->fetch_Cycles_by_Sensor();
  $self->{'neurioTest'}->expectAPIPass($test,"Content was empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTest'}->validateCycles($test)},"cycle structure","validated",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Cycle_Pos_18 {
  my $self   = shift;
  my $title  = "Fetching cycle data for a specific cycle ID";
  my $testID = "Cycle_Pos_18";
  my $desc   = "Validate that cycle data for specific cycle ID can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->fetch_Cycle($self->{'cycle_ID'});
  $self->{'neurioTest'}->expectAPIPass($test,"Content was empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTest'}->validateCycle($test)},"cycle structure","validated",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Cycle_Pos_19 {
  my $self   = shift;
  my $title  = "Fetching cycle for a granularity of 'unknown";
  my $testID = "Cycle_Pos_19";
  my $desc   = "Validate that cycle for a granularity of 'unknown' can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


###################################################################################################
###################################################################################################
###################################################################################################
###################################################################################################


sub Cycle_Neg_01 {
  my $self   = shift;
  my $title  = "Fetching cycle data for a range greater than 25 hours in minutes";
  my $testID = "Cycle_Neg_01";
  my $desc   = "Validate that cycle data for a specific sensor for a range greater than 25 hours in minutes cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Cycle_Neg_02 {
  my $self   = shift;
  my $title  = "Fetching cycle data for a range greater than 25 hours in hours";
  my $testID = "Cycle_Neg_02";
  my $desc   = "Validate that cycle data for a specific sensor for a range greater than 25 hours in hours cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Cycle_Neg_03 {
  my $self   = shift;
  my $title  = "Fetching cycle data for a range greater than 1 month in days";
  my $testID = "Cycle_Neg_03";
  my $desc   = "Validate that cycle data for a specific sensor for a range greater than 1 month in days cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Cycle_Neg_04 {
  my $self   = shift;
  my $title  = "Fetching cycle data for a range greater than 6 months in weeks";
  my $testID = "Cycle_Neg_04";
  my $desc   = "Validate that cycle data for a specific sensor for a range greater than 6 months in weeks cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Cycle_Neg_05 {
  my $self   = shift;
  my $title  = "Fetching cycle data for a range greater than 1 year in months";
  my $testID = "Cycle_Neg_05";
  my $desc   = "Validate that cycle data for a specific sensor for a range greater than 1 year in months cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Cycle_Neg_06 {
  my $self   = shift;
  my $title  = "Fetching cycle data for a range greater than 10 years in years";
  my $testID = "Cycle_Neg_06";
  my $desc   = "Validate that cycle data for a specific sensor for a range greater than 10 years in years cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Cycle_Neg_07 {
  my $self   = shift;
  my $title  = "Fetching cycle data for a start date with an invalid format";
  my $testID = "Cycle_Neg_07";
  my $desc   = "Validate that cycle data for a specific sensor for an invalid format for start date cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->fetch_Cycles_by_Sensor('2015-01-35T13:00:00Z', '2015-01-05T15:00:00Z',10,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Cycle_Neg_08 {
  my $self   = shift;
  my $title  = "Fetching cycle data for a end date with an invalid format";
  my $testID = "Cycle_Neg_08";
  my $desc   = "Validate that cycle data for a specific sensor for an invalid format for end date cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->fetch_Cycles_by_Sensor('2015-01-35T13:00:00Z', '2015-01-35T15:00:00Z',10,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Cycle_Neg_09 {
  my $self   = shift;
  my $title  = "Fetching cycle data for a start date later than the end date";
  my $testID = "Cycle_Neg_09";
  my $desc   = "Validate that cycle data for a specific sensor for a start date later than the end date cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hour ago
  my $end    = $self->{'neurioTest'}->local_8601(-7200); # 2 hours ago
  my $test   = $self->{'neurio'}->fetch_Cycles_by_Sensor($begin, $end,10,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",422,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Cycle_Neg_10 {
  my $self   = shift;
  my $title  = "Fetching cycle data for a start date in the future";
  my $testID = "Cycle_Neg_10";
  my $desc   = "Validate that cycle data for a specific sensor for a start date in the future cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(3600); # 1 hour from now
  my $test   = $self->{'neurio'}->fetch_Cycles_by_Sensor($begin);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",422,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Cycle_Neg_11 {
  my $self   = shift;
  my $title  = "Fetching cycle data for a granularity that is invalid";
  my $testID = "Cycle_Neg_11";
  my $desc   = "Validate that cycle data for a specific sensor for a granularity that is invalid cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Cycle_Neg_12 {
  my $self   = shift;
  my $title  = "Fetching cycle data for a frequency value that is negative";
  my $testID = "Cycle_Neg_12";
  my $desc   = "Validate that cycle data for a specific sensor for a negative value for frequency cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Cycle_Neg_13 {
  my $self   = shift;
  my $title  = "Fetching cycle data for a frequency value of zero";
  my $testID = "Cycle_Neg_13";
  my $desc   = "Validate that cycle data for a specific sensor for a zero value for frequency cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Cycle_Neg_14 {
  my $self   = shift;
  my $title  = "Fetching cycle data for a frequency value that is greater than 1000 (max)";
  my $testID = "Cycle_Neg_14";
  my $desc   = "Validate that cycle data for a specific sensor for a value for frequency that is greater than 1000 cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Cycle_Neg_15 {
  my $self   = shift;
  my $title  = "Fetching cycle data for a perPage value that is negative";
  my $testID = "Cycle_Neg_15";
  my $desc   = "Validate that cycle data for a specific sensor for a negative value for perPage cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hour ago
  my $end    = $self->{'neurioTest'}->local_8601(0); 
  my $test   = $self->{'neurio'}->fetch_Cycles_by_Sensor($begin, $end,-1,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Cycle_Neg_16 {
  my $self   = shift;
  my $title  = "Fetching cycle data for a perPage value of zero";
  my $testID = "Cycle_Neg_16";
  my $desc   = "Validate that cycle data for a specific sensor for a zero value of perPage cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hour ago
  my $end    = $self->{'neurioTest'}->local_8601(0); 
  my $test   = $self->{'neurio'}->fetch_Cycles_by_Sensor($begin, $end,0,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Cycle_Neg_17 {
  my $self   = shift;
  my $title  = "Fetching cycle data for a perPage value greater than 500 (max)";
  my $testID = "Cycle_Neg_17";
  my $desc   = "Validate that cycle data for a perPage value greater than the maximum of 500 cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hour ago
  my $end    = $self->{'neurioTest'}->local_8601(0); 
  my $test   = $self->{'neurio'}->fetch_Cycles_by_Sensor($begin, $end,501,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Cycle_Neg_18 {
  my $self   = shift;
  my $title  = "Fetching cycle data for a page value that is negative";
  my $testID = "Cycle_Neg_18";
  my $desc   = "Validate that cycle data for a specific sensor for a negative value for page cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hour ago
  my $end    = $self->{'neurioTest'}->local_8601(0); 
  my $test   = $self->{'neurio'}->fetch_Cycles_by_Sensor($begin, $end,10,-1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Cycle_Neg_19 {
  my $self   = shift;
  my $title  = "Fetching cycle data for a page value of zero";
  my $testID = "Cycle_Neg_19";
  my $desc   = "Validate that cycle data for a specific sensor for a zero value of page cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hour ago
  my $end    = $self->{'neurioTest'}->local_8601(0); 
  my $test   = $self->{'neurio'}->fetch_Cycles_by_Sensor($begin, $end,10,0);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Cycle_Neg_20 {
  my $self   = shift;
  my $title  = "Fetching cycle data for a page value greater than 100000 (max)";
  my $testID = "Cycle_Neg_20";
  my $desc   = "Validate that cycle data for a value of page greater than the maximum of 100000 cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hour ago
  my $end    = $self->{'neurioTest'}->local_8601(0); 
  my $test   = $self->{'neurio'}->fetch_Cycles_by_Sensor($begin, $end,10,100001);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Cycle_Neg_21 {
  my $self   = shift;
  my $title  = "Fetching cycle data for a cycle ID that is unknown";
  my $testID = "Cycle_Neg_21";
  my $desc   = "Validate that cycle data for an unknown cycle ID cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->fetch_Cycle('abc');
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",404,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Cycle_Neg_22 {
  my $self   = shift;
  my $title  = "Fetching cycle data for a granularity of minutes and a frequency less than 5";
  my $testID = "Cycle_Neg_22";
  my $desc   = "Validate that cycle data for a specific sensor for a granularity of minutes and a frequency less than 5 cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Cycle_Neg_23 {
  my $self   = shift;
  my $title  = "Fetching cycle data for a granularity in seconds";
  my $testID = "Cycle_Neg_23";
  my $desc   = "Validate that cycle data for a specific sensor for a granularity in seconds cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}

sub Cycle_Neg_24 {
  my $self   = shift;
  my $title  = "Fetching cycle data for a granularity of minutes";
  my $testID = "Cycle_Neg_24";
  my $desc   = "Validate that cycle data for a granularity of minutes cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Cycle_Neg_25 {
  my $self   = shift;
  my $title  = "Fetching cycle data for a granularity of hours";
  my $testID = "Cycle_Neg_25";
  my $desc   = "Validate that cycle data for a granularity of hours cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Cycle_Neg_26 {
  my $self   = shift;
  my $title  = "Fetching cycle data for a period of more than 1 month";
  my $testID = "Cycle_Neg_26";
  my $desc   = "Validate that cycle data for a period of more than 1 month cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Cycle_Neg_27 {
  my $self   = shift;
  my $title  = "Fetching cycle data for a min power value that is negative";
  my $testID = "Cycle_Neg_27";
  my $desc   = "Validate that cycle data for a negative min power value cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Cycle_Neg_28 {
  my $self   = shift;
  my $title  = "Fetching cycle data for a min power value that of zero";
  my $testID = "Cycle_Neg_28";
  my $desc   = "Validate that cycle data for a zero min power value cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Cycle_Neg_29 {
  my $self   = shift;
  my $title  = "Fetching cycle data for a min power value greater than 100000 (max)";
  my $testID = "Cycle_Neg_29";
  my $desc   = "Validate that cycle data for a min power value greater than the maximum of 100000 cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}

sub Cycle_Neg_30 {
  my $self   = shift;
  my $title  = "Fetching cycle data when missing required parameters";
  my $testID = "Cycle_Neg_30";
  my $desc   = "Validate that cycle data when missing required parameters cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}
1
