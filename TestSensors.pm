package TestSensors;

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
      print "\nTestSensors->new(): Neurio, NeurioTest and NeurioTools are REQUIRED parameters\n";
      return 0;
    }
    
    bless $self, $class;
    
    return $self;
}

sub DESTROY {
    my $self = shift;
    
    print"\nDestroying ".ref($self), " instance...\n\n";

    undef $self->{'neurioTools'};
    undef $self->{'neurioTest'};
    undef $self->{'neurio'};
}


###################################################################################################
###################################################################################################
###################################################################################################
###################################################################################################

sub Sensors_Pos_01 {
  my $self   = shift;
  my $title  = "Fetching sensor data for a date range of exactly 25 hours in minutes";
  my $testID = "Sensors_Pos_01";
  my $desc   = "Validate that sensor data for a date range of exactly 1 day and 1 hour\n(25 hours) in intervals of 1 minute can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Sensors_Pos_02 {
  my $self   = shift;
  my $title  = "Fetching sensor data for a date range of exactly 25 hours in hours";
  my $testID = "Sensors_Pos_02";
  my $desc   = "Validate that sensor data for a date range of exactly 1 day and 1 hour\n(25 hours) in intervals of 1 hour can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Sensors_Pos_03 {
  my $self   = shift;
  my $title  = "Fetching sensor data for a date range of exactly 1 month in days";
  my $testID = "Sensors_Pos_03";
  my $desc   = "Validate that sensor data for a date range of exactly 1 month in intervals of 1 day can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Sensors_Pos_04 {
  my $self   = shift;
  my $title  = "Fetching sensor data for a date range of exactly 6 months in weeks";
  my $testID = "Sensors_Pos_04";
  my $desc   = "Validate that sensor data for a date range of exactly 6 months in intervals of 1 week can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Sensors_Pos_05 {
  my $self   = shift;
  my $title  = "Fetching sensor data for a date range of exactly 1 year in months";
  my $testID = "Sensors_Pos_05";
  my $desc   = "Validate that sensor data for a date range of exactly 1 year in intervals of 1 month can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Sensors_Pos_06 {
  my $self   = shift;
  my $title  = "Fetching sensor data for a date range of exactly 10 years in years";
  my $testID = "Sensors_Pos_06";
  my $desc   = "Validate that sensor data for a date range of exactly 10 years in intervals of 1 year can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Sensors_Pos_07 {
  my $self   = shift;
  my $title  = "Fetching sensor data for a frequency of 1 (min)";
  my $testID = "Sensors_Pos_07";
  my $desc   = "Validate that cyclee data for a frequency for a minimum value of 1 can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Sensors_Pos_08 {
  my $self   = shift;
  my $title  = "Fetching sensor data for a frequency of 1000 (max)";
  my $testID = "Sensors_Pos_08";
  my $desc   = "Validate that sensor data for a frequency for a maximum value of 1000 can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Sensors_Pos_09 {
  my $self   = shift;
  my $title  = "Fetching sensor data for a perPage of 1 (min)";
  my $testID = "Sensors_Pos_09";
  my $desc   = "Validate that sensor data for a perPage for a minimum value of 1 can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->fetch_Sensors(1,1);
  $self->{'neurioTest'}->expectAPIPass($test,"Content was empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTest'}->validateSensors($test)},"Sensor structure","validated",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Sensors_Pos_10 {
  my $self   = shift;
  my $title  = "Fetching sensor data for a perPage of 500 (max)";
  my $testID = "Sensors_Pos_10";
  my $desc   = "Validate that sensor data for a perPage for a maximum value of 500 can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->fetch_Sensors(500,1);
  $self->{'neurioTest'}->expectAPIPass($test,"Content was empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTest'}->validateSensors($test)},"Sensor structure","validated",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Sensors_Pos_11 {
  my $self   = shift;
  my $title  = "Fetching sensor data for a page of 1 (min)";
  my $testID = "Sensors_Pos_11";
  my $desc   = "Validate that sensor data for a page for a minimum value of 1 can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->fetch_Sensors(1,1);
  $self->{'neurioTest'}->expectAPIPass($test,"Content was empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTest'}->validateSensors($test)},"Sensor structure","validated",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Sensors_Pos_12 {
  my $self   = shift;
  my $title  = "Fetching sensor data for a page of 100000 (max)";
  my $testID = "Sensors_Pos_12";
  my $desc   = "Validate that sensor data for a page for a maximum value of 100000 can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->fetch_Sensors(1,100000);
  $self->{'neurioTest'}->expectAPIPass($test,"Content was empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTest'}->validateSensors($test)},"Sensor structure","validated",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Sensors_Pos_13 {
  my $self   = shift;
  my $title  = "Fetching sensor data for a minimum value for min power of 1 (min)";
  my $testID = "Sensors_Pos_13";
  my $desc   = "Validate that sensor data for a minimum value of min power can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Sensors_Pos_14 {
  my $self   = shift;
  my $title  = "Fetching sensor data for a maximum value for min power of 100000 (max)";
  my $testID = "Sensors_Pos_14";
  my $desc   = "Validate that sensor data for a maximum value for min poiwer of 100000 can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Sensors_Pos_15 {
  my $self   = shift;
  my $title  = "Fetching sensor data with no end date";
  my $testID = "Sensors_Pos_15";
  my $desc   = "Validate that sensor data since a specific date can be retrieved\nwhen no end date is specified.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Sensors_Pos_16 {
  my $self   = shift;
  my $title  = "Fetching sensor data for cycles for a single entry per page";
  my $testID = "Sensors_Pos_16";
  my $desc   = "Validate that sensor data for a single entry per page";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Sensors_Pos_17 {
  my $self   = shift;
  my $title  = "Fetching sensor data for a specific sensor for the default range of dates";
  my $testID = "Sensors_Pos_17";
  my $desc   = "Validate that sensor data for a specific sensor for the default date range can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Sensors_Pos_18 {
  my $self   = shift;
  my $title  = "Fetching sensor data for a specific ID";
  my $testID = "Sensors_Pos_18";
  my $desc   = "Validate that sensor data for specific ID can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Sensors_Pos_19 {
  my $self   = shift;
  my $title  = "Fetching cycle for a granularity of 'unknown";
  my $testID = "Sensors_Pos_19";
  my $desc   = "Validate that cycle for a granularity of 'unknown' can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


###################################################################################################
###################################################################################################
###################################################################################################
###################################################################################################


sub Sensors_Neg_01 {
  my $self   = shift;
  my $title  = "Fetching sensor data for a range greater than 25 hours in minutes";
  my $testID = "Sensors_Neg_01";
  my $desc   = "Validate that sensor data for a specific sensor for a range greater than 25 hours in minutes cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Sensors_Neg_02 {
  my $self   = shift;
  my $title  = "Fetching sensor data for a range greater than 25 hours in hours";
  my $testID = "Sensors_Neg_02";
  my $desc   = "Validate that sensor data for a specific sensor for a range greater than 25 hours in hours cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Sensors_Neg_03 {
  my $self   = shift;
  my $title  = "Fetching sensor data for a range greater than 1 month in days";
  my $testID = "Sensors_Neg_03";
  my $desc   = "Validate that sensor data for a specific sensor for a range greater than 1 month in days cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Sensors_Neg_04 {
  my $self   = shift;
  my $title  = "Fetching sensor data for a range greater than 6 months in weeks";
  my $testID = "Sensors_Neg_04";
  my $desc   = "Validate that sensor data for a specific sensor for a range greater than 6 months in weeks cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Sensors_Neg_05 {
  my $self   = shift;
  my $title  = "Fetching sensor data for a range greater than 1 year in months";
  my $testID = "Sensors_Neg_05";
  my $desc   = "Validate that sensor data for a specific sensor for a range greater than 1 year in months cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Sensors_Neg_06 {
  my $self   = shift;
  my $title  = "Fetching sensor data for a range greater than 10 years in years";
  my $testID = "Sensors_Neg_06";
  my $desc   = "Validate that sensor data for a specific sensor for a range greater than 10 years in years cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Sensors_Neg_07 {
  my $self   = shift;
  my $title  = "Fetching sensor data for a start date with an invalid format";
  my $testID = "Sensors_Neg_07";
  my $desc   = "Validate that sensor data for a specific sensor for an invalid format for start date cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Sensors_Neg_08 {
  my $self   = shift;
  my $title  = "Fetching sensor data for a end date with an invalid format";
  my $testID = "Sensors_Neg_08";
  my $desc   = "Validate that sensor data for a specific sensor for an invalid format for end date cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Sensors_Neg_09 {
  my $self   = shift;
  my $title  = "Fetching sensor data for a start date later than the end date";
  my $testID = "Sensors_Neg_09";
  my $desc   = "Validate that sensor data for a specific sensor for a start date later than the end date cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Sensors_Neg_10 {
  my $self   = shift;
  my $title  = "Fetching sensor data for a start date in the future";
  my $testID = "Sensors_Neg_10";
  my $desc   = "Validate that sensor data for a specific sensor for a start date in the future cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Sensors_Neg_11 {
  my $self   = shift;
  my $title  = "Fetching sensor data for a granularity that is invalid";
  my $testID = "Sensors_Neg_11";
  my $desc   = "Validate that sensor data for a specific sensor for a granularity that is invalid cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Sensors_Neg_12 {
  my $self   = shift;
  my $title  = "Fetching sensor data for a frequency value that is negative";
  my $testID = "Sensors_Neg_12";
  my $desc   = "Validate that sensor data for a specific sensor for a negative value for frequency cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Sensors_Neg_13 {
  my $self   = shift;
  my $title  = "Fetching sensor data for a frequency value of zero";
  my $testID = "Sensors_Neg_13";
  my $desc   = "Validate that sensor data for a specific sensor for a zero value for frequency cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Sensors_Neg_14 {
  my $self   = shift;
  my $title  = "Fetching sensor data for a frequency value that is greater than 1000 (max)";
  my $testID = "Sensors_Neg_14";
  my $desc   = "Validate that sensor data for a specific sensor for a value for frequency that is greater than 1000 cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Sensors_Neg_15 {
  my $self   = shift;
  my $title  = "Fetching sensor data for a perPage value that is negative";
  my $testID = "Sensors_Neg_15";
  my $desc   = "Validate that sensor data for a specific sensor for a negative value for perPage cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->fetch_Sensors(-1,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Sensors_Neg_16 {
  my $self   = shift;
  my $title  = "Fetching sensor data for a perPage value of zero";
  my $testID = "Sensors_Neg_16";
  my $desc   = "Validate that sensor data for a specific sensor for a zero value of perPage cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->fetch_Sensors(0,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Sensors_Neg_17 {
  my $self   = shift;
  my $title  = "Fetching sensor data for a perPage value greater than 500 (max)";
  my $testID = "Sensors_Neg_17";
  my $desc   = "Validate that sensor data for a perPage value greater than the maximum of 500 cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->fetch_Sensors(501,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Sensors_Neg_18 {
  my $self   = shift;
  my $title  = "Fetching sensor data for a page value that is negative";
  my $testID = "Sensors_Neg_18";
  my $desc   = "Validate that sensor data for a specific sensor for a negative value for page cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->fetch_Sensors(10,-1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Sensors_Neg_19 {
  my $self   = shift;
  my $title  = "Fetching sensor data for a page value of zero";
  my $testID = "Sensors_Neg_19";
  my $desc   = "Validate that sensor data for a specific sensor for a zero value of page cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->fetch_Sensors(10,0);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Sensors_Neg_20 {
  my $self   = shift;
  my $title  = "Fetching sensor data for a page value greater than 100000 (max)";
  my $testID = "Sensors_Neg_20";
  my $desc   = "Validate that sensor data for a value of page greater than the maximum of 100000 cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->fetch_Sensors(10,100001);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Sensors_Neg_21 {
  my $self   = shift;
  my $title  = "Fetching sensor data for an ID that is unknown";
  my $testID = "Sensors_Neg_21";
  my $desc   = "Validate that sensor data for an unknown ID cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Sensors_Neg_22 {
  my $self   = shift;
  my $title  = "Fetching sensor data for a granularity of minutes and a frequency less than 5";
  my $testID = "Sensors_Neg_22";
  my $desc   = "Validate that sensor data for a specific sensor for a granularity of minutes and a frequency less than 5 cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Sensors_Neg_23 {
  my $self   = shift;
  my $title  = "Fetching sensor data for a granularity in seconds";
  my $testID = "Sensors_Neg_23";
  my $desc   = "Validate that sensor data for a specific sensor for a granularity in seconds cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}

sub Sensors_Neg_24 {
  my $self   = shift;
  my $title  = "Fetching sensor data for a granularity of minutes";
  my $testID = "Sensors_Neg_24";
  my $desc   = "Validate that sensor data for a granularity of minutes cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Sensors_Neg_25 {
  my $self   = shift;
  my $title  = "Fetching sensor data for a granularity of hours";
  my $testID = "Sensors_Neg_25";
  my $desc   = "Validate that sensor data for a granularity of hours cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Sensors_Neg_26 {
  my $self   = shift;
  my $title  = "Fetching sensor data for a period of more than 1 month";
  my $testID = "Sensors_Neg_26";
  my $desc   = "Validate that sensor data for a period of more than 1 month cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Sensors_Neg_27 {
  my $self   = shift;
  my $title  = "Fetching sensor data for a min power value that is negative";
  my $testID = "Sensors_Neg_27";
  my $desc   = "Validate that sensor data for a negative min power value cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Sensors_Neg_28 {
  my $self   = shift;
  my $title  = "Fetching sensor data for a min power value that of zero";
  my $testID = "Sensors_Neg_28";
  my $desc   = "Validate that sensor data for a zero min power value cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Sensors_Neg_29 {
  my $self   = shift;
  my $title  = "Fetching sensor data for a min power value greater than 100000 (max)";
  my $testID = "Sensors_Neg_29";
  my $desc   = "Validate that sensor data for a min power value greater than the maximum of 100000 cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Sensors_Neg_30 {
  my $self   = shift;
  my $title  = "Fetching sensor data when missing required parameters";
  my $testID = "Sensors_Neg_30";
  my $desc   = "Validate that sensor data when missing required parameters cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}

1
