package Device::NeurioTest;

use warnings;
use strict;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Device::NeurioTest ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.

our %EXPORT_TAGS = ( 'all' => [ qw(
    
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
our @EXPORT = qw();

BEGIN
{
  if ($^O eq "MSWin32"){
    use Device::Neurio;
    use Time::Local;
    use DateTime::Format::ISO8601;
    use JSON qw(decode_json encode_json to_json from_json);
    use JSON::Schema;
    use POSIX;
    use Data::Dumper;
    use Time::HiRes (qw/gettimeofday/);
  } else {
    use Device::Neurio;
    use Time::Local;
    use DateTime::Format::ISO8601;
    use JSON qw(decode_json encode_json to_json from_json);
    use JSON::Schema;
    use POSIX;
    use Data::Dumper;
    use Time::HiRes (qw/gettimeofday/);
  }
}


=head1 NAME

NeurioTest - Methods for testing the Neurio API

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';



###################################################################################################

=head1 SYNOPSIS

 This module provides methods for testing the official API commands provided 
 for Neurio.
 
 This is done via a set of methods to validate the contents of returned data.
 Also generic functions to log Pass and Fail conditions are implemented as follows: 
   - expectAPIPass
   - expectAPIFail
   - expectPass
   - expectFail
  
 Please note that in order to use this module you will require three parameters
 (key, secret, sensor_id) as well as an Energy Aware Neurio sensor installed in
 your house.

 The module is written entirely in Perl and has been developped on Raspbian Linux.


=head1 SAMPLE CODE

    use Device::Neurio;
    use NeurioTest;
   
    $my_Neurio = Device::Neurio->new($key,$secret,$sensor_id);
    $Neurio->connect($locationId);
    
    $my_NeurioTest = NeurioTest->new($my_Neurio,$debug);
   
    $my_NeurioTest->expectAPIPass($test,"Content was not empty",200,$defect);
    undef $my_NeurioTest;
    undef $my_Neurio;
    
=cut


###################################################################################################

=head2 new - the constructor for a NeurioTest object

 Creates a new instance which will be able to execute and store test results
 on a Neurio object.

 my $Neurio = Device::NeurioTest->new($my_Neurio,$debug);

   This method accepts the following parameters:
     - $my_Neurio  : the Neurio instance to test - Required
     - $debug  : enable or disable debug messages (disabled by default) - Optional

 Returns a NeurioTest object if successful.
 Returns 0 on failure
 
=cut

sub new {
    my $class = shift;
    my $self;
    
    $self->{'neurio'}        = shift;
    $self->{'debug'}         = shift;
    $self->{'push'}          = shift;
    $self->{'version'}       = ();
    $self->{'build'}         = ();
    $self->{'globalResults'} = ();
    
    if (not defined $self->{'debug'}) {
      $self->{'debug'} = 0;
    }
    
    if (not defined $self->{'push'}) {
      $self->{'push'} = 0;
    }
    
    if ($self->{'push'}) {
      open LOG, ">/var/www/results/log.html";
      $self->{'LOG'} = \*LOG;
    }

    bless $self, $class;
    
    return $self;
}

###################################################################################################

=head2 DESTROY - the destructor for a NeurioTest object

 Destroys a previously created NeuriTest object.

=cut

sub DESTROY {
    my $self = shift;
    
    print "\nDestroying ".ref($self), "...\n\n";
    
    undef $self->{'neurio'};
    undef $self->{'debug'};
    undef $self->{'push'};
    undef $self->{'version'};
    undef $self->{'build'};
    undef $self->{'globalResult'};

    if ($self->{'LOG'}) {
      close($self->{'LOG'});
    }
}



#########################################################################

sub local_8601 {
  my $self   = shift;
  my $offset = shift;
  my $now    = time();
  
  if (not defined $offset) { $offset = 0; }

  $now = $now + $offset;
  
  my $tz = strftime("%z", localtime(time()));
  $tz =~ s/(\d{2})(\d{2})/$1:$2/;
  
  return strftime("%Y-%m-%dT%H:%M:%S", localtime($now)).$tz;
}

sub local_date_8601 {
  my $now    = time();
  
  return strftime("%Y-%m-%d", localtime());
}

sub local_time_8601 {
  my $now    = time();
  
  my $tz = strftime("%z", localtime(time()));
  $tz =~ s/(\d{2})(\d{2})/$1:$2/;

  return strftime("%H:%M:%S", localtime()).$tz;
}


###################################################################################################

=head2 expectAPIPass - a generic function for analysing a positive API test

 my $Neurio = Device::NeurioTest->expectAPIPass($condition,$errMsg,$errCode,$defect);

   This method accepts the following parameters:
     - $condition : a condition to be evaluated as True or False - Required
     - $errMsg    : the message to display in case of failure - Required
     - $errCode   : the expected API error code (usually 200) - Required
     - $defect    : an optional defect number if applicable - Optional

 Returns 1 on success
 Returns 0 on failure
 
=cut

sub expectAPIPass{
    my $self      = shift;
    my $condition = shift;
    my $errMsg    = shift;
    my $errCode   = shift;
    my $defect    = shift;
    my $ret       = 0;
    
    # check if state is already failed for the current test case
    if ($self->{'testResult'}->{'state'} =~ /Failed/) {
      $self->{'neurio'}->printLOG("  FAILED: Testcase has already failed with reason: ".$self->{'testResult'}->{'reason'}."\n");
      
    # check if all required parameters are defined
    } elsif ((not defined $condition) or (not defined $errMsg) or (not defined $errCode)) {
      $self->{'testResult'}->{'reason'} = "FAILED: expectAPIPass(): Expected at least 3 parameters";
      $self->{'testResult'}->{'code'}   = "0";
      $self->{'testResult'}->{'state'}  = "Failed <--";
      $self->{'neurio'}->printLOG("\n  ".$self->{'testResult'}->{'reason'}."\n\n");
    } else {
      
      # check that expected error code is returned
      if ($self->{'neurio'}->{'last_code'} eq $errCode) {
        $self->{'neurio'}->printLOG("  PASSED: HTTP Return Code was $errCode as expected\n");
        
        # check that last failure reason is blank
        if ($self->{'neurio'}->{'last_reason'} eq '') {
          $self->{'neurio'}->printLOG("  PASSED: HTTP Failure Reason was blank as expected\n");
          
          # check if test condition is true 
          $ret = $self->expectPass($condition,$errMsg,"ok",$defect);
          
        # if last failure message was not blank
        } else {
          $self->{'neurio'}->printLOG("  FAILED: HTTP Failure Reason was '".$self->{'neurio'}->{'last_reason'}."' instead of blank\n");
          $self->{'testResult'}->{'defect'} = $defect;
          $self->{'testResult'}->{'state'} = "Failed <--";
        }
        
      # if error code is not as expected
      } else {
        $self->{'neurio'}->printLOG("  FAILED: HTTP Return Code was ".$self->{'neurio'}->{'last_code'}." but should have been $errCode\n");
        $self->{'testResult'}->{'state'} = "Failed <--";
      }
      
      # if defect defined, assign it to test and display failure message
      if ($self->{'testResult'}->{'state'} eq "Failed <--") {
        if (defined $defect) {
          $self->{'testResult'}->{'defect'} = $defect;
          $self->{'neurio'}->printLOG("  Failure reason: $defect\n");
        
        # if defect not defined display undocumented failure messagee
        } else {
          $self->{'testResult'}->{'defect'} = "[undocumented]";
          $self->{'neurio'}->printLOG("  ".$self->{'testResult'}->{'defect'}." failure\n");
        }
      }
        
      $self->{'testResult'}->{'reason'} = $self->{'neurio'}->{'last_reason'};
      $self->{'testResult'}->{'code'}   = $self->{'neurio'}->{'last_code'};
    }
    return $ret;
}

###################################################################################################

=head2 expectAPIFail - a generic function for analysing a negative API test

 my $Neurio = Device::NeurioTest->expectAPIFail($condition,$errMsg,$errCode,$defect);

   This method accepts the following parameters:
     - $condition : a condition to be evaluated as True or False - Required
     - $errMsg    : the message to display in case of failure - Required
     - $errCode   : the expected API error code (usually 200) - Required
     - $defect    : an optional defect number if applicable - Optional

 Returns 1 on success
 Returns 0 on failure
 
=cut

sub expectAPIFail{
    my $self      = shift;
    my $condition = shift;
    my $errMsg    = shift;
    my $errCode   = shift;
    my $defect    = shift;
    my $ret       = 0;
    
    # check if state is already failed for the current test case
    if ($self->{'testResult'}->{'state'} =~ /Failed/) {
      $self->{'neurio'}->printLOG("  FAILED: Testcase has already failed with reason: ".$self->{'testResult'}->{'reason'}."\n");
      
    # check if all required parameters are defined
    } elsif ((not defined $condition) or (not defined $errMsg) or (not defined $errCode)) {
      $self->{'testResult'}->{'reason'} = "FAILED: expectAPIFail(): Expected at least 3 parameters";
      $self->{'testResult'}->{'code'}   = "0";
      $self->{'testResult'}->{'state'}  = "Failed <--";
      $self->{'neurio'}->printLOG("\n  ".$self->{'testResult'}->{'reason'}."\n\n");
    } else {
      
      # check that expected error code is returned
      if ($self->{'neurio'}->{'last_code'} eq $errCode) {
        $self->{'neurio'}->printLOG("  PASSED: HTTP Return Code was ".$self->{'neurio'}->{'last_code'}." as expected\n");
        
        # check that last failure reason is NOT blank
        if ($self->{'neurio'}->{'last_reason'} ne '') {
          $self->{'neurio'}->printLOG("  PASSED: HTTP Failure Reason was '".$self->{'neurio'}->{'last_reason'}."'\n");
          
          # check if test condition is NOT true 
          $ret = $self->expectFail($condition,$errMsg,"ok",$defect);
          
        # if last failure message was blank
        } else {
          $self->{'neurio'}->printLOG("  FAILED: HTTP Failure Reason should not have been blank\n");
          $self->{'testResult'}->{'defect'} = $defect;
          $self->{'testResult'}->{'state'} = "Failed <--";
        }
        
      # if error code is not as expected
      } else {
        $self->{'neurio'}->printLOG("  FAILED: HTTP Return Code was ".$self->{'neurio'}->{'last_code'}." but should have been $errCode\n");
        $self->{'testResult'}->{'state'} = "Failed <--";
      }
      
      # if defect defined, assign it to test and display failure message
      if ($self->{'testResult'}->{'state'} eq "Failed <--") {
        if (defined $defect) {
          $self->{'testResult'}->{'defect'} = $defect;
          $self->{'neurio'}->printLOG("  Failure reason is: $defect\n");
         
        # if defect not defined display undocumented failure messagee
        } else {
          $self->{'testResult'}->{'defect'} = "[undocumented]";
          $self->{'neurio'}->printLOG("  ".$self->{'testResult'}->{'defect'}." failure\n");
        }
      }
      
      $self->{'testResult'}->{'reason'} = $self->{'neurio'}->{'last_reason'};
      $self->{'testResult'}->{'code'}   = $self->{'neurio'}->{'last_code'};
    }
    return $ret;
}


###################################################################################################

=head2 expectPass - a generic function for evaluatinga positive test

 my $Neurio = Device::NeurioTest->expectPass($condition,$errMsg,value,$defect);

   This method accepts the following parameters:
     - $condition : a condition to be evaluated as True or False - Required
     - $errMsg    : the message to display in case of failure - Required
     - $value     : the expected value - Required
     - $defect    : an optional defect number if applicable - Optional

 Returns 1 on success
 Returns 0 on failure
 
=cut

sub expectPass{
    my $self      = shift;
    my $condition = shift;
    my $errMsg    = shift;
    my $value     = shift;
    my $defect    = shift;
    my $ret       = 0;
    
    # check if state is already failed for the current test case
    if ($self->{'testResult'}->{'state'} =~ /Failed/) {
      $self->{'neurio'}->printLOG("  FAILED: Testcase has already failed with reason: ".$self->{'testResult'}->{'reason'}."\n");
      
    # check if all required parameters are defined
    } elsif ((not defined $condition) or (not defined $errMsg) or (not defined $value)) {
      $self->{'testResult'}->{'reason'} = "FAILED: expectPass(): Expected at least 3 parameters";
      $self->{'testResult'}->{'code'}   = "0";
      $self->{'testResult'}->{'state'}  = "Failed <--";
      $self->{'neurio'}->printLOG("\n  ".$self->{'testResult'}->{'reason'}."\n\n");
    } else {
    
      # check if test condition is true 
      if ($condition) {
        $self->{'neurio'}->printLOG("  PASSED: $errMsg was $value as expected\n");
        $self->{'testResult'}->{'state'} = "Passed";
        $ret=1;
        
        # if a defect exists for this test, and it passed, show it and display warning message
        if (defined $defect) {
          $self->{'neurio'}->printLOG("\n  DEFECT $defect ASSOCIATED TO TEST THAT IS PASSING\n");
          $self->{'testResult'}->{'state'}  = "Warning <--";
          $self->{'testResult'}->{'defect'} = $defect;
        }
        
      # if condition was not met, set failure state and display message
      } else {
        $self->{'neurio'}->printLOG("  FAILED: $errMsg was NOT $value - ");
        $self->{'testResult'}->{'state'}  = "Failed <--";
        $self->{'testResult'}->{'reason'} = "expectPass(): $errMsg was NOT $value";
        
        # if defect defined, assign it to test and display failure message
        if (defined $defect) {
          $self->{'neurio'}->printLOG("Defect $defect raised\n\n");
          $self->{'testResult'}->{'defect'} = $defect;
        } else {
          $self->{'neurio'}->printLOG("[undocumented] failure\n\n");
          $self->{'testResult'}->{'defect'} = "[undocumented]";
        }
      }
    }
    return $ret;
}

###################################################################################################

=head2 expectFail - a generic function for a evaluating negative test

 my $Neurio = Device::NeurioTest->expectFail($condition,$errMsg,value,$defect);

   This method accepts the following parameters:
     - $condition : a condition to be evaluated as True or False - Required
     - $errMsg    : the message to display in case of failure - Required
     - $value     : the expected value - Required
     - $defect    : an optional defect number if applicable - Optional

 Returns 1 on success
 Returns 0 on failure
 
=cut

sub expectFail{
    my $self      = shift;
    my $condition = shift;
    my $errMsg    = shift;
    my $value     = shift;
    my $defect    = shift;
    my $ret       = 0;
    
    # check if state is already failed for the current test case
    if ($self->{'testResult'}->{'state'} =~ /Failed/) {
      $self->{'neurio'}->printLOG("  FAILED: Testcase has already failed with reason: ".$self->{'testResult'}->{'reason'}."\n");
      
    # check if all required parameters are defined
    } elsif ((not defined $condition) or (not defined $errMsg) or (not defined $value)) {
      $self->{'testResult'}->{'reason'} = "FAILED: expectFail(): Expected at least 3 parameters";
      $self->{'testResult'}->{'code'}   = "0";
      $self->{'testResult'}->{'state'}  = "Failed <--";
      $self->{'neurio'}->printLOG("\n  ".$self->{'testResult'}->{'reason'}."\n\n");
    } else {
    
      # check if test condition is NOT true 
      if (not $condition) {
        $self->{'neurio'}->printLOG("  PASSED: $errMsg was NOT $value as expected\n");
        $self->{'testResult'}->{'state'} = "Passed";
        $ret=1;
        
        # if a defect exists for this test, and it passed, show it and display warning message
        if (defined $defect) {
          $self->{'neurio'}->printLOG("\n  DEFECT $defect ASSOCIATED TO TEST THAT IS PASSING\n");
          $self->{'testResult'}->{'state'}  = "Warning <--";
          $self->{'testResult'}->{'defect'} = $defect;
        }
        
      # if condition was not met, set failure state and display message
      } else {
        $self->{'neurio'}->printLOG("  FAILED: $errMsg should NOT have been $value - ");
        $self->{'testResult'}->{'state'}  = "Failed <--";
        $self->{'testResult'}->{'reason'} = "expectFail(): $errMsg should NOT have been $value";

        # if defect defined, assign it to test and display failure message
        if (defined $defect) {
          $self->{'neurio'}->printLOG("Defect $defect raised\n\n");
          $self->{'testResult'}->{'defect'} = $defect;
        } else {
          $self->{'neurio'}->printLOG("[undocumented] failure\n\n");
          $self->{'testResult'}->{'defect'} = "[undocumented]";
        }
      }
    }
    return $ret;
}

###################################################################################################

=head2 openTestCase - a method for initializing a test case

 Open a Test Case Instance and intialize test results data structure.

 my  Device::NeurioTest->openTestCase($condition,$errMsg,value,$defect);

   This method accepts the following parameters:
     - $condition : a condition to be evaluated as True or False - Required
     - $errMsg    : the message to display in case of failure - Required
     - $value     : the expected value - Required
     - $defect    : an optional defect number if applicable - Optional

 Returns nothing

=cut

sub openTestCase{
  my $self   = shift;
  my $testID = shift;
  my $title  = shift;
  my $desc   = shift;

  $self->{'testResult'} = ();
  $self->{'testResult'}->{'state'} = "Passed";
  
  $self->{'neurio'}->printLOG("\n================================================================================================\n");
  $self->{'neurio'}->printLOG("$testID: $title\n\n");
  $self->{'neurio'}->printLOG("$desc\n\n");
  $self->{'neurio'}->printLOG("  Test started at ".$self->local_time_8601()." ".$self->local_date_8601()."\n\n");

  $self->{'testResult'}->{'start'}  = sprintf "%.3f", gettimeofday;     # stores start time of test
  $self->{'testResult'}->{'title'}  = $title;                           # stores title of test
  $self->{'testResult'}->{'testID'} = $testID;                          # stores ID of test
}


###################################################################################################


=head2 closeTestCase - a method for closing and saving a test case

 Close a Test Case Instance and store test results data structure.

 my  Device::NeurioTest->closeTestCase($condition,$errMsg,value,$defect);

   This method accepts no parameters

 Returns nothing

=cut

sub closeTestCase{
  my $self = shift;

  $self->{'neurio'}->printLOG("\n  ".$self->{'testResult'}->{'testID'}.": ".$self->{'testResult'}->{'state'}."\n\n");
  $self->{'neurio'}->printLOG("================================================================================================\n\n");

  $self->{'testResult'}->{'response'} = sprintf "%.3f", $self->{'neurio'}->get_last_exec_time();
  $self->{'testResult'}->{'duration'} = sprintf "%.3f", eval{(gettimeofday - $self->{'testResult'}->{'start'})};  # stores duration of test

  push (@{$self->{'globalResult'}},$self->{'testResult'});
  
  undef $self->{'testResult'};
}


###################################################################################################

=head2 validateSensor 

 Validate structure of JSON for a single Sensor object.
 This function is called mainly by validateSensors()

=cut

sub validateSensor {
  my $self       = shift;
  my $test       = shift;
  my $ret        = 1;
  my $JSONStruct = {
      type       => 'object',
      properties => { 
        sensorType  => { oneOf => ['powerblaster','neurio',''],           required => 1 },
        sensorId    => { type  =>  'string',                              required => 1 },
        installCode => { type  =>  'string',                              required => 0 },
        email       => { type  =>  'string',                              required => 0 },
        locationId  => { type  =>  'string',                              required => 0 },
        id          => { type  =>  'string',                              required => 1 },
        startTime   => { type  => ['DateTime::Format::ISO8601','string'], required => 0 },
        channels    => { 
          type        => 'array',
          minItems    => 0,
          items       => {
            type        => 'object',
            properties  => { 
              sensorId    => { type  =>  'string',                              required => 1 },
              id          => { type  =>  'string',                              required => 0 },
              name        => { type  =>  'string',                              required => 0 },
              channel     => { oneOf => [0,1, 2, 3],                            required => 1 },
              channelType => { oneOf => ['phase_a', 'phase_b', 'consumption'],  required => 0 },
              start       => { type  => ['DateTime::Format::ISO8601','string'], required => 0 },
            }
          }
        },
      }
    };

  if ($test != 0) {
    my $validator = JSON::Schema->new($JSONStruct);
    my $valid = $validator->validate($test);
  
    if ($valid) {
      $self->{'neurio'}->printLOG("  PASSED: JSON Sensor structure is valid!\n");
    } else {
      $self->{'neurio'}->printLOG("  FAILED: JSON SENSOR STRUCTURE is NOT valid!\n");
      $self->{'neurio'}->printLOG(Dumper($test));
      $self->{'neurio'}->printLOG(Dumper($valid));
      $ret = 0;
    }
  } else {
    $self->{'neurio'}->printLOG("  FAILED: No Sensor data received\n");
    $ret=0;
  }
  return $ret;
}

###################################################################################################

=head2 validateSensors

 Validate structure of JSON for an array of Sensor objects.

=cut

sub validateSensors {
  my $self  = shift;
  my $test  = shift;
  my $count = 0;
  my $ret   = 1;
  
  if ($test != 0) {
    foreach my $sensor (@{$test}) {
      $count++;
      $self->{'neurio'}->printLOG("    Sensor $count:");
      if (not $self->validateSensor($sensor)) { $ret = 0; }
    }
  } else {
    $self->{'neurio'}->printLOG("    FAILED: No Sensors returned\n");
    $ret=0;
  }
  return $ret;
}


###################################################################################################

=head2 validateSample

 Validate structure of JSON for a single Sample object.
 This function is called mainly by validateSamples()

=cut

sub validateSample {
  my $self       = shift;
  my $test       = shift;
  my $ret        = 1;
  my $JSONStruct = {
    type       => 'object',
    properties => { 
      generationEnergy  => { type =>  'number',                              required => 1 },
      consumptionEnergy => { type =>  'number',                              required => 1 },
      generationPower   => { type =>  'number',                              required => 1 },
      consumptionPower  => { type =>  'number',                              required => 1 },
      timestamp         => { type => ['DateTime::Format::ISO8601','string'], required => 1 },
    }
  };

  if ($test != 0) {
    my $validator = JSON::Schema->new($JSONStruct);
    my $valid     = $validator->validate($test);

    if ($valid) {
      $self->{'neurio'}->printLOG("    PASSED: JSON Sample structure is valid\n");
    } else {
      $self->{'neurio'}->printLOG("    FAILED: JSON Sample STRUCTURE is NOT valid\n");
      $self->{'neurio'}->printLOG(Dumper($test));
      $self->{'neurio'}->printLOG(Dumper($valid));
      $ret = 0;
    }
  } else {
    $self->{'neurio'}->printLOG("    FAILED: No Sample received\n");
    $ret=0;
  }
  return $ret;
}

###################################################################################################

=head2 validateSamples

 Validate structure of JSON for an array of Sample objects.

=cut

sub validateSamples {
  my $self  = shift;
  my $test  = shift;
  my $ret   = 1;
  my $count = 0;

  if ($test != 0) {
    foreach my $sample (@{$test}) {
      $count++;
      $self->{'neurio'}->printLOG("    Sample $count:");
      if (not $self->validateSample($sample)) { $ret = 0; }
    }
  } else {
    $self->{'neurio'}->printLOG("    FAILED: No Samples returned\n");
    $ret=0;
  }
  return $ret;
}

###################################################################################################

=head2 validateApplianceStatByAppliance

 Validate structure of JSON for a single ApplianceStatistics object for a given Appliance object
 This function is called mainly by validateApplianceStatsByAppliance()

=cut

sub validateApplianceStatByAppliance {
  my $self       = shift;
  my $test       = shift;
  my $ret        = 1;
  my $JSONStruct = {
    type       => 'object',
    properties => { 
      energy          => { type =>  'number',                              required => 1 },
      averagePower    => { type =>  'number',                              required => 1 },
      timeOn          => { type =>  'number',                              required => 1 },
      id              => { type =>  'string',                              required => 1 },
      usagePercentage => { type =>  'number',                              required => 1 },
      eventCount      => { type =>  'number',                              required => 1 },
      start           => { type => ['DateTime::Format::ISO8601','string'], required => 1 },
      end             => { type => ['DateTime::Format::ISO8601','string'], required => 1 },
      groupIds        => {
        type            => 'array',
        minItems        => 0,
        items           => { type => 'string', required => 1 }
      },
    }
  };

  if ($test != 0) {
    my $validator = JSON::Schema->new($JSONStruct);
    my $valid     = $validator->validate($test);
  
    if ($valid) {
      $self->{'neurio'}->printLOG("    PASSED: JSON Appliance Statistics structure is valid!\n");
      if (not $self->validateAppliance($test->{'appliance'})) {$ret = 0;}
      if (not $self->validateGuesses  ($test->{'guesses'}))   {$ret = 0;}
      if (not $self->validateLastEvent($test->{'lastEvent'})) {$ret = 0;}
    } else {
      $self->{'neurio'}->printLOG("    FAILED: JSON APPLIANCE STATISTICS STRUCTURE is NOT valid!\n");
      $self->{'neurio'}->printLOG(Dumper($test));
      $self->{'neurio'}->printLOG(Dumper($valid));
      $ret = 0;
    }
  } else {
    $self->{'neurio'}->printLOG("    FAILED: No appliance statistics received\n");
    $ret=0;
  }
  return $ret;
}

###################################################################################################

=head2 validateApplianceStatsByAppliance

 Validate structure of JSON for an array ApplianceStatistics objects.

=cut

sub validateApplianceStatsByAppliance {
  my $self  = shift;
  my $test  = shift;
  my $count = 0;
  my $ret   = 1;

  if ($test != 0) {
    foreach my $appliance (@{$test}) {
      $count++;
      $self->{'neurio'}->printLOG("    Appliance $count:");
      if (not $self->validateApplianceStatByAppliance($appliance)) { $ret = 0; }
    }
  } else {
    $self->{'neurio'}->printLOG("    FAILED: No appliance statistics returned\n");
    $ret=0;
  }
  return $ret;
}

###################################################################################################

=head2 validateAppliance 

 Validate structure of JSON for an appliance object.

=cut

sub validateAppliance {
  my $self       = shift;
  my $test       = shift;
  my $ret        = 1;
  my $JSONStruct = {
      type       => 'object',
      properties => { 
        locationId => { type =>  'string',                              required => 1 },
        name       => { type =>  'string',                              required => 1 },
        id         => { type =>  'string',                              required => 1 },
        label      => { type =>  'string',                              required => 1 },
        createdAt  => { type => ['DateTime::Format::ISO8601','string'], required => 1 },
        attributes => {
          type       => 'object',
          properties => { 
            cycleThreshold => { type => 'number', required => 1 },
          }
        },
        tags       => { 
          type       => 'array',
          minItems   => 0,
          items      => { 
            type       => 'string',  required => 1 
          },
        },
      }
  };
  
  if (defined $test) {
    if ($test != 0) {
      my $validator = JSON::Schema->new($JSONStruct);
      my $valid     = $validator->validate($test);
  
      if ($valid) {
        $self->{'neurio'}->printLOG("    PASSED: JSON Appliance structure is valid!\n");
      } else {
        $self->{'neurio'}->printLOG("    FAILED: JSON APPLIANCE STRUCTURE is NOT valid!\n");
        $self->{'neurio'}->printLOG(Dumper($test));
        $self->{'neurio'}->printLOG(Dumper($valid));
        $ret = 0;
      }
    } else {
      $self->{'neurio'}->printLOG("    FAILED: Empty appliance received\n");
      $ret=0;
    }
  }
  return $ret;
}

###################################################################################################

=head2 validateAppliances

 Validate structure of JSON for an array Appliance objects.

=cut

sub validateAppliances {
  my $self   = shift;
  my $test   = shift;
  my $count  = 0;
  my $ret    = 1;

  if (defined $test) {
    if ($test != 0) {
      foreach my $appliance (@{$test}) {
        $count++;
        $self->{'neurio'}->printLOG("    Appliance $count:");
        if (not $self->validateAppliance($appliance)) { $ret = 0; }
      }
    } else {
      $self->{'neurio'}->printLOG("    FAILED: Empty appliances returned\n");
      $ret=0;
    }
  } 
  return $ret;
}

###################################################################################################

=head2 validateApplianceStatByLocation

 Validate structure of JSON  for a single ApplianceStatistics object for a given location
 This function is called mainly by validateApplianceStatsByLocation()

=cut

sub validateApplianceStatByLocation {
  my $self       = shift;
  my $test       = shift;
  my $ret        = 1;
  my $JSONStruct = {
    type       => 'object',
    properties => { 
      energy          => { type =>  'number',                              required => 1 },
      averagePower    => { type =>  'number',                              required => 1 },
      timeOn          => { type =>  'number',                              required => 1 },
      id              => { type =>  'string',                              required => 1 },
      usagePercentage => { type =>  'string',                              required => 1 },
      eventCount      => { type =>  'number',                              required => 1 },
      start           => { type => ['DateTime::Format::ISO8601','string'], required => 1 },
      end             => { type => ['DateTime::Format::ISO8601','string'], required => 1 },
      updatedAt       => { type => ['DateTime::Format::ISO8601','string'], required => 0 },
      createdAt       => { type => ['DateTime::Format::ISO8601','string'], required => 0 },
      groupIds        => {
        type            => 'array',
        minItems        => 0,
        items           => { type => 'string', required => 1 }
      },
    }
  };

  if (defined $test) {
    if ($test != 0) {
      my $validator = JSON::Schema->new($JSONStruct);
      my $valid     = $validator->validate($test);

      if ($valid) {
        $self->{'neurio'}->printLOG("    PASSED: JSON Appliance statistics structure is valid!\n");
        if (not $self->validateAppliance($test->{'appliance'})) {$ret = 0;}
        if (not $self->validateLastCycle($test->{'lastCycle'})) {$ret = 0;}
        if (not $self->validateGuesses  ($test->{'guesses'}))   {$ret = 0;}
      } else {
        $self->{'neurio'}->printLOG("    FAILED: JSON APPLIANCE STATISTICS STRUCTURE is NOT valid!\n");
        $self->{'neurio'}->printLOG(Dumper($test));
        $self->{'neurio'}->printLOG(Dumper($valid));
        $ret = 0;
      }
    } else {
      $self->{'neurio'}->printLOG("    FAILED: Empty appliance received\n");
      $ret=0;
    }
  }
  return $ret;
}

###################################################################################################

=head2 validateApplianceStatsByLocation

 Validate structure of JSON for an array of ApplianceStatistics objects.

=cut

sub validateApplianceStatsByLocation {
  my $self  = shift;
  my $test  = shift;
  my $count = 0;
  my $ret   = 1;

  if (defined $test) {
    if ($test != 0) {
      foreach my $appliance (@{$test}) {
        $count++;
        $self->{'neurio'}->printLOG("    Appliance $count:");
        if (not $self->validateApplianceStatByLocation($appliance)) { $ret = 0; }
      }
    } else {
      $self->{'neurio'}->printLOG("    FAILED: Empty appliances returned\n");
      $ret=0;
    }
  }
  return $ret;
}

###################################################################################################

sub validateApplianceSpecs {
  my $self       = shift;
  my $test       = shift;
  my $ret        = 1;
  my $JSONStruct = {
   	type     => 'array',
    minItems => 0,
    items    => {
      type       => 'object',
      properties => { 
        powerMin       => { type => 'number', required => 0 },
        powerMax       => { type => 'number', required => 0 },
        name           => { type => 'string', required => 1 },
        cycleThreshold => { type => 'number', required => 1 },
      }
    }
  };
  
  if ($test != 0) {
    my $validator = JSON::Schema->new($JSONStruct);
    my $valid     = $validator->validate($test);

    if ($valid) {
      $self->{'neurio'}->printLOG("  PASSED: JSON Appliance Specs structure is valid!\n");
    } else {
      $self->{'neurio'}->printLOG("  FAILED: JSON APPLIANCE SPECS STRUCTURE is NOT valid!\n");
      $self->{'neurio'}->printLOG(Dumper($test));
      $self->{'neurio'}->printLOG(Dumper($valid));
      $ret = 0;
    }
  } else {
    $self->{'neurio'}->printLOG("  FAILED: No appliance returned\n");
    $ret=0;
  }
  return $ret;
}

###################################################################################################

sub validateApplianceStatus {
  my $self  = shift;
  my $test  = shift;
  my $count = 0;
  my $ret   = 1;

  if ($test != 0) {
    foreach my $appliance (@{$test}) {
      $count++;
      $self->{'neurio'}->printLOG("    Appliance $count:");
      if (not $self->validateAppliance($appliance->{'appliance'})) { $ret = 0; }
    }
  } else {
    $self->{'neurio'}->printLOG("No appliance status returned\n");
    $ret=0;
  }
  return $ret;
}

###################################################################################################

=head2 validateApplianceEventByLocation

 Validate structure of JSON for a single ApplianceEvent object for a given location.
 This function is called mainly by validateApplianceEventsByLocation()

=cut

sub validateApplianceEventByLocation {
  my $self       = shift;
  my $test       = shift;
  my $ret        = 1;
  my $JSONStruct = {
      type       => 'object',
      properties => { 
        id           => { type => 'string', required => 1 },
        cycleCount   => { type => 'number', required => 1 },
        energy       => { type => 'number', required => 1 },
        averagePower => { type => 'number', required => 1 },
        status       => { type => 'string', required => 1 },
        start        => { type => ['DateTime::Format::ISO8601','string'], required => 1 },
        end          => { type => ['DateTime::Format::ISO8601','string'], required => 0 },
        groupIds => {
          type     => 'array',
          minItems => 0,
          items    => { type => 'string', required => 1 }
        },
      }
  };

  if ($test != 0) {
    my $validator = JSON::Schema->new($JSONStruct);
    my $valid     = $validator->validate($test);

    if ($valid) {
      $self->{'neurio'}->printLOG("  PASSED: JSON Appliance Events by Location structure is valid!\n");
      if (not $self->validateAppliance($test->{'appliance'})) {$ret = 0;}
      if (not $self->validateLastCycle($test->{'lastCycle'})) {$ret = 0;}
      if (not $self->validateGuesses  ($test->{'guesses'}))   {$ret = 0;}
    } else {
      $self->{'neurio'}->printLOG("  FAILED: JSON APPLIANCE EVENTS BY LOCATION STRUCTURE is NOT valid!\n");
      $self->{'neurio'}->printLOG(Dumper($test));
      $self->{'neurio'}->printLOG(Dumper($valid));
      $ret = 0;
    }
  } else {
    $self->{'neurio'}->printLOG("  FAILED: No appliance event received\n");
    $ret=0;
  }

  return $ret;
}

###################################################################################################

=head2 validateLastCycle

 Validate structure of JSON for a LastCycle object. 

=cut

sub validateLastCycle {
  my $self       = shift;
  my $test       = shift;
  my $ret        = 1;
  my $JSONStruct = {
      type         => 'object',
      required     => 0,
      properties   => {
        energy       => { type =>  'number',                              required => 0 },
        averagePower => { type =>  'number',                              required => 1 },
        groupId      => { type =>  'string',                              required => 1 },
        sensorId     => { type =>  'string',                              required => 1 },
        id           => { type =>  'string',                              required => 1 },
        createdAt    => { type => ['DateTime::Format::ISO8601','string'], required => 1 },
        updatedAt    => { type => ['DateTime::Format::ISO8601','string'], required => 1 },
        start        => { type => ['DateTime::Format::ISO8601','string'], required => 1 },
        end          => { type => ['DateTime::Format::ISO8601','string'], required => 0 },
      }
  };
  
  if (defined $test) {
    if ($test != 0) {
      my $validator = JSON::Schema->new($JSONStruct);
      my $valid     = $validator->validate($test);
  
      if ($valid) {
        $self->{'neurio'}->printLOG("    PASSED: JSON LastCycle structure is valid!\n");
        if (not $self->validateAppliance($test->{'appliance'})) {$ret = 0;}
      } else {
        $self->{'neurio'}->printLOG("    FAILED: JSON LASTCYCLE STRUCTURE is NOT valid!\n");
        $self->{'neurio'}->printLOG(Dumper($test));
        $self->{'neurio'}->printLOG(Dumper($valid));
        $ret = 0;
      }
    } else {
      $self->{'neurio'}->printLOG("    FAILED: No LastCycle object received\n");
      $ret=0;
    }
  }
  return $ret;
}
      
      
###################################################################################################

=head2 validateLastEvent

 Validate structure of JSON for a LastEvent object. 

=cut

sub validateLastEvent {
  my $self       = shift;
  my $test       = shift;
  my $ret        = 1;
  my $JSONStruct = {
      type         => 'object',
      required     => 0,
      properties   => {
        energy       => { type =>  'number',                              required => 1 },
        averagePower => { type =>  'number',                              required => 1 },
        status       => { type =>  'string',                              required => 1 },
        cycleCount   => { type =>  'number',                              required => 1 },
        id           => { type =>  'string',                              required => 1 },
        start        => { type => ['DateTime::Format::ISO8601','string'], required => 1 },
        end          => { type => ['DateTime::Format::ISO8601','string'], required => 0 },
        groupIds => {
          type     => 'array',
          minItems => 0,
          items    => { type  => 'string' }
        },
      }
  };
  
  if (defined $test) {
    if ($test != 0) {
      my $validator = JSON::Schema->new($JSONStruct);
      my $valid     = $validator->validate($test);
  
      if ($valid) {
        $self->{'neurio'}->printLOG("    PASSED: JSON LastEvent structure is valid!\n");
        if (not $self->validateLastCycle($test->{'lastEvent'}->{'lastCycle'})) {$ret = 0;}
        if (not $self->validateGuesses  ($test->{'lastEvent'}->{'guesses'}))   {$ret = 0;}
        if (not $self->validateAppliance($test->{'lastEvent'}->{'appliance'})) {$ret = 0;}
      } else {
        $self->{'neurio'}->printLOG("    FAILED: JSON LASTEVENT STRUCTURE is NOT valid!\n");
        $self->{'neurio'}->printLOG(Dumper($test));
        $self->{'neurio'}->printLOG(Dumper($valid));
        $ret = 0;
      }
    } else {
      $self->{'neurio'}->printLOG("    FAILED: No LastEvent object received\n");
      $ret=0;
    }
  }
  return $ret;
}
      
      
###################################################################################################

=head2 validateGuesses

 Validate structure of JSON for a Guesses object. 

=cut

sub validateGuesses {
  my $self       = shift;
  my $test       = shift;
  my $ret        = 1;
  my $JSONStruct = {
      type         => 'object',
      properties   => { 
        air_conditioner => { type => 'number', required => 0 },
        dryer           => { type => 'number', required => 0 },
        electric_kettle => { type => 'number', required => 0 },
        heater          => { type => 'number', required => 0 },
        microwave       => { type => 'number', required => 0 },
        other           => { type => 'number', required => 0 },
        oven            => { type => 'number', required => 0 },
        refrigerator    => { type => 'number', required => 0 },
        stove           => { type => 'number', required => 0 },
        toaster         => { type => 'number', required => 0 },
      }
  };
  
  if (defined $test) {
    if ($test != 0) {
      my $validator = JSON::Schema->new($JSONStruct);
      my $valid     = $validator->validate($test);
  
      if ($valid) {
        $self->{'neurio'}->printLOG("    PASSED: JSON Guesses structure is valid!\n");
        if (not $self->validateAppliance($test->{'appliance'})) {$ret = 0;}
      } else {
        $self->{'neurio'}->printLOG("    FAILED: JSON GUESSES STRUCTURE is NOT valid!\n");
        $self->{'neurio'}->printLOG(Dumper($test));
        $self->{'neurio'}->printLOG(Dumper($valid));
        $ret = 0;
      }
    } else {
      $self->{'neurio'}->printLOG("    FAILED: No Guesses object received\n");
      $ret=0;
    }
  }
  return $ret;
}
      
      
###################################################################################################

=head2 validateApplianceEventsByLocation

 Validate structure of JSON for an array of ApplianceEvent object for a given location.  

=cut

sub validateApplianceEventsByLocation {
  my $self       = shift;
  my $test       = shift;
  my $count      = 0;
  my $ret        = 1;

  if ($test != 0) {
    foreach my $event (@{$test}) {
      $count++;
      $self->{'neurio'}->printLOG("    Event $count:");
      if (not $self->validateApplianceEventByLocation($event)) { $ret = 0; }
    }
  } else {
    $self->{'neurio'}->printLOG("No appliance events returned\n");
    $ret=0;
  }
  return $ret;
}


###################################################################################################

=head2 validateApplianceEventByAppliance

 Validate structure of JSON for a single ApplianceEvent object for a given appliance.
 This function is called mainly by validateAppliancesEventsByAppliance()

=cut

sub validateApplianceEventByAppliance {
  my $self       = shift;
  my $test       = shift;
  my $ret        = 1;
  my $JSONStruct = {
      type       => 'object',
      properties => { 
        id           => { type => 'string', required => 1 },
        cycleCount   => { type => 'number', required => 1 },
        energy       => { type => 'number', required => 1 },
        averagePower => { type => 'number', required => 1 },
        status       => { type => 'string', required => 1 },
        start        => { type => ['DateTime::Format::ISO8601','string'], required => 1 },
        end          => { type => ['DateTime::Format::ISO8601','string'], required => 0 },
        groupIds => {
          type     => 'array',
          minItems => 0,
          items    => { type => 'string', required => 1 }
        },
      }
  };

  if ($test != 0) {
    my $validator = JSON::Schema->new($JSONStruct);
    my $valid     = $validator->validate($test);

    if ($valid) {
      $self->{'neurio'}->printLOG("  PASSED: JSON Appliance Events by Appliance structure is valid!\n");
      if (not $self->validateAppliance($test->{'appliance'})) {$ret = 0;}
      if (not $self->validateLastCycle($test->{'lastCycle'})) {$ret = 0;}
      if (not $self->validateGuesses  ($test->{'guesses'}))   {$ret = 0;}
    } else {
      $self->{'neurio'}->printLOG("  FAILED: JSON APPLIANCE EVENTS BY APPLIANCE STRUCTURE is NOT valid!\n");
      $self->{'neurio'}->printLOG(Dumper($test));
      $self->{'neurio'}->printLOG(Dumper($valid));
      $ret = 0;
    }
  } else {
    $self->{'neurio'}->printLOG("  FAILED: No appliance event received\n");
    $ret=0;
  }

  return $ret;
}

###################################################################################################

=head2 validateApplianceEventsByAppliance

 Validate structure of JSON for an array of ApplianceEvent objects for a given appliance.

=cut

sub validateApplianceEventsByAppliance {
  my $self  = shift;
  my $test  = shift;
  my $count = 0;
  my $ret   = 1;

  if ($test != 0) {
    foreach my $appliance (@{$test}) {
      $count++;
      $self->{'neurio'}->printLOG("    Event $count:");
      if (not $self->validateApplianceEventByAppliance($appliance)) { $ret = 0; }
    }
  } else {
    $self->{'neurio'}->printLOG("  FAILED: No appliance events returned\n");
    $ret=0;
  }
  return $ret;
}

###################################################################################################

=head2 validateSamplesFull

 Validate structure of JSON for an array of FullSample objects.

=cut

sub validateSamplesFull {
  my $self   = shift;
  my $test   = shift;
  my $ret    = 1;
  my $JSONStruct = {
   	type      => 'array',
    minItems => 0,
    items     => {
      type       => 'object',
      properties => { 
        timestamp      => { type => ['DateTime::Format::ISO8601','string'], required => 1 },
        channelSamples => { 
          type      => 'array',
          minItems => 0,
          items     => {
            type        => 'object',
            properties  => { 
              voltage        => { type  =>  'number',                              required => 1 },
              power          => { type  =>  'number',                              required => 1 },
              name           => { type  =>  'string',                              required => 1 },
              energyExported => { type  =>  'number',                              required => 1 },
              energyImported => { type  =>  'number',                              required => 1 },
              reactivePower  => { type  =>  'number',                              required => 1 },
              channelType    => { oneOf => ['phase_a', 'phase_b', 'consumption'],  required => 1 },
            }
          },
        },
      }
    }
  };

  if ($test != 0) {
    my $validator = JSON::Schema->new($JSONStruct);
    my $valid     = $validator->validate($test);

    if ($valid) {
      $self->{'neurio'}->printLOG("  PASSED: JSON Full Sample structure is valid!\n");
    } else {
      $self->{'neurio'}->printLOG("  FAILED: JSON FULL SAMPLE STRUCTURE is NOT valid!\n");
      $self->{'neurio'}->printLOG(Dumper($test));
      $self->{'neurio'}->printLOG(Dumper($valid));
      $ret = 0;
    }
  } else {
    $self->{'neurio'}->printLOG("  FAILED: No samples returned\n");
    $ret=0;
  }
  return $ret;
}


###################################################################################################

=head2 validateEnergyStat

 Validate structure of JSON for a single EnergyStatistic object.
 This function is called mainly by validateEnergyStats()

=cut

sub validateEnergyStat {
  my $self       = shift;
  my $test       = shift;
  my $ret        = 1;
  my $JSONStruct = {
    type       => 'object',
    properties => { 
      consumptionEnergy => { type =>  'number',                              required => 1 },
      start             => { type => ['DateTime::Format::ISO8601','string'], required => 1 },
      end               => { type => ['DateTime::Format::ISO8601','string'], required => 1 },
    }
  };

  if ($test != 0) {
    my $validator = JSON::Schema->new($JSONStruct);
    my $valid     = $validator->validate($test);

    if ($valid) {
      $self->{'neurio'}->printLOG("  PASSED: JSON Energy Statistics structure is valid!\n");
    } else {
      $self->{'neurio'}->printLOG("  FAILED: JSON ENERGY STATISTICS STRUCTURE is NOT valid!\n");
      $self->{'neurio'}->printLOG(Dumper($test));
      $self->{'neurio'}->printLOG(Dumper($valid));
      $ret = 0;
    }
  } else {
    $self->{'neurio'}->printLOG("  FAILED: No Energy Stat received\n");
    $ret=0;
  }
  return $ret;
}


###################################################################################################

=head2 validateEnergyStats

 Validate structure of JSON for an array of EnergyStatistics objects.

=cut

sub validateEnergyStats {
  my $self   = shift;
  my $test   = shift;
  my $count  = 0;
  my $ret    = 1;

  if ($test != 0) {
    foreach my $stat (@{$test}) {
      $count++;
      $self->{'neurio'}->printLOG("    Stats Sample $count:");
      if (not $self->validateEnergyStat($stat)) { $ret = 0; }
    }
  } else {
    $self->{'neurio'}->printLOG("  FAILED No Energy Stats returned\n");
    $ret=0;
  }
  return $ret;
}


###################################################################################################

=head2 validateUser

 Validate structure of JSON for a single User object.
 This function is called mainly by validateUsers()

=cut

sub validateUser {
  my $self   = shift;
  my $test   = shift;
  my $ret    = 1;
  my $JSONStruct = {
    type       => 'object',
    properties => { 
      createdAt  => { type  => ['DateTime::Format::ISO8601','string'], required => 0 },
      timezone   => { type  =>  'string',                              required => 1 },
      name       => { type  =>  'string',                              required => 1 },
      id         => { type  =>  'string',                              required => 1 },
      energyRate => { type  =>  'number',                              required => 0 },
    }
  };

  if ($test != 0) {
    my $validator = JSON::Schema->new($JSONStruct);
    my $valid     = $validator->validate($test);

    if ($valid) {
      $self->{'neurio'}->printLOG("    PASSED: JSON User structure is valid!\n");
      if (not $self->validateSensors($test->{'sensors'})) {$ret = 0;}
    } else {
      $self->{'neurio'}->printLOG("    FAILED: JSON USER STRUCTURE is NOT valid!\n");
      $self->{'neurio'}->printLOG(Dumper($test));
      $self->{'neurio'}->printLOG(Dumper($valid));
      $ret = 0;
    }
  } else {
    $self->{'neurio'}->printLOG("    FAILED: No User data received\n");
    $ret=0;
  }

  return $ret;
}


###################################################################################################

=head2 validateUsers

 Validate structure of JSON for an array of User objects.

=cut

sub validateUsers {
  my $self   = shift;
  my $test   = shift;
  my $count  = 0;
  my $ret    = 1;

  if ($test != 0) {
    foreach my $user (@{$test->{'locations'}}) {
      $count++;
      $self->{'neurio'}->printLOG("    User $count:");
      if (not $self->validateUser   ($user))              {$ret = 0;}
      if (not $self->validateSensors($user->{'sensors'})) {$ret = 0;}
    }
  } else {
    $self->{'neurio'}->printLOG("No user data returned\n");
    $ret=0;
  }
  
  return $ret;
}


###################################################################################################

=head2 validateLocation

 Validate structure of JSON for a location object.

=cut

sub validateLocation {
  my $self       = shift;
  my $test       = shift;
  my $ret        = 1;
  my $JSONStruct = {
    type       => 'object',
    properties => { 
      updatedAt  => { type  => ['DateTime::Format::ISO8601','string'], required => 1 },
      createdAt  => { type  => ['DateTime::Format::ISO8601','string'], required => 1 },
      timezone   => { type  =>  'string',                              required => 1 },
      name       => { type  =>  'string',                              required => 1 },
      id         => { type  =>  'string',                              required => 1 },
      energyRate => { type  =>  'number',                              required => 0 },
    }
  };

  if ($test != 0) {
    my $validator = JSON::Schema->new($JSONStruct);
    my $valid     = $validator->validate($test);

    if ($valid) {
      $self->{'neurio'}->printLOG("    PASSED: JSON Location structure is valid!\n");
      if (not $self->validateSensors($test->{'sensors'})) {$ret = 0;}
    } else {
      $self->{'neurio'}->printLOG("    FAILED: JSON LOCATION STRUCTURE is NOT valid!\n");
      $self->{'neurio'}->printLOG(Dumper($test));
      $self->{'neurio'}->printLOG(Dumper($valid));
      $ret = 0;
    }
  } else {
    $self->{'neurio'}->printLOG("    FAILED: No Location data received\n");
    $ret=0;
  }

  return $ret;
}


###################################################################################################

=head2 validateAnalyticValue

 Validate structure of JSON for a single AnalyticValue object.
 This function is called mainly by validateAnalytic()

=cut

sub validateAnalyticValue {
  my $self       = shift;
  my $test       = shift;
  my $ret        = 1;
  my $JSONStruct = {
    value => { 
      type  =>  'object', 
      properties => {
        baseload_24hr => { type  =>  'number',                              required => 1 },
        baseload      => { type  =>  'number',                              required => 1 },
        minpower      => { type  =>  'number',                              required => 1 },
        start         => { type  => ['DateTime::Format::ISO8601','string'], required => 1 },
        end           => { type  => ['DateTime::Format::ISO8601','string'], required => 1 },
      }
    }
  };
  my $validator = JSON::Schema->new($JSONStruct);
  my $valid     = $validator->validate($test);
  
  if ($valid) {
    $self->{'neurio'}->printLOG("        PASSED: JSON Analytic 'value' structure is valid!\n");
  } else {
    $self->{'neurio'}->printLOG("        FAILED: JSON ANALYTIC 'value' STRUCTURE is NOT valid!\n");
    $self->{'neurio'}->printLOG(Dumper($test));
    $self->{'neurio'}->printLOG(Dumper($valid));
    $ret=0;
  }

  return $ret;
}


###################################################################################################

=head2 validateAnalytic

 Validate structure of JSON for a single Analytics object.
 This function is called mainly by validateAnalytics()

=cut

sub validateAnalytic {
  my $self       = shift;
  my $test       = shift;
  my $ret        = 1;
  my $JSONStruct = {
    type       => 'object',
    properties => { 
      timestamp  => { type  => ['DateTime::Format::ISO8601','string'], required => 1 },
      name       => { type  =>  'string',                              required => 1 },
      id         => { type  =>  'string',                              required => 1 },
    }
  };

  if ($test != 0) {
    my $validator = JSON::Schema->new($JSONStruct);
    my $valid     = $validator->validate($test);

    if ($valid) {
      $self->{'neurio'}->printLOG("  PASSED: JSON Analytic structure is valid!\n");
      if (not $self->validateAnalyticValue(decode_json($test->{'value'}))) { $ret = 0; }
    } else {
      $self->{'neurio'}->printLOG("    FAILED: JSON ANALYTIC STRUCTURE is NOT valid!\n");
      $self->{'neurio'}->printLOG(Dumper($test));
      $self->{'neurio'}->printLOG(Dumper($valid));
      $ret = 0;
    }
  } else {
    $self->{'neurio'}->printLOG("  FAILED: No Analytic received\n");
    $ret=0;
  }

  return $ret;
}

###################################################################################################

=head2 validateAnalytics

 Validate structure of JSON for an array of Analytics objects.

=cut

sub validateAnalytics {
  my $self   = shift;
  my $test   = shift;
  my $count  = 0;
  my $ret    = 1;

  if ($test != 0) {
    foreach my $analytic (@{$test}) {
      $count++;
      $self->{'neurio'}->printLOG("    Analytic $count:");
      if (not $self->validateAnalytic($analytic)) { $ret = 0; }
    }
  } else {
    $self->{'neurio'}->printLOG("  FAILED: No analytics returned\n");
    $ret=0;
  }
  return $ret;
}


###################################################################################################

=head2 validateChannelSample

 Validate structure of JSON for a single ChannelSample object.
 This function is called mainly by validateChannelSamples()

=cut

sub validateChannelSample {
  my $self       = shift;
  my $test       = shift;
  my $ret        = 1;
  my $JSONStruct = {
    type        => 'object',
    properties  => { 
      timestamp      => { type  => ['DateTime::Format::ISO8601','string'], required => 1 },
      channelSamples => {
        type           => 'array',
        minItems       => 0,
        items          => {
          type           => 'object',
          properties     => { 
            voltage        => { type  =>  'number',                              required => 1 },
            power          => { type  =>  'number',                              required => 1 },
            name           => { type  =>  'number',                              required => 1 },
            energyExported => { type  =>  'number',                              required => 1 },
            energyImported => { type  =>  'string',                              required => 1 },
            reactivePower  => { type  =>  'number',                              required => 1 },
            channelType    => { oneOf => ['phase_a', 'phase_b', 'consumption'],  required => 1 },
          }
        }
      }
    }
  };

  if ($test != 0) {
    my $validator = JSON::Schema->new($JSONStruct);
    my $valid     = $validator->validate($test);

    if ($valid) {
      $self->{'neurio'}->printLOG("    PASSED: JSON Channel Sample structure is valid\n");
    } else {
      $self->{'neurio'}->printLOG("    FAILED: JSON CHANNEL SAMPLE STRUCTURE is NOT valid\n");
      $self->{'neurio'}->printLOG(Dumper($test));
      $self->{'neurio'}->printLOG(Dumper($valid));
      $ret = 0;
    }
  } else {
    $self->{'neurio'}->printLOG("    FAILED: No Channel Sample received\n");
    $ret=0;
  }
  return $ret;
}

###################################################################################################

=head2 validateChannelSamples

 Validate structure of JSON for an array of ChannelSample objects.

=cut

sub validateChannelSamples {
  my $self   = shift;
  my $test   = shift;
  my $count  = 0;
  my $ret    = 1;

  if (($test != 0) and ($test !=[])) {
    foreach my $channelSample ($test) {
      $count++;
      $self->{'neurio'}->printLOG("    Channel Sample $count:");
      if (not $self->validateChannelSample($channelSample)) { $ret = 0; }
    }
  } else {
    $self->{'neurio'}->printLOG("  FAILED: No channel samples returned\n");
    $ret=0;
  }
  return $ret;
}

###################################################################################################

=head2 validateCycle

 Validate structure of JSON for a single Cycle object.
 This function is called mainly by validateCycles()

=cut

sub validateCycle {
  my $self       = shift;
  my $test       = shift;
  my $ret        = 1;
  my $JSONStruct = {
    type       => 'object',
    properties => { 
      createdAt    => { type  => ['DateTime::Format::ISO8601','string'], required => 1 },
      updatedAt    => { type  => ['DateTime::Format::ISO8601','string'], required => 1 },
      averagePower => { type  =>  'number',                              required => 1 },
      groupId      => { type  =>  'string',                              required => 1 },
      sensorId     => { type  =>  'string',                              required => 1 },
      upEdge       => {
        type       => 'object',
        required   => 0,
        properties => { 
          start       => { type  => ['DateTime::Format::ISO8601','string'], required => 0 },
          peak        => { type  => ['DateTime::Format::ISO8601','string'], required => 0 },
          end         => { type  => ['DateTime::Format::ISO8601','string'], required => 0 },
          sensorId    => { type  =>  'string',                              required => 0 },
          direction   => { type  =>  'number',                              required => 0 },
          id          => { type  =>  'string',                              required => 0 },
          channelType => { oneOf => ['phase_a', 'phase_b', 'consumption'],  required => 0 },
          powerDelta  => { type  =>  'number',                              required => 0 },
          groupIds => {
            type     => 'array',
            minItems => 0,
            items    => { type  => 'string' }
          },
        },
      },
      downEdge       => {
        type       => 'object',
        required   => 0,
        properties => { 
          start       => { type  => ['DateTime::Format::ISO8601','string'], required => 0 },
          peak        => { type  => ['DateTime::Format::ISO8601','string'], required => 0 },
          end         => { type  => ['DateTime::Format::ISO8601','string'], required => 0 },
          sensorId    => { type  =>  'string',                              required => 0 },
          direction   => { type  =>  'number',                              required => 0 },
          id          => { type  =>  'string',                              required => 0 },
          channelType => { oneOf => ['phase_a', 'phase_b', 'consumption'],  required => 0 },
          powerDelta  => { type  =>  'number',                              required => 0 },
          groupIds => {
            type     => 'array',
            minItems => 0,
            items    => { type  => 'string' },
          },
        },
      }, 
    }
  };

  if ($test != 0) {
    my $validator = JSON::Schema->new($JSONStruct);
    my $valid     = $validator->validate($test);
    if ($valid) {
      my $count = 0;
      $self->{'neurio'}->printLOG("    PASSED: JSON Cycle structure is valid!\n");
      foreach my $channelSample (@{$test->{'upEdge'}->{'samples'}}) {
        if (defined($test->{'upEdge'}->{'significant'})) {
          if ((to_json($test->{'upEdge'}->{'significant'}) ne 'false') and (to_json($test->{'upEdge'}->{'significant'}) ne 'true'))
            { $ret = 0; }
        }
        if (not $self->validateChannelSample($channelSample)) { $ret = 0; }
        if (not $self->validateEdge($test->{'upEdge'}))       { $ret = 0; }
        $count++;
      }
      $count = 0;
      foreach my $channelSample (@{$test->{'downEdge'}->{'samples'}}) {
        if (defined($test->{'downEdge'}->{'significant'})) {
          if ((to_json($test->{'downEdge'}->{'significant'}) ne 'false') and (to_json($test->{'downEdge'}->{'significant'}) ne 'true')) 
            { $ret = 0; }
        }
        if (not $self->validateChannelSample($channelSample)) { $ret = 0; }
        if (not $self->validateEdge($test->{'downEdge'}))     { $ret = 0; }
        $count++;
      }
    } else {
      $self->{'neurio'}->printLOG("    FAILED: JSON Cycle STRUCTURE is NOT valid!\n");
      $self->{'neurio'}->printLOG(Dumper($test));
      $self->{'neurio'}->printLOG(Dumper($valid));
      $ret = 0;
    }
  } else {
    $self->{'neurio'}->printLOG("    FAILED: No Cycle data received\n");
    $ret=0;
  }
  return $ret;
}

###################################################################################################

=head2 validateCycles

 Validate structure of JSON for an array of Cycle objects.

=cut

sub validateCycles {
  my $self   = shift;
  my $test   = shift;
  my $count  = 0;
  my $ret    = 1;

  if ($test != 0) {
    foreach my $cycle (@{$test}) {
      $count++;
      $self->{'neurio'}->printLOG("    Cycle $count:");
      if (not $self->validateCycle($cycle)) { $ret = 0; }
    }
  } else {
    $self->{'neurio'}->printLOG("  FAILED: No Cycles data returned\n");
    $ret=0;
  }
  return $ret;
}


###################################################################################################

=head2 validateCycleGroup

 Validate structure of JSON for a single Cycle group object.

=cut

sub validateCycleGroup {
  my $self       = shift;
  my $test       = shift;
  my $ret        = 1;
  my $JSONStruct = {
    type       => 'object',
    properties => { 
      createdAt    => { type  => ['DateTime::Format::ISO8601','string'], required => 1 },
      applianceId  => { type  =>  'string',                              required => 1 },
      id           => { type  =>  'string',                              required => 1 },
      sensorId     => { type  =>  'string',                              required => 1 },
      attributes => {
        type       => 'object',
        properties => { 
          cycleThreshold => { type => 'number', required => 1 },
        }
      },
    }
  };

  if ($test != 0) {
    my $validator = JSON::Schema->new($JSONStruct);
    my $valid     = $validator->validate($test);
    if ($valid) {
        $self->{'neurio'}->printLOG("    PASSED: JSON Cycle Group structure is valid!\n");
      if (not $self->validateGuesses  ($test->{'guesses'})) {$ret = 0;}
    } else {
      $self->{'neurio'}->printLOG("    FAILED: JSON CycleGroup STRUCTURE is NOT valid!\n");
      $self->{'neurio'}->printLOG(Dumper($test));
      $self->{'neurio'}->printLOG(Dumper($valid));
      $ret = 0;
    }
  } else {
    $self->{'neurio'}->printLOG("    FAILED: No CycleGroup data received\n");
    $ret=0;
  }
  return $ret;
}

###################################################################################################

=head2 validateCycleGroups

 Validate structure of JSON for an array of Cycle objects.

=cut

sub validateCycleGroups {
  my $self   = shift;
  my $test   = shift;
  my $count  = 0;
  my $ret    = 1;

  if ($test != 0) {
    foreach my $cycleGroup (@{$test}) {
      $count++;
      $self->{'neurio'}->printLOG("    CycleGroup $count:");
      if (not $self->validateCycleGroup($cycleGroup)) { $ret = 0; }
    }
  } else {
    $self->{'neurio'}->printLOG("  FAILED: No CycleGroup data returned\n");
    $ret=0;
  }
  return $ret;
}


###################################################################################################

=head2 validateEdge

 Validate structure of JSON for an array of Edge objects.

=cut

sub validateEdge {
  my $self       = shift;
  my $test       = shift;
  my $ret        = 1;
  my $JSONStruct = {
    type       => 'object',
    required   => 0,
    properties => { 
      start       => { type  => ['DateTime::Format::ISO8601','string'], required => 0 },
      peak        => { type  => ['DateTime::Format::ISO8601','string'], required => 0 },
      end         => { type  => ['DateTime::Format::ISO8601','string'], required => 0 },
      sensorId    => { type  =>  'string',                              required => 0 },
      direction   => { type  =>  'number',                              required => 0 },
      id          => { type  =>  'string',                              required => 0 },
      channelType => { oneOf => ['phase_a', 'phase_b', 'consumption'],  required => 0 },
      powerDelta  => { type  =>  'number',                              required => 0 },
      groupIds => {
        type     => 'array',
        minItems => 0,
        items    => { type  => 'string' }
      },
    }
  };

  if ($test != 0) {
    my $validator = JSON::Schema->new($JSONStruct);
    my $valid     = $validator->validate($test);
    if ($valid) {
      my $count = 0;
      $self->{'neurio'}->printLOG("    PASSED: JSON Edge structure is valid!\n");
      foreach my $channelSample (@{$test->{'upEdge'}->{'samples'}}) {
        if (defined($test->{'upEdge'}->{'significant'})) {
          if ((to_json($test->{'upEdge'}->{'significant'}) ne 'false') and (to_json($test->{'upEdge'}->{'significant'}) ne 'true')) { $ret = 0; }
        }
        if (not $self->validateChannelSample($channelSample)) { $ret = 0; }
        $count++;
      }
      $count = 0;
      foreach my $channelSample (@{$test->{'downEdge'}->{'samples'}}) {
        if (defined($test->{'downEdge'}->{'significant'})) {
          if ((to_json($test->{'downEdge'}->{'significant'}) ne 'false') and (to_json($test->{'downEdge'}->{'significant'}) ne 'true')) { $ret = 0; }
        }
        if (not $self->validateChannelSample($channelSample)) { $ret = 0; }
        $count++;
      }
    } else {
      $self->{'neurio'}->printLOG("    FAILED: JSON Edge STRUCTURE is NOT valid!\n");
      $self->{'neurio'}->printLOG(Dumper($test));
      $self->{'neurio'}->printLOG(Dumper($valid));
      $ret = 0;
    }
  } else {
    $self->{'neurio'}->printLOG("    FAILED: No Edge data received\n");
    $ret=0;
  }
  return $ret;
}




#*****************************************************************

=head1 AUTHOR

Kedar Warriner, C<kedar at cpan.org>

=head1 BUGS

 Please report any bugs or feature requests to C<bug-device-NeurioTest at rt.cpan.org>
 or through the web interface at http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Device-NeurioTest
 I will be notified, and then you'll automatically be notified of progress on 
 your bug as I make changes.


=head1 SUPPORT

 You can find documentation for this module with the perldoc command.

  perldoc Device::NeurioTest


 You can also look for information at:

=over 5

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Device-NeurioTest>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Device-NeurioTest>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Device-NeurioTest>

=item * Search CPAN

L<http://search.cpan.org/dist/Device-NeurioTest/>

=back


=head1 ACKNOWLEDGEMENTS

 Many thanks to:
  The guys at Energy Aware Technologies for creating the Neurio sensor and 
      developping the API.
  Everyone involved with CPAN.

=head1 LICENSE AND COPYRIGHT

 Copyright 2014 Kedar Warriner <kedar at cpan.org>.

 This program is free software; you can redistribute it and/or modify it
 under the terms of either: the GNU General Public License as published
 by the Free Software Foundation; or the Artistic License.

 See http://dev.perl.org/licenses/ for more information.


=cut

#************************************************************************
1; # End of Device::NeurioTest - Return success to require/use statement
#************************************************************************

