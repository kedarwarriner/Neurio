package TestEnergyStats;

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
      print "\nTestEnergyStats->new(): Neurio, NeurioTest and NeurioTools are REQUIRED parameters\n";
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

sub EnergyStats_Pos_01 {
  my $self   = shift;
  my $title  = "Fetching energy stats for a range of exactly 25 hours in minutes";
  my $testID = "EnergyStats_Pos_01";
  my $desc   = "Validate that energy stats for a range of exactly 1 day and 1 hours (25 hours) in intervals of 1 minute intervals can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-90000); # 25 hours ago
  my $end    = $self->{'neurioTest'}->local_8601(0); 
  my $test   = $self->{'neurio'}->fetch_Stats_Energy($begin,'minutes',5,$end,10,1);
  $self->{'neurioTest'}->expectAPIPass($test,"Content was empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTest'}->validateEnergyStats($test)},"Energy stats structure","validated",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub EnergyStats_Pos_02 {
  my $self   = shift;
  my $title  = "Fetching energy stats for a range of exactly 25 hours in hours";
  my $testID = "EnergyStats_Pos_02";
  my $desc   = "Validate that energy stats for a range of exactly 1 day and 1 hours (25 hours) in intervals of 1 hour can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-90000); # 25 hours ago
  my $end    = $self->{'neurioTest'}->local_8601(0); 
  my $test   = $self->{'neurio'}->fetch_Stats_Energy($begin,'hours',1,$end,10,1);
  $self->{'neurioTest'}->expectAPIPass($test,"Content was empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTest'}->validateEnergyStats($test)},"Energy stats structure","validated",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub EnergyStats_Pos_03 {
  my $self   = shift;
  my $title  = "Fetching energy stats for a range of exactly 1 month in days";
  my $testID = "EnergyStats_Pos_03";
  my $desc   = "Validate that energy stats for a range of exactly 1 month in intervals of 1 day can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->fetch_Stats_Energy('2014-11-25T09:40:00-05:00','days',1,'2014-12-25T09:40:00-05:00',10,1);
  $self->{'neurioTest'}->expectAPIPass($test,"Content was empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTest'}->validateEnergyStats($test)},"Energy stats structure","validated",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub EnergyStats_Pos_04 {
  my $self   = shift;
  my $title  = "Fetching energy stats for a range of exactly 6 months in weeks";
  my $testID = "EnergyStats_Pos_04";
  my $desc   = "Validate that energy stats for a range of exactly 6 months in intervals of 1 week can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->fetch_Stats_Energy('2014-06-25T09:40:00-05:00','weeks',1,'2014-12-25T09:40:00-05:00',10,1);
  $self->{'neurioTest'}->expectAPIPass($test,"Content was empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTest'}->validateEnergyStats($test)},"Energy stats structure","validated",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub EnergyStats_Pos_05 {
  my $self   = shift;
  my $title  = "Fetching energy stats for a range of exactly 1 year in months";
  my $testID = "EnergyStats_Pos_05";
  my $desc   = "Validate that energy stats for a range of exactly 1 year in intervals of 1 month can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->fetch_Stats_Energy('2014-01-25T09:40:00-05:00','months',1,'2015-01-25T09:40:00-05:00',10,1);
  $self->{'neurioTest'}->expectAPIPass($test,"Content was empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTest'}->validateEnergyStats($test)},"Energy stats structure","validated",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub EnergyStats_Pos_06 {
  my $self   = shift;
  my $title  = "Fetching energy stats for a range of exactly 10 years in years";
  my $testID = "EnergyStats_Pos_06";
  my $desc   = "Validate that energy stats for a range of exactly 10 years in intervals of 1 year can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->fetch_Stats_Energy('2005-01-25T09:40:00-05:00','years',1,'2015-01-25T09:40:00-05:00',10,1);
  $self->{'neurioTest'}->expectAPIPass($test,"Content was empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTest'}->validateEnergyStats($test)},"Energy stats structure","validated",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub EnergyStats_Pos_07 {
  my $self   = shift;
  my $title  = "Fetching energy stats for a frequency of 1 (min)";
  my $testID = "EnergyStats_Pos_07";
  my $desc   = "Validate that energy stats for a frequency for a minimum value of 1 can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hour ago
  my $end    = $self->{'neurioTest'}->local_8601(0); 
  my $test   = $self->{'neurio'}->fetch_Stats_Energy($begin,'hours',1,$end,10,1);
  $self->{'neurioTest'}->expectAPIPass($test,"Content was empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTest'}->validateEnergyStats($test)},"Energy stats structure","validated",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub EnergyStats_Pos_08 {
  my $self   = shift;
  my $title  = "Fetching energy stats for a frequency of 1000 (max)";
  my $testID = "EnergyStats_Pos_08";
  my $desc   = "Validate that energy stats for a frequency for a maximum value of 1000 can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hour ago
  my $end    = $self->{'neurioTest'}->local_8601(0); 
  my $test   = $self->{'neurio'}->fetch_Stats_Energy($begin,'hours',1,$end,10,1);
  $self->{'neurioTest'}->expectAPIPass($test,"Content was empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTest'}->validateEnergyStats($test)},"Energy stats structure","validated",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub EnergyStats_Pos_09 {
  my $self   = shift;
  my $title  = "Fetching energy stats for a perPage of 1 (min)";
  my $testID = "EnergyStats_Pos_09";
  my $desc   = "Validate that energy stats for a perPage for a minimum value of 1 can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub EnergyStats_Pos_10 {
  my $self   = shift;
  my $title  = "Fetching energy stats for a perPage of 500 (max)";
  my $testID = "EnergyStats_Pos_10";
  my $desc   = "Validate that energy stats for a perPage for a maximum value of 500 can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub EnergyStats_Pos_11 {
  my $self   = shift;
  my $title  = "Fetching energy stats for a page of 1 (min)";
  my $testID = "EnergyStats_Pos_11";
  my $desc   = "Validate that energy stats for a page for a minimum value of 1 can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub EnergyStats_Pos_12 {
  my $self   = shift;
  my $title  = "Fetching energy stats for a page of 100000 (max)";
  my $testID = "EnergyStats_Pos_12";
  my $desc   = "Validate that energy stats for a page for a maximum value of 100000 can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub EnergyStats_Pos_13 {
  my $self   = shift;
  my $title  = "Fetching energy stats for a min power of 1 (min)";
  my $testID = "EnergyStats_Pos_13";
  my $desc   = "Validate that energy stats for a minimum value of min power of 1 can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub EnergyStats_Pos_14 {
  my $self   = shift;
  my $title  = "Fetching energy stats for a min power value of 100000 (max)";
  my $testID = "EnergyStats_Pos_14";
  my $desc   = "Validate that energy stats for a maximum value of min power of 100000 can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub EnergyStats_Pos_15 {
  my $self   = shift;
  my $title  = "Fetching energy stats with no end date";
  my $testID = "EnergyStats_Pos_15";
  my $desc   = "Validate that energy stats with no end date can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-60);
  my $test   = $self->{'neurio'}->fetch_Stats_Energy($begin,'minutes',5);
  $self->{'neurioTest'}->expectAPIPass($test,"Content was empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTest'}->validateEnergyStats($test)},"Energy stats structure","validated",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub EnergyStats_Pos_16 {
  my $self   = shift;
  my $title  = "Fetching energy stats for a single entry per page";
  my $testID = "EnergyStats_Pos_16";
  my $desc   = "Validate that energy stats for a single entry per page can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub EnergyStats_Pos_17 {
  my $self   = shift;
  my $title  = "Fetching energy stats for a default range of dates";
  my $testID = "EnergyStats_Pos_17";
  my $desc   = "Validate that energy stats for a default range of dates can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub EnergyStats_Pos_18 {
  my $self   = shift;
  my $title  = "Fetching energy stats for a specific ID";
  my $testID = "EnergyStats_Pos_18";
  my $desc   = "Validate that energy stats for a specific ID can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub EnergyStats_Pos_19 {
  my $self   = shift;
  my $title  = "Fetching energy stats for a granularity of 'unknown";
  my $testID = "EnergyStats_Pos_19";
  my $desc   = "Validate that energy stats for a granularity of 'unknown' can be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


###################################################################################################
###################################################################################################
###################################################################################################
###################################################################################################


sub EnergyStats_Neg_01 {
  my $self   = shift;
  my $title  = "Fetching energy stats for a range greater than 25 hours in minutes";
  my $testID = "EnergyStats_Neg_01";
  my $desc   = "Validate that energy stats for a range greater than 1 day and 1 hour (25 hours) in intervals of 1 minute cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-91000); # more than 25 hours ago
  my $end    = $self->{'neurioTest'}->local_8601(0); 
  my $test   = $self->{'neurio'}->fetch_Stats_Energy($begin,'minutes',1,$end,10,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub EnergyStats_Neg_02 {
  my $self   = shift;
  my $title  = "Fetching energy stats for a range greater than 25 hours in hours";
  my $testID = "EnergyStats_Neg_02";
  my $desc   = "Validate that energy stats for a range greater than 1 day and 1 hour (25 hours) in intervals of 1 hour cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-91000); # more than 25 hours ago
  my $end    = $self->{'neurioTest'}->local_8601(0); 
  my $test   = $self->{'neurio'}->fetch_Stats_Energy($begin,'hours',5,$end,10,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub EnergyStats_Neg_03 {
  my $self   = shift;
  my $title  = "Fetching energy stats for a range greater than 1 month in days";
  my $testID = "EnergyStats_Neg_03";
  my $desc   = "Validate that energy stats for a range greater than 1 month in intervals of 1 day cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->fetch_Stats_Energy('2015-05-25T09:40:00-05:00','days',5,'2015-06-26T09:40:00-05:00',10,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub EnergyStats_Neg_04 {
  my $self   = shift;
  my $title  = "Fetching energy stats for a range greater than 6 months in weeks";
  my $testID = "EnergyStats_Neg_04";
  my $desc   = "Validate that energy stats for a range greater than 6 months in intervals of 1 week cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->fetch_Stats_Energy('2014-06-25T09:40:00-05:00','weeks',5,'2014-12-26T09:40:00-05:00',10,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub EnergyStats_Neg_05 {
  my $self   = shift;
  my $title  = "Fetching energy stats for a range greater than 1 year in months";
  my $testID = "EnergyStats_Neg_05";
  my $desc   = "Validate that energy stats for a range greater than 1 year in intervals of 1 month cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->fetch_Stats_Energy('2014-01-25T09:40:00-05:00','months',5,'2015-02-25T09:40:00-05:00',10,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub EnergyStats_Neg_06 {
  my $self   = shift;
  my $title  = "Fetching energy stats for a range greater than 10 years in years";
  my $testID = "EnergyStats_Neg_06";
  my $desc   = "Validate that energy stats for a range greater than 10 years in intervals of 1 year cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->fetch_Stats_Energy('2004-01-25T09:40:00-05:00','years',5,'2015-02-25T09:40:00-05:00',10,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub EnergyStats_Neg_07 {
  my $self   = shift;
  my $title  = "Fetching energy stats for a start date with an invalid format";
  my $testID = "EnergyStats_Neg_07";
  my $desc   = "Validate that energy stats for an invalid format for the start date cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->fetch_Stats_Energy('2014-01-35T09:40:00-05:00','months',5,'2015-02-25T09:40:00-05:00',10,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub EnergyStats_Neg_08 {
  my $self   = shift;
  my $title  = "Fetching energy stats for a end date with an invalid format";
  my $testID = "EnergyStats_Neg_08";
  my $desc   = "Validate that energy stats for an invalid format for the end date cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->fetch_Stats_Energy('2014-01-25T09:40:00-05:00','months',5,'2015-02-35T09:40:00-05:00',10,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub EnergyStats_Neg_09 {
  my $self   = shift;
  my $title  = "Fetching energy stats for a start date later than the end date";
  my $testID = "EnergyStats_Neg_09";
  my $desc   = "Validate that energy stats for a start date later than the end date cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hour ago
  my $end    = $self->{'neurioTest'}->local_8601(-7200); # 2 hours ago
  my $test   = $self->{'neurio'}->fetch_Stats_Energy($begin,'months',1,$end,10,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub EnergyStats_Neg_10 {
  my $self   = shift;
  my $title  = "Fetching energy stats for a start date in the future";
  my $testID = "EnergyStats_Neg_10";
  my $desc   = "Validate that energy stats for a start date in the future cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(3600); # 1 hour from now
  my $end    = $self->{'neurioTest'}->local_8601(0); 
  my $test   = $self->{'neurio'}->fetch_Stats_Energy($begin,'months',1,$end,10,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub EnergyStats_Neg_11 {
  my $self   = shift;
  my $title  = "Fetching energy stats for a granularity that is invalid";
  my $testID = "EnergyStats_Neg_11";
  my $desc   = "Validate that energy stats for an invalid granularity cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hour ago
  my $end    = $self->{'neurioTest'}->local_8601(0); 
  my $test   = $self->{'neurio'}->fetch_Stats_Energy($begin,'moons',1,$end,10,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub EnergyStats_Neg_12 {
  my $self   = shift;
  my $title  = "Fetching energy stats for a frequency that is negative";
  my $testID = "EnergyStats_Neg_12";
  my $desc   = "Validate that energy stats for a negative value of frequency cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hour ago
  my $end    = $self->{'neurioTest'}->local_8601(0); 
  my $test   = $self->{'neurio'}->fetch_Stats_Energy($begin,'minutes',-1,$end,10,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub EnergyStats_Neg_13 {
  my $self   = shift;
  my $title  = "Fetching energy stats for a frequency of zero";
  my $testID = "EnergyStats_Neg_13";
  my $desc   = "Validate that energy stats for a zero frequency cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hour ago
  my $end    = $self->{'neurioTest'}->local_8601(0); 
  my $test   = $self->{'neurio'}->fetch_Stats_Energy($begin,'minutes',0,$end,10,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub EnergyStats_Neg_14 {
  my $self   = shift;
  my $title  = "Fetching energy stats for a frequency greater than 1000 (max)";
  my $testID = "EnergyStats_Neg_14";
  my $desc   = "Validate that energy stats for a frequency larger than 1000 cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # 1 hour ago
  my $end    = $self->{'neurioTest'}->local_8601(0); 
  my $test   = $self->{'neurio'}->fetch_Stats_Energy($begin,'minutes',1001,$end,10,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub EnergyStats_Neg_15 {
  my $self   = shift;
  my $title  = "Fetching energy stats for a perPage value that is negative";
  my $testID = "EnergyStats_Neg_15";
  my $desc   = "Validate that energy stats for a perPage value that is negative cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub EnergyStats_Neg_16 {
  my $self   = shift;
  my $title  = "Fetching energy stats for a perPage value of zero";
  my $testID = "EnergyStats_Neg_16";
  my $desc   = "Validate that energy stats for a perPage value of zero cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub EnergyStats_Neg_17 {
  my $self   = shift;
  my $title  = "Fetching energy stats for a perPage value greater than 500 (max)";
  my $testID = "EnergyStats_Neg_17";
  my $desc   = "Validate that energy stats for a perPage value that is greater than the maximum of 500 cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub EnergyStats_Neg_18 {
  my $self   = shift;
  my $title  = "Fetching energy stats for a page value that is negative";
  my $testID = "EnergyStats_Neg_18";
  my $desc   = "Validate that energy stats for a page value that is negative cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub EnergyStats_Neg_19 {
  my $self   = shift;
  my $title  = "Fetching energy stats for a page value of zero";
  my $testID = "EnergyStats_Neg_19";
  my $desc   = "Validate that energy stats for a page value of zero cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub EnergyStats_Neg_20 {
  my $self   = shift;
  my $title  = "Fetching energy stats for a page value greater than 100000 (max)";
  my $testID = "EnergyStats_Neg_20";
  my $desc   = "Validate that energy stats for a page value that is greater than the maximum of 100000 cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub EnergyStats_Neg_21 {
  my $self   = shift;
  my $title  = "Fetching energy stats for a granularity of seconds";
  my $testID = "EnergyStats_Neg_21";
  my $desc   = "Validate that energy stats for a granularity of seconds cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # one hour ago
  my $end    = $self->{'neurioTest'}->local_8601(0); 
  my $test   = $self->{'neurio'}->fetch_Stats_Energy($begin,'seconds',1,$end,10,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub EnergyStats_Neg_22 {
  my $self   = shift;
  my $title  = "Fetching energy stats for a granularity of minutes and frequency not a multiple of 5";
  my $testID = "EnergyStats_Neg_22";
  my $desc   = "Validate that energy stats for a granularity of minutes and frequency not a multiple of 5 cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $begin  = $self->{'neurioTest'}->local_8601(-3600); # one hour ago
  my $end    = $self->{'neurioTest'}->local_8601(0); 
  my $test   = $self->{'neurio'}->fetch_Stats_Energy($begin,'minutes',1,$end,10,1);
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",400,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub EnergyStats_Neg_23 {
  my $self   = shift;
  my $title  = "Fetching energy stats for a granularity of seconds";
  my $testID = "EnergyStats_Neg_23";
  my $desc   = "Validate that energy stats for a granularity of seconds cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub EnergyStats_Neg_24 {
  my $self   = shift;
  my $title  = "Fetching energy stats for a granularity of minutes";
  my $testID = "EnergyStats_Neg_24";
  my $desc   = "Validate that energy stats for a granularity of minutes cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub EnergyStats_Neg_25 {
  my $self   = shift;
  my $title  = "Fetching energy stats for a granularity of hours";
  my $testID = "EnergyStats_Neg_25";
  my $desc   = "Validate that energy stats for a granularity of hours cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub EnergyStats_Neg_26 {
  my $self   = shift;
  my $title  = "Fetching energy stats for a period of more than 1 month";
  my $testID = "EnergyStats_Neg_26";
  my $desc   = "Validate that energy stats for a period of more than 1 month cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub EnergyStats_Neg_27 {
  my $self   = shift;
  my $title  = "Fetching energy stats for a min power value that is negative";
  my $testID = "EnergyStats_Neg_27";
  my $desc   = "Validate that energy stats for a negative min power value cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub EnergyStats_Neg_28 {
  my $self   = shift;
  my $title  = "Fetching energy stats for a min power value that of zero";
  my $testID = "EnergyStats_Neg_28";
  my $desc   = "Validate that energy stats for a zero min power value cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub EnergyStats_Neg_29 {
  my $self   = shift;
  my $title  = "Fetching energy stats for a min power value greater than 100000 (max)";
  my $testID = "EnergyStats_Neg_29";
  my $desc   = "Validate that energy stats for a min power value greater than the maximum of 100000 cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  $self->{'neurio'}->printLOG("  NOT SUPPORTED FOR THIS ENDPOINT\n\n");
}


sub EnergyStats_Neg_30 {
  my $self   = shift;
  my $title  = "Fetching energy stats when missing required parameters";
  my $testID = "EnergyStats_Neg_30";
  my $desc   = "Validate that energy stats when missing required parameters cannot be retrieved.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->fetch_Samples();
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",404,$defect);
  $self->{'neurioTest'}->closeTestCase();
}

1