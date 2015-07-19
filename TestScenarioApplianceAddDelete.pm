package TestScenarioApplianceAddDelete;

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
      print "\nTestScenarioApplianceAddDelete->new(): Neurio, NeurioTest and NeurioTools are REQUIRED parameters\n";
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


sub ScenarioApplianceAddDelete_01 {
  my $self   = shift;
  my $title  = "Delete all test appliances";
  my $testID = "Scenario_add_ApplianceDelete_01";
  my $desc   = "Cleanup by deleting all appliances with the word 'test' in their label.";
  my $defect = undef;
  my $i      = 0;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->fetch_Appliances();
  $self->{'neurioTest'}->expectAPIPass($test,"Content should not have been empty",200,$defect);
  foreach my $appl (@{$test}) {
    if ($test->[$i]->{'label'} =~ /test/) {
      $self->{'neurio'}->printLOG("  Deleting test appliance $i <".$test->[$i]->{'name'}."> with label <".$test->[$i]->{'label'}.">\n");
      my $test = $self->{'neurio'}->delete_Appliance($test->[$i]->{'id'});
      $self->{'neurioTest'}->expectAPIPass(eval{$test eq ''},"Content should not have been empty",204,$defect);
    } else {
      $self->{'neurio'}->printLOG("  Found non-test appliance <".$test->[$i]->{'name'}."> with label <".$test->[$i]->{'label'}.">\n");
    }
  	$i++;
  }
  $self->{'neurioTest'}->closeTestCase();
}

