package TestSample;

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
      print "\nTestSample->new(): Neurio, NeurioTest and NeurioTools are REQUIRED parameters\n";
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


sub Sample_Pos_01 {
  my $self   = shift;
  my $title  = "Fetching sample data for a date range of exactly 25 hours in minutes";
  my $testID = "Sample_Pos_01";
  my $desc   = "Validate that sample data for a date range of exactly 1 day and 1 hour\n(25 hours) in intervals of 1 minute can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-90000); # 25 hours ago
  my $end    = $self->{'neurioTest'}->local_8601(0); 
  my $test   = $self->{'neurio'}->fetch_Samples($begin,'minutes',$end,5,10,1);
  $self->{'neurioTest'}->expectAPIPass($test,"Content was empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTest'}->validateSamples($test)},"Sample structure","validated",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Sample_Pos_02 {
  my $self   = shift;
  my $title  = "Fetching sample data for a date range of exactly 25 hours in hours";
  my $testID = "Sample_Pos_02";
  my $desc   = "Validate that sample data for a date range of exactly 1 day and 1 hour\n(25 hours) in intervals of 1 hour can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-90000); # 25 hours ago
  my $end    = $self->{'neurioTest'}->local_8601(0); 
  my $test   = $self->{'neurio'}->fetch_Samples($begin,'hours',$end,5,10,1);
  $self->{'neurioTest'}->expectAPIPass($test,"Content was empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTest'}->validateSamples($test)},"Sample structure","validated",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Sample_Pos_03 {
  my $self   = shift;
  my $title  = "Fetching sample data for a date range of exactly 1 month in days";
  my $testID = "Sample_Pos_03";
  my $desc   = "Validate that sample data for a date range of exactly 1 month in intervals of 1 day can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->fetch_Samples('2014-11-25T09:40:00-05:00','days','2014-12-25T09:40:00-05:00',5,10,1);
  $self->{'neurioTest'}->expectAPIPass($test,"Content was empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTest'}->validateSamples($test)},"Sample structure","validated",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Sample_Pos_04 {
  my $self   = shift;
  my $title  = "Fetching sample data for a date range of exactly 6 months in weeks";
  my $testID = "Sample_Pos_04";
  my $desc   = "Validate that sample data for a date range of exactly 6 months in intervals of 1 week can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->fetch_Samples('2014-06-25T09:40:00-05:00','weeks','2014-12-25T09:40:00-05:00',5,10,1);
  $self->{'neurioTest'}->expectAPIPass($test,"Content was empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTest'}->validateSamples($test)},"Sample structure","validated",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Sample_Pos_05 {
  my $self   = shift;
  my $title  = "Fetching sample data for a date range of exactly 1 year in months";
  my $testID = "Sample_Pos_05";
  my $desc   = "Validate that sample data for a date range of exactly 1 year in intervals of 1 month can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->fetch_Samples('2014-01-01T09:40:00-05:00','months','2015-01-01T09:40:00-05:00',5,10,1);
  $self->{'neurioTest'}->expectAPIPass($test,"Content was empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTest'}->validateSamples($test)},"Sample structure","validated",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Sample_Pos_06 {
  my $self   = shift;
  my $title  = "Fetching sample data for a date range of exactly 10 years in years";
  my $testID = "Sample_Pos_06";
  my $desc   = "Validate that sample data for a date range of exactly 10 years in intervals of 1 year can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->fetch_Samples('2005-01-01T09:40:00-05:00','years','2015-01-01T09:40:00-05:00',5,10,1);
  $self->{'neurioTest'}->expectAPIPass($test,"Content was empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTest'}->validateSamples($test)},"Sample structure","validated",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Sample_Pos_07 {
  my $self   = shift;
  my $title  = "Fetching sample data for a frequency of 1 (min)";
  my $testID = "Sample_Pos_07";
  my $desc   = "Validate that sample data for a frequency for a minimum value of 1 can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hour ago
  my $end    = $self->{'neurioTest'}->local_8601(0); 
  my $test   = $self->{'neurio'}->fetch_Samples($begin,'hours',$end,1,10,1);
  $self->{'neurioTest'}->expectAPIPass($test,"Content was empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTest'}->validateSamples($test)},"Sample structure","validated",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Sample_Pos_08 {
  my $self   = shift;
  my $title  = "Fetching sample data for a frequency of 1000 (max)";
  my $testID = "Sample_Pos_08";
  my $desc   = "Validate that sample data for a frequency for a maximum value of 1000 can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hour ago
  my $end    = $self->{'neurioTest'}->local_8601(0); 
  my $test   = $self->{'neurio'}->fetch_Samples($begin,'hours',$end,1000,10,1);
  $self->{'neurioTest'}->expectAPIPass($test,"Content was empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTest'}->validateSamples($test)},"Sample structure","validated",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Sample_Pos_09 {
  my $self   = shift;
  my $title  = "Fetching sample data for a perPage of 1 (min)";
  my $testID = "Sample_Pos_09";
  my $desc   = "Validate that sample data for a perPage for a minimum value of 1 can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hour ago
  my $end    = $self->{'neurioTest'}->local_8601(0); 
  my $test   = $self->{'neurio'}->fetch_Samples($begin,'hours',$end,1,1,1);
  $self->{'neurioTest'}->expectAPIPass($test,"Content was empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTest'}->validateSamples($test)},"Sample structure","validated",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Sample_Pos_10 {
  my $self   = shift;
  my $title  = "Fetching sample data for a perPage of 500 (max)";
  my $testID = "Sample_Pos_10";
  my $desc   = "Validate that sample data for a perPage for a maximum value of 500 can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hour ago
  my $end    = $self->{'neurioTest'}->local_8601(0); 
  my $test   = $self->{'neurio'}->fetch_Samples($begin,'hours',$end,1,500,1);
  $self->{'neurioTest'}->expectAPIPass($test,"Content was empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTest'}->validateSamples($test)},"Sample structure","validated",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Sample_Pos_11 {
  my $self   = shift;
  my $title  = "Fetching sample data for a page of 1 (min)";
  my $testID = "Sample_Pos_11";
  my $desc   = "Validate that sample data for a page for a minimum value of 1 can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hour ago
  my $end    = $self->{'neurioTest'}->local_8601(0); 
  my $test   = $self->{'neurio'}->fetch_Samples($begin,'hours',$end,1,1,1);
  $self->{'neurioTest'}->expectAPIPass($test,"Content was empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTest'}->validateSamples($test)},"Sample structure","validated",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Sample_Pos_12 {
  my $self   = shift;
  my $title  = "Fetching sample data for a page of 100000 (max)";
  my $testID = "Sample_Pos_12";
  my $desc   = "Validate that sample data for a page for a maximum value of 100000 can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hour ago
  my $end    = $self->{'neurioTest'}->local_8601(0); 
  my $test   = $self->{'neurio'}->fetch_Samples($begin,'hours',$end,1,1,100000);
  $self->{'neurioTest'}->expectAPIPass($test,"Content was empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTest'}->validateSamples($test)},"Sample structure","validated",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Sample_Pos_13 {
  my $self   = shift;
  my $title  = "Fetching sample data for a min power of 1 (min)";
  my $testID = "FullSample_Pos_13";
  my $desc   = "Validate that sample data for a minimum value for min power of 1 can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Sample_Pos_14 {
  my $self   = shift;
  my $title  = "Fetching sample data for a min power of 100000 (max)";
  my $testID = "FullSample_Pos_14";
  my $desc   = "Validate that sample data for a maximum value for min power of 100000 can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Sample_Pos_15 {
  my $self   = shift;
  my $title  = "Fetching sample data with no end date";
  my $testID = "Sample_Pos_15";
  my $desc   = "Validate that sample data since a specific date can be retrieved\nwhen no end date is specified.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-864000); # 10 days ago
  my $test   = $self->{'neurio'}->fetch_Samples($begin,'days');
  $self->{'neurioTest'}->expectAPIPass($test,"Content was empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTest'}->validateSamples($test)},"Sample structure","validated",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Sample_Pos_16 {
  my $self   = shift;
  my $title  = "Fetching sample data for a single entry per page";
  my $testID = "Sample_Pos_16";
  my $desc   = "Validate that sample data can be fetched for 1 day for each hour\nand returned as a single sample per page.";
  my $defect = undef;
  my $begin  = $self->{'neurioTest'}->local_8601(-86400); # 1 day ago
  my $end    = $self->{'neurioTest'}->local_8601(0);
  my $time1  = 0;
  my $time2  = 0;
  my $test;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $test = $self->{'neurio'}->fetch_Samples($begin,'hours',$end,1,1,1);
  $self->{'neurioTest'}->expectAPIPass($test,"Content was empty",200,$defect);
  if ($self->{'neurioTest'}->expectPass(@{$test}[0],"Time1","valid",$defect)) {
    $time1 = str2time(@{$test}[0]->{'timestamp'});
  }  
  $test = $self->{'neurio'}->fetch_Samples($begin,'hours',$end,1,1,2);
  $self->{'neurioTest'}->expectAPIPass($test,"Content was empty",200,$defect);
  if ($self->{'neurioTest'}->expectPass(@{$test}[0],"Time2","valid",$defect)) {
    $time2 = str2time(@{$test}[0]->{'timestamp'});
  }
  $self->{'neurioTest'}->expectPass(eval{$time2-$time1 == 3600 },"Time difference","1 hour",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Sample_Pos_17 {
  my $self   = shift;
  my $title  = "Fetching sample data for a default range of dates";
  my $testID = "Sample_Pos_17";
  my $desc   = "Validate that sample data for a default range of dates can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Sample_Pos_18 {
  my $self   = shift;
  my $title  = "Fetching sample data for a specific ID";
  my $testID = "Sample_Pos_18";
  my $desc   = "Validate that sample data for a specific ID can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Sample_Pos_19 {
  my $self   = shift;
  my $title  = "Fetching Samples for a granularity of 'unknown'";
  my $testID = "Sample_Pos_10";
  my $desc   = "Validate that Samples for a granularity of 'unknown' can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}



###################################################################################################
###################################################################################################
###################################################################################################
###################################################################################################

sub Sample_Neg_01 {
  my $self   = shift;
  my $title  = "Fetching sample data for a range greater than 25 hours in minutes";
  my $testID = "Sample_Neg_01";
  my $desc   = "Validate that sample data for a range greater than 1 day and 1 hour\n(25 hours) in minutes cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-91000); # more than 25 hours ago
  my $end    = $self->{'neurioTest'}->local_8601(0);
  my $test   = $self->{'neurio'}->fetch_Samples($begin,'minutes',$end,5,10,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Sample_Neg_02 {
  my $self   = shift;
  my $title  = "Fetching sample data for a range greater than 25 hours in hours";
  my $testID = "Sample_Neg_02";
  my $desc   = "Validate that sample data for a range greater than 1 day and 1 hour\n(25 hours) in hours cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-91000); # more than 25 hours ago
  my $end    = $self->{'neurioTest'}->local_8601(0);
  my $test   = $self->{'neurio'}->fetch_Samples($begin,'hours',$end,5,10,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Sample_Neg_03 {
  my $self   = shift;
  my $title  = "Fetching sample data for a range greater than 1 month in days";
  my $testID = "Sample_Neg_03";
  my $desc   = "Validate that sample data for a range greater than 1 month in intervals of 1 day cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->fetch_Samples('2015-05-25T09:40:00-05:00','days','2015-06-26T09:40:00-05:00',5,10,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Sample_Neg_04 {
  my $self   = shift;
  my $title  = "Fetching sample data for a range greater than 6 months in weeks";
  my $testID = "Sample_Neg_04";
  my $desc   = "Validate that sample data for a range greater than 6 months in intervals of 1 week cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->fetch_Samples('2014-06-25T09:40:00-05:00','weeks','2014-12-26T09:40:00-05:00',5,10,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Sample_Neg_05 {
  my $self   = shift;
  my $title  = "Fetching sample data for a range greater than 1 year in months";
  my $testID = "Sample_Neg_05";
  my $desc   = "Validate that sample data for a range greater than 1 year in intervals of 1 month cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->fetch_Samples('2014-01-01T09:40:00-05:00','months','2015-02-01T09:40:00-05:00',5,10,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Sample_Neg_06 {
  my $self   = shift;
  my $title  = "Fetching sample data for a range greater than 10 years in years";
  my $testID = "Sample_Neg_06";
  my $desc   = "Validate that sample data for a range greater than 10 years in intervals of 1 year cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->fetch_Samples('2005-01-01T09:40:00-05:00','years','2015-02-01T09:40:00-05:00',5,10,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Sample_Neg_07 {
  my $self   = shift;
  my $title  = "Fetching sample data for a start date with an invalid format";
  my $testID = "Sample_Neg_07";
  my $desc   = "Validate that sample data for an invalid format for the start\ndate cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->fetch_Samples('2014-01-35T09:40:00-05:00','months','2015-02-25T09:40:00-05:00',5,10,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Sample_Neg_08 {
  my $self   = shift;
  my $title  = "Fetching sample data for a end date with an invalid format";
  my $testID = "Sample_Neg_08";
  my $desc   = "Validate that sample data for an invalid format for the end date\ncannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->fetch_Samples('2014-01-25T09:40:00-05:00','months','2015-02-35T09:40:00-05:00',5,10,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Sample_Neg_09 {
  my $self   = shift;
  my $title  = "Fetching sample data for a start date later than the end date";
  my $testID = "Sample_Neg_09";
  my $desc   = "Validate that sample data for a start date later than the end\ndate cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hours ago
  my $end    = $self->{'neurioTest'}->local_8601(-7200); # 2 hour ago
  my $test   = $self->{'neurio'}->fetch_Samples($begin,'minutes',$end,1,10,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Sample_Neg_10 {
  my $self   = shift;
  my $title  = "Fetching sample data for a start date in the future";
  my $testID = "Sample_Neg_10";
  my $desc   = "Validate that sample data for a start date in the future cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(3600); # 1 hours from now
  my $test   = $self->{'neurio'}->fetch_Samples($begin,'minutes');
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Sample_Neg_11 {
  my $self   = shift;
  my $title  = "Fetching sample data for a granularity that is invalid";
  my $testID = "Sample_Neg_11";
  my $desc   = "Validate that sample data for an invalid granularity\ncannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hours ago
  my $end    = $self->{'neurioTest'}->local_8601(0);
  my $test   = $self->{'neurio'}->fetch_Samples($begin,'moons',$end,5,10,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Sample_Neg_12 {
  my $self   = shift;
  my $title  = "Fetching sample data for a frequency value that is negative";
  my $testID = "Sample_Neg_12";
  my $desc   = "Validate that sample data for a negative frequency value cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hours ago
  my $end    = $self->{'neurioTest'}->local_8601(0);
  my $test   = $self->{'neurio'}->fetch_Samples($begin,'minutes',$end,-1,10,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Sample_Neg_13 {
  my $self   = shift;
  my $title  = "Fetching sample data for a frequency value of zero";
  my $testID = "Sample_Neg_13";
  my $desc   = "Validate that sample data for a zero frequency value cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hours ago
  my $end    = $self->{'neurioTest'}->local_8601(0);
  my $test   = $self->{'neurio'}->fetch_Samples($begin,'minutes',$end,0,10,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Sample_Neg_14 {
  my $self   = shift;
  my $title  = "Fetching sample data for a frequency value greater than 1000 (max)";
  my $testID = "Sample_Neg_14";
  my $desc   = "Validate that sample data for a frequency value greater than the maximum of 1000 cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hours ago
  my $end    = $self->{'neurioTest'}->local_8601(0);
  my $test   = $self->{'neurio'}->fetch_Samples($begin,'minutes',$end,1001,10,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Sample_Neg_15 {
  my $self   = shift;
  my $title  = "Fetching sample data for a perPage value that is negative";
  my $testID = "Sample_Neg_15";
  my $desc   = "Validate that sample data for a negative perPage value cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hours ago
  my $end    = $self->{'neurioTest'}->local_8601(0);
  my $test   = $self->{'neurio'}->fetch_Samples($begin,'minutes',$end,5,-1,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Sample_Neg_16 {
  my $self   = shift;
  my $title  = "Fetching sample data for a perPage value that is zero";
  my $testID = "Sample_Neg_16";
  my $desc   = "Validate that sample data for a zero perPage value cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hours ago
  my $end    = $self->{'neurioTest'}->local_8601(0);
  my $test   = $self->{'neurio'}->fetch_Samples($begin,'minutes',$end,5,0,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Sample_Neg_17 {
  my $self   = shift;
  my $title  = "Fetching sample data for a perPage values greater than 500 (max)";
  my $testID = "Sample_Neg_17";
  my $desc   = "Validate that sample data for a value greater than the maximum of 500 cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hours ago
  my $end    = $self->{'neurioTest'}->local_8601(0);
  my $test   = $self->{'neurio'}->fetch_Samples($begin,'minutes',$end,5,501,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Sample_Neg_18 {
  my $self   = shift;
  my $title  = "Fetching sample data for a page value that is negative";
  my $testID = "Sample_Neg_18";
  my $desc   = "Validate that sample data for a negative page value cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hours ago
  my $end    = $self->{'neurioTest'}->local_8601(0);
  my $test   = $self->{'neurio'}->fetch_Samples($begin,'minutes',$end,5,10,-1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Sample_Neg_19 {
  my $self   = shift;
  my $title  = "Fetching sample data for a page value that of zero";
  my $testID = "Sample_Neg_19";
  my $desc   = "Validate that sample data for a zero page value cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hours ago
  my $end    = $self->{'neurioTest'}->local_8601(0);
  my $test   = $self->{'neurio'}->fetch_Samples($begin,'minutes',$end,5,10,0);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Sample_Neg_20 {
  my $self   = shift;
  my $title  = "Fetching sample data for a page value greater than 100000 (max)";
  my $testID = "Sample_Neg_20";
  my $desc   = "Validate that sample data for a page value greater than the maximum of 100000 cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hours ago
  my $end    = $self->{'neurioTest'}->local_8601(0);
  my $test   = $self->{'neurio'}->fetch_Samples($begin,'minutes',$end,5,10,100001);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Sample_Neg_21 {
  my $self   = shift;
  my $title  = "Fetching sample data for a min power of 1 (min)";
  my $testID = "Sample_Pos_13";
  my $desc   = "Validate that sample data for a minimum value for min power of 1 can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Sample_Neg_22 {
  my $self   = shift;
  my $title  = "Fetching sample data for a granularity of minutes and a frequency less than 5";
  my $testID = "Sample_Neg_22";
  my $desc   = "Validate that sample data for a granularity in minutes and a frequency\nof less than 5 cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hours ago
  my $end    = $self->{'neurioTest'}->local_8601(0);
  my $test   = $self->{'neurio'}->fetch_Samples($begin,'minutes',$end,4,10,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Sample_Neg_23 {
  my $self   = shift;
  my $title  = "Fetching sample data for a granularity in seconds";
  my $testID = "Sample_Neg_23";
  my $desc   = "Validate that sample data for a granularity in seconds cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hour ago
  my $end    = $self->{'neurioTest'}->local_8601(0);
  my $test   = $self->{'neurio'}->fetch_Samples($begin,'seconds',$end,5,10,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub Sample_Neg_24 {
  my $self   = shift;
  my $title  = "Fetching sample data for a granularity of minutes";
  my $testID = "Sample_Neg_24";
  my $desc   = "Validate that sample data for a granularity of minutes cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Sample_Neg_25 {
  my $self   = shift;
  my $title  = "Fetching sample data for a granularity of hours";
  my $testID = "Sample_Neg_25";
  my $desc   = "Validate that sample data for a granularity of hours cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Sample_Neg_26 {
  my $self   = shift;
  my $title  = "Fetching sample data for a period of more than 1 month";
  my $testID = "Sample_Neg_26";
  my $desc   = "Validate that sample data for a period of more than 1 month cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Sample_Neg_27 {
  my $self   = shift;
  my $title  = "Fetching sample data for a min power value that is negative";
  my $testID = "Sample_Neg_27";
  my $desc   = "Validate that sample data for a negative min power value cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Sample_Neg_28 {
  my $self   = shift;
  my $title  = "Fetching sample data for a min power value that of zero";
  my $testID = "Sample_Neg_28";
  my $desc   = "Validate that sample data for a zero min power value cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Sample_Neg_29 {
  my $self   = shift;
  my $title  = "Fetching sample data for a min power value greater than 100000 (max)";
  my $testID = "Sample_Neg_29";
  my $desc   = "Validate that sample data for a min power value greater than the maximum of 100000 cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub Sample_Neg_30 {
  my $self   = shift;
  my $title  = "Fetching sample data when missing required parameters";
  my $testID = "Sample_Neg_30";
  my $desc   = "Validate that sample data when missing required parameters cannot be retrieved.";
  my $defect = undef;
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hour ago
  my $test;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $test = $self->{'neurio'}->fetch_Samples($begin);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",404,$defect);
  $test  = $self->{'neurio'}->fetch_Samples();
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",404,$defect);
  $self->{'neurioTest'}->closeTestCase();
}

1
