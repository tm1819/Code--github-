#!/usr/bin/perl
#use strict;

#> perl ParsingTest.pl
# Number Unique Users in Sessions file:
#  /"[^"]+"\s"[^"]+"\s"([^"]*)"/
# perl analytics.pl -hourlyAverage session.csv event.csv

print "**************************** USAGE ******************************\n";
print "*	> perl analytics sessions.csv events.csv		*\n";
print "*****************************************************************\n";
print "sessions file: " . $ARGV[1] . "\n";
print "events file: " . $ARGV[2] . "\n";
print "mode: " . $ARGV[0] . "\n";
print "-----------------------------------------------------------------\n";

$mode = $ARGV[0];
if ($mode ne "-hourlyAverage") {
	print "Fatal Error: mode is invalid.  Valid options are: -hourlyAverage\n";
	exit 0;
}

# COPY EVENT FILE INTO ARRAY. FOR PERFORMANCE REASONS
@events;
open EVENT_FILE, "<", $ARGV[2] or die "Can't open event file $!\n";
$eventsFileLen = 0;
while (my $eventFileLine = <EVENT_FILE>) {
	$events[$eventsFileLen] = $eventFileLine;
	$eventsFileLen++;
}
close EVENT_FILE;

# SPLIT EVENT ARRAY INTO DAILY SUB-ARRAYS
%days;
@keyz;
for ($i=0; $i < scalar @events; $i++) {
	if ($events[$i] =~ /"([^",^-]*)-([^",^-]*)-([^",^\s]*)\s([^:]*):([^:]*):([^"]*)"/) {
		my $timeStamp = $1 . $2 . $3;
		push @{$days->{$timeStamp}}, $events[$i];
		
		# MAKE SURE KEY IS UNIQUE BEFORE PUSHING IT
		my $keyIsUnique = 1;
		for (my $j=0; $j< scalar @keyz; $j++) {
			if ($keyz[$j] == $timeStamp) {
				$keyIsUnique = 0;
			}
		}
		if ($keyIsUnique) {
			push @keyz, $timeStamp;
		}
	} else {
		#print "Error: Event has no timestamp for event line\n";
	}
}