sub ScenarioApplianceAddDelete_02 {
  my $self   = shift;
  my $title  = "Delete an invalid appliance name";
  my $testID = "Scenario_add_ApplianceDelete_02";
  my $desc   = "Validate deleting an invalid appliance name.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->delete_Appliance('abc');
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",404,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ScenarioApplianceAddDelete_03 {
  my $self   = shift;
  my $title  = "Delete a valid appliance that doesn't exist";
  my $testID = "Scenario_add_ApplianceDelete_03";
  my $desc   = "Validate deleting a valid appliance that doesn't exist.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->delete_Appliance('toaster');
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",404,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ScenarioApplianceAddDelete_04 {
  my $self   = shift;
  my $title  = "Add an unsupported appliance";
  my $testID = "Scenario_add_ApplianceDelete_04";
  my $desc   = "Validate than an unsupported appliance cannot be added.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->add_Appliance($self->{'neurio'}->{'location_id'},'abc123','abc123');
  $self->{'neurioTest'}->expectAPIFail($test,"Content should have been empty",422,$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ScenarioApplianceAddDelete_05 {
  my $self   = shift;
  my $title  = "Add a new air_conditioner appliance";
  my $testID = "Scenario_add_ApplianceDelete_05";
  my $desc   = "Validate that a new air_conditioner appliance can be added.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->add_Appliance($self->{'neurio'}->{'location_id'},"air_conditioner","air conditioner test");
  $self->{'neurioTest'}->expectAPIPass(eval{$test ne ''},"Content should not have been empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$test->{'label'} eq 'air conditioner test'},"'air conditioner test' label","created",$defect); 
  my $appl = $self->{'neurioTools'}->get_appliance_ID("air_conditioner","air conditioner test");
  $self->{'neurioTest'}->expectPass($appl,"Air Conditioner Appliance","defined",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ScenarioApplianceAddDelete_06 {
  my $self   = shift;
  my $title  = "Add a second air_conditioner appliance";
  my $testID = "Scenario_add_ApplianceDelete_05";
  my $desc   = "Validate that a second air_conditioner appliance can be added.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->add_Appliance($self->{'neurio'}->{'location_id'},"air_conditioner","air conditioner test");
  $self->{'neurioTest'}->expectAPIPass(eval{$test ne ''},"Content should not have been empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$test->{'label'} eq 'air conditioner test'},"'air conditioner test' label","created",$defect);
  my $appl = $self->{'neurioTools'}->get_appliance_ID("air_conditioner","air conditioner test");
  $self->{'neurioTest'}->expectPass($appl,"Air Conditioner Appliance","defined",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ScenarioApplianceAddDelete_07 {
  my $self   = shift;
  my $title  = "Add a new dryer appliance";
  my $testID = "Scenario_add_ApplianceDelete_06";
  my $desc   = "Validate that a new dryer appliance can be added.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->add_Appliance($self->{'neurio'}->{'location_id'},"dryer","dryer test");
  $self->{'neurioTest'}->expectAPIPass(eval{$test ne ''},"Content should not have been empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$test->{'label'} eq 'dryer test'},"'dryer test' label","created",$defect);
  my $appl = $self->{'neurioTools'}->get_appliance_ID("dryer","dryer test");
  $self->{'neurioTest'}->expectPass($appl,"dryer Appliance","defined",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ScenarioApplianceAddDelete_08 {
  my $self   = shift;
  my $title  = "Add a new electric_kettle appliance";
  my $testID = "Scenario_add_ApplianceDelete_07";
  my $desc   = "Validate that a new electric_kettle appliance can be added.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->add_Appliance($self->{'neurio'}->{'location_id'},"electric_kettle","electric_kettle test");
  $self->{'neurioTest'}->expectAPIPass(eval{$test ne ''},"Content should not have been empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$test->{'label'} eq 'electric_kettle test'},"'electric_kettle test' label","created",$defect);
  my $appl = $self->{'neurioTools'}->get_appliance_ID("electric_kettle","electric_kettle test");
  $self->{'neurioTest'}->expectPass($appl,"electric_kettle Appliance","defined",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ScenarioApplianceAddDelete_09 {
  my $self   = shift;
  my $title  = "Add a new heater appliance";
  my $testID = "Scenario_add_ApplianceDelete_08";
  my $desc   = "Validate that a new heater appliance can be added.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->add_Appliance($self->{'neurio'}->{'location_id'},"heater","heater test");
  $self->{'neurioTest'}->expectAPIPass(eval{$test ne ''},"Content should not have been empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$test->{'label'} eq 'heater test'},"'heater test' label","created",$defect);
  my $appl = $self->{'neurioTools'}->get_appliance_ID("heater","heater test");
  $self->{'neurioTest'}->expectPass($appl,"heater Appliance","defined",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ScenarioApplianceAddDelete_10 {
  my $self   = shift;
  my $title  = "Add a new microwave appliance";
  my $testID = "Scenario_add_ApplianceDelete_09";
  my $desc   = "Validate that a new microwave appliance can be added.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->add_Appliance($self->{'neurio'}->{'location_id'},"microwave","microwave test");
  $self->{'neurioTest'}->expectAPIPass(eval{$test ne ''},"Content should not have been empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$test->{'label'} eq 'microwave test'},"'microwave test' label","created",$defect);
  my $appl = $self->{'neurioTools'}->get_appliance_ID("microwave","microwave test");
  $self->{'neurioTest'}->expectPass($appl,"microwave Appliance","defined",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ScenarioApplianceAddDelete_11 {
  my $self   = shift;
  my $title  = "Add a new other appliance";
  my $testID = "Scenario_add_ApplianceDelete_10";
  my $desc   = "Validate that a new other appliance can be added.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->add_Appliance($self->{'neurio'}->{'location_id'},"other","other test");
  $self->{'neurioTest'}->expectAPIPass(eval{$test ne ''},"Content should not have been empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$test->{'label'} eq 'other test'},"'other test' label","created",$defect);
  my $appl = $self->{'neurioTools'}->get_appliance_ID("other","other test");
  $self->{'neurioTest'}->expectPass($appl,"other Appliance","defined",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ScenarioApplianceAddDelete_12 {
  my $self   = shift;
  my $title  = "Add a new oven appliance";
  my $testID = "Scenario_add_ApplianceDelete_11";
  my $desc   = "Validate that a new oven appliance can be added.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->add_Appliance($self->{'neurio'}->{'location_id'},"oven","oven test");
  $self->{'neurioTest'}->expectAPIPass(eval{$test ne ''},"Content should not have been empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$test->{'label'} eq 'oven test'},"'oven test' label","created",$defect);
  my $appl = $self->{'neurioTools'}->get_appliance_ID("oven","oven test");
  $self->{'neurioTest'}->expectPass($appl,"oven Appliance","defined",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ScenarioApplianceAddDelete_13 {
  my $self   = shift;
  my $title  = "Add a new refrigerator appliance";
  my $testID = "Scenario_add_ApplianceDelete_12";
  my $desc   = "Validate that a new refrigerator appliance can be added.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->add_Appliance($self->{'neurio'}->{'location_id'},"refrigerator","refrigerator test");
  $self->{'neurioTest'}->expectAPIPass(eval{$test ne ''},"Content should not have been empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$test->{'label'} eq 'refrigerator test'},"'refrigerator test' label","created",$defect);
  my $appl = $self->{'neurioTools'}->get_appliance_ID("refrigerator","refrigerator test");
  $self->{'neurioTest'}->expectPass($appl,"refrigerator Appliance","defined",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ScenarioApplianceAddDelete_14 {
  my $self   = shift;
  my $title  = "Add a new stove appliance";
  my $testID = "Scenario_add_ApplianceDelete_13";
  my $desc   = "Validate that a new stove appliance can be added.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->add_Appliance($self->{'neurio'}->{'location_id'},"stove","stove test");
  $self->{'neurioTest'}->expectAPIPass(eval{$test ne ''},"Content should not have been empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$test->{'label'} eq 'stove test'},"'stove test' label","created",$defect);
  my $appl = $self->{'neurioTools'}->get_appliance_ID("stove","stove test");
  $self->{'neurioTest'}->expectPass($appl,"stove Appliance","defined",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ScenarioApplianceAddDelete_15 {
  my $self   = shift;
  my $title  = "Add a new toaster appliance";
  my $testID = "Scenario_add_ApplianceDelete_14";
  my $desc   = "Validate that a new toaster appliance can be added.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $test   = $self->{'neurio'}->add_Appliance($self->{'neurio'}->{'location_id'},"toaster","toaster test");
  $self->{'neurioTest'}->expectAPIPass(eval{$test ne ''},"Content should not have been empty",200,$defect);
  $self->{'neurioTest'}->expectPass(eval{$test->{'label'} eq 'toaster test'},"'toaster test' label","created",$defect);
  my $appl = $self->{'neurioTools'}->get_appliance_ID("toaster","toaster test");
  $self->{'neurioTest'}->expectPass($appl,"toaster Appliance","defined",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ScenarioApplianceAddDelete_16 {
  my $self   = shift;
  my $title  = "Delete the first air_condition appliance";
  my $testID = "Scenario_add_ApplianceDelete_15";
  my $desc   = "Validate that an existing air_conditioner can be deleted.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $appl   = $self->{'neurioTools'}->get_appliance_ID("air_conditioner","air conditioner test");
  my $test   = $self->{'neurio'}->delete_Appliance($appl);
  $self->{'neurioTest'}->expectAPIPass(eval{$test eq ''},"Content should NOT have been empty",204,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTools'}->get_appliance_ID("air_conditioner","air conditioner test") ne ''},"First air_conditioner", "removed",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ScenarioApplianceAddDelete_17 {
  my $self   = shift;
  my $title  = "Delete the second air_condition appliance";
  my $testID = "Scenario_add_ApplianceDelete_16";
  my $desc   = "Validate that an existing air_conditioner can be deleted.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $appl   = $self->{'neurioTools'}->get_appliance_ID("air_conditioner","air conditioner test");
  my $test   = $self->{'neurio'}->delete_Appliance($appl);
  $self->{'neurioTest'}->expectAPIPass(eval{$test eq ''},"Content should NOT have been empty",204,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTools'}->get_appliance_ID("air_conditioner","air conditioner test") == 0},"Second air_conditioner", "removed",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ScenarioApplianceAddDelete_18 {
  my $self   = shift;
  my $title  = "Delete a dryer appliance";
  my $testID = "Scenario_add_ApplianceDelete_17";
  my $desc   = "Validate that an existing dryer can be deleted.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $appl   = $self->{'neurioTools'}->get_appliance_ID("dryer","dryer test");
  my $test   = $self->{'neurio'}->delete_Appliance($appl);
  $self->{'neurioTest'}->expectAPIPass(eval{$test eq ''},"Content should NOT have been empty",204,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTools'}->get_appliance_ID("dryer","dryer test") == 0},"dryer", "removed",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ScenarioApplianceAddDelete_19 {
  my $self   = shift;
  my $title  = "Delete a electric_kettle appliance";
  my $testID = "Scenario_add_ApplianceDelete_18";
  my $desc   = "Validate that an existing electric_kettle can be deleted.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $appl   = $self->{'neurioTools'}->get_appliance_ID("electric_kettle","electric_kettle test");
  my $test   = $self->{'neurio'}->delete_Appliance($appl);
  $self->{'neurioTest'}->expectAPIPass(eval{$test eq ''},"Content should NOT have been empty",204,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTools'}->get_appliance_ID("electric_kettle","electric_kettle test") == 0},"electric_kettle", "removed",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ScenarioApplianceAddDelete_20 {
  my $self   = shift;
  my $title  = "Delete a heater appliance";
  my $testID = "Scenario_add_ApplianceDelete_19";
  my $desc   = "Validate that an existing heater can be deleted.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $appl   = $self->{'neurioTools'}->get_appliance_ID("heater","heater test");
  my $test   = $self->{'neurio'}->delete_Appliance($appl);
  $self->{'neurioTest'}->expectAPIPass(eval{$test eq ''},"Content should NOT have been empty",204,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTools'}->get_appliance_ID("heater","heater test") == 0},"heater", "removed",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ScenarioApplianceAddDelete_21 {
  my $self   = shift;
  my $title  = "Delete a microwave appliance";
  my $testID = "Scenario_add_ApplianceDelete_20";
  my $desc   = "Validate that an existing microwave can be deleted.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $appl   = $self->{'neurioTools'}->get_appliance_ID("microwave","microwave test");
  my $test   = $self->{'neurio'}->delete_Appliance($appl);
  $self->{'neurioTest'}->expectAPIPass(eval{$test eq ''},"Content should NOT have been empty",204,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTools'}->get_appliance_ID("microwave","microwave test") == 0},"microwave", "removed",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ScenarioApplianceAddDelete_22 {
  my $self   = shift;
  my $title  = "Delete a other appliance";
  my $testID = "Scenario_add_ApplianceDelete_21";
  my $desc   = "Validate that an existing other can be deleted.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $appl   = $self->{'neurioTools'}->get_appliance_ID("other","other test");
  my $test   = $self->{'neurio'}->delete_Appliance($appl);
  $self->{'neurioTest'}->expectAPIPass(eval{$test eq ''},"Content should NOT have been empty",204,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTools'}->get_appliance_ID("other","other test") == 0},"other", "removed",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ScenarioApplianceAddDelete_23 {
  my $self   = shift;
  my $title  = "Delete a oven appliance";
  my $testID = "Scenario_add_ApplianceDelete_22";
  my $desc   = "Validate that an existing oven can be deleted.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $appl   = $self->{'neurioTools'}->get_appliance_ID("oven","oven test");
  my $test   = $self->{'neurio'}->delete_Appliance($appl);
  $self->{'neurioTest'}->expectAPIPass(eval{$test eq ''},"Content should NOT have been empty",204,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTools'}->get_appliance_ID("oven","oven test") == 0},"oven", "removed",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ScenarioApplianceAddDelete_24 {
  my $self   = shift;
  my $title  = "Delete a refrigerator appliance";
  my $testID = "Scenario_add_ApplianceDelete_23";
  my $desc   = "Validate that an existing refrigerator  can be deleted.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $appl   = $self->{'neurioTools'}->get_appliance_ID("refrigerator","refrigerator test");
  my $test   = $self->{'neurio'}->delete_Appliance($appl);
  $self->{'neurioTest'}->expectAPIPass(eval{$test eq ''},"Content should NOT have been empty",204,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTools'}->get_appliance_ID("refrigerator","refrigerator test") == 0},"refrigerator", "removed",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ScenarioApplianceAddDelete_25 {
  my $self   = shift;
  my $title  = "Delete a stove appliance";
  my $testID = "Scenario_add_ApplianceDelete_24";
  my $desc   = "Validate that an existing stove can be deleted.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $appl   = $self->{'neurioTools'}->get_appliance_ID("stove","stove test");
  my $test   = $self->{'neurio'}->delete_Appliance($appl);
  $self->{'neurioTest'}->expectAPIPass(eval{$test eq ''},"Content should NOT have been empty",204,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTools'}->get_appliance_ID("stove","stove test") == 0},"stove", "removed",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ScenarioApplianceAddDelete_26 {
  my $self   = shift;
  my $title  = "Delete a toaster appliance";
  my $testID = "Scenario_add_ApplianceDelete_25";
  my $desc   = "Validate that an existing toaster can be deleted.";
  my $defect = undef;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  my $appl   = $self->{'neurioTools'}->get_appliance_ID("toaster","toaster test");
  my $test   = $self->{'neurio'}->delete_Appliance($appl);
  $self->{'neurioTest'}->expectAPIPass(eval{$test eq ''},"Content should NOT have been empty",204,$defect);
  $self->{'neurioTest'}->expectPass(eval{$self->{'neurioTools'}->get_appliance_ID("toaster","toaster test") == 0},"toaster", "removed",$defect);
  $self->{'neurioTest'}->closeTestCase();
}


sub ScenarioApplianceAddDelete_27 {
  my $self   = shift;
  my $title  = "Add maximum number of instances of one appliance";
  my $testID = "Scenario_add_ApplianceDelete_26";
  my $desc   = "Validate the maximum number of times the same appliance can be added.";
  my $defect = "NEURIOEXT-44";
  my $max    = 16;
  my $count  = 0;
  $self->{'neurioTest'}->openTestCase($testID,$title,$desc);
  for (my $i=0;$i<$max;$i++) {
    $self->{'neurio'}->printLOG("  Adding test appliance <stove> with label <stove test$i>\n");
    my $test   = $self->{'neurio'}->add_Appliance($self->{'neurio'}->{'location_id'},"stove","stove test$i");
    $self->{'neurioTest'}->expectAPIPass(eval{$test ne ''},"Content should have been empty",200,$defect);
  }
  my $test   = $self->{'neurio'}->fetch_Appliances($self->{'neurio'}->{'location_id'});
  $self->{'neurioTest'}->expectAPIPass(eval{$test ne ''},"Content should not have been empty",200,$defect);
  
  foreach my $appl(@{$test}) {
    if ($appl->{'label'} =~ /test/) {
      $self->{'neurio'}->printLOG("    Found: ".$appl->{'label'}."\n");
      $count++;
    }
  }
  $self->{'neurioTest'}->expectPass(eval{$count == $max},"Number of appliances",$max,$defect);
  $self->{'neurioTest'}->closeTestCase();
}

1