@globalAliasesTally = (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
@globalAnnouncementsTally = (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
@globalAssignmentsTally = (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
@globalBecomeUserTally = (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
@globalChatRoomTally = (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
@globalDelegatedAccessTally = (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
@globalForumsTally = (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
@globalGradebookTally = (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
@globalHelpTally = (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
@globalMessagesTally = (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
@globalPreferencesTally = (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
@globalProfileTally = (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
@globalResourcesTally = (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
@globalRosterTally = (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
@globalScheduleTally = (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
@globalSyllabusTally = (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
@globalTestsAndQuizzesTally = (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
@globalWebContentTally = (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);

for (my $x=0; $x < scalar @keyz; $x++) {
# This is each day
	my @lines = ("","","","","","","","","","","","","","","","","","","","","","","","");
	my $arrayRef = \@lines;
	my @hours = ($arrayRef);
	
	for ($y=0; $y < scalar @{$days->{$keyz[$x]}}; $y++) {
		# This is each line on that day
		$currLineOnParticularDay = @{$days->{$keyz[$x]}}->[$y];
		#print $currLineOnParticularDay;
		if ($currLineOnParticularDay =~ /"([^",^-]*)-([^",^-]*)-([^",^\s]*)\s([^:]*):([^:]*):([^"]*)"/) {
			$currLinesTimeStamp= $4 . $5 . $6;
			for ($z=0; $z<24; $z++) {
				if (($currLinesTimeStamp > $z*10000) and ($currLinesTimeStamp < $z*10000+10000)) {
					#z is the current line of given hour of given day
					push @{$hours[$z]}, $currLineOnParticularDay; #read as hour $z, line $z
				}
				
			}
		} else {
			#print "Error: Event has no timestamp at hour " . $z . "\n";
		}
	}
	
	for (my $b=0; $b<24; $b++) {
		#hour b of day x
		#print "Hour " . $b . ":\n";
		for ($c=0; $c< scalar @{$hours[$b]}; $c++) {
			#line c of hour b of day x
			#print $hours[$b]->[$c];
			my $currEventLine = $hours[$b]->[$c];
			if ($currEventLine =~ /alias./) {
				$globalAliasesTally[$b]++;
			}
			elsif ($currEventLine =~ /annc./) {
				$globalAnnouncementsTally[$b]++;
			}
			elsif ($currEventLine =~ /asn./) {
				$globalAssignmentsTally[$b]++;
			}
			elsif ($currEventLine =~ /su./) {
				$globalBecomeUserTally[$b]++;
			}
			elsif ($currEventLine =~ /chat./) {
				$globalChatRoomTally[$b]++;
			}
			elsif ($currEventLine =~ /dac./) {
				$globalDelegatedAccessTally[$b]++;
			}
			elsif ($currEventLine =~ /forums./) {
				$globalForumsTally[$b]++;
			}
			elsif ($currEventLine =~ /gradebook./) {
				$globalGradebookTally[$b]++;
			}
			elsif ($currEventLine =~ /help./) {
				$globalHelpTally[$b]++;
			}
			elsif ($currEventLine =~ /messages./) {
				$globalMessagesTally[$b]++;
			}
			elsif ($currEventLine =~ /prefs./) {
				$globalPreferencesTally[$b]++;
			}
			elsif ($currEventLine =~ /profile./) {
				$globalProfileTally[$b]++;
			}
			elsif ($currEventLine =~ /webcontent./) {
				$globalWebContentTally[$b]++;
			}
			elsif ($currEventLine =~ /content./) {
				$globalResourcesTally[$b]++;
			}
			elsif ($currEventLine =~ /roster./) {
				$globalRosterTally[$b]++;
			}
			elsif ($currEventLine =~ /calendar./) {
				$globalScheduleTally[$b]++;
			}
			elsif ($currEventLine =~ /syllabus./) {
				$globalSyllabusTally[$b]++;
			}
			elsif ($currEventLine =~ /sam./) {
				$globalTestsAndQuizzesTally[$b]++;
			}
		}
	}
}

if ($mode eq "-hourlyAverage") {
	print "\nHourly Average Usage Data for all data in the included CSV Files\n";
	print "			12-1M	1-2am	2-3am	3-4am	4-5am	5-6am	6-7am	7-8am	8-9am	9-10am	10-11am	11-12N	12-1pm	1-2pm	2-3pm	3-4pm	4-5pm	5-6pm	6-7pm	7-8pm	8-9pm	9-10pm	10-11pm	11-12pm\n";
	print "-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n";
	print "Aliases" . "			";
	for ($i=0; $i<24; $i++) {
		print sprintf "%.2f", $globalAliasesTally[$i] / scalar @keyz;
		print "	";
	}
	print "\nAnnouncements" . "		";
	for ($i=0; $i<24; $i++) {
		print sprintf "%.2f", $globalAnnouncementsTally[$i] / scalar @keyz;
		print "	";
	}
	print "\nAssignments" . "		";
	for ($i=0; $i<24; $i++) {
		print sprintf "%.2f", $globalAssignmentsTally[$i] / scalar @keyz;
		print "	";
	}
	print "\nBecome User" . "		";
	for ($i=0; $i<24; $i++) {
		print sprintf "%.2f", $globalBecomeUserTally[$i] / scalar @keyz;
		print "	";
	}
	print "\nChat Room" . "		";
	for ($i=0; $i<24; $i++) {
		print sprintf "%.2f", $globalChatRoomTally[$i] / scalar @keyz;
		print "	";
	}
	print "\nDelegated Access" . "	";
	for ($i=0; $i<24; $i++) {
		print sprintf "%.2f", $globalDelegatedAccessTally[$i] / scalar @keyz;
		print "	";
	}
	print "\nForums" . "			";
	for ($i=0; $i<24; $i++) {
		print sprintf "%.2f", $globalForumsTally[$i] / scalar @keyz;
		print "	";
	}
	print "\nGradebook" . "		";
	for ($i=0; $i<24; $i++) {
		print sprintf "%.2f", $globalGradebookTally[$i] / scalar @keyz;
		print "	";
	}
	print "\nHelp" . "			";
	for ($i=0; $i<24; $i++) {
		print sprintf "%.2f", $globalHelpTally[$i] / scalar @keyz;
		print "	";
	}
	print "\nMessages" . "		";
	for ($i=0; $i<24; $i++) {
		print sprintf "%.2f", $globalMessagesTally[$i] / scalar @keyz;
		print "	";
	}
	print "\nPreferences" . "		";
	for ($i=0; $i<24; $i++) {
		print sprintf "%.2f", $globalPreferencesTally[$i] / scalar @keyz;
		print "	";
	}
	print "\nProfile" . "			";
	for ($i=0; $i<24; $i++) {
		print sprintf "%.2f", $globalProfileTally[$i] / scalar @keyz;
		print "	";
	}
	print "\nResources" . "		";
	for ($i=0; $i<24; $i++) {
		print sprintf "%.2f", $globalResourcesTally[$i] / scalar @keyz;
		print "	";
	}
	print "\nRoster" . "			";
	for ($i=0; $i<24; $i++) {
		print sprintf "%.2f", $globalRosterTally[$i] / scalar @keyz;
		print "	";
	}
	print "\nSchedule" . "		";
	for ($i=0; $i<24; $i++) {
		print sprintf "%.2f", $globalScheduleTally[$i] / scalar @keyz;
		print "	";
	}
	print "\nSyllabus" . "		";
	for ($i=0; $i<24; $i++) {
		print sprintf "%.2f", $globalSyllabusTally[$i] / scalar @keyz;
		print "	";
	}
	print "\nTests & Quizzes" . "		";
	for ($i=0; $i<24; $i++) {
		print sprintf "%.2f", $globalTestsAndQuizzesTally[$i] / scalar @keyz;
		print "	";
	}
	print "\nWebCnt/LibRs/News" . "	";
	for ($i=0; $i<24; $i++) {
		print sprintf "%.2f", $globalWebContentTally[$i] / scalar @keyz;
		print "	";
	}
	print "\n";
}

