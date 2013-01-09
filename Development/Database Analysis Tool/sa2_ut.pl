#!/usr/bin/perl -w
use FindBin;                  # Suppose my script is /home/foo/bin/main.pl
use lib "$FindBin::Bin/lib";  # Add /home/foo/bin/lib to search path

# PRINT BOILER PLATE PLATE
print "//////////////// SAKAI ANALYTICS 2.0 UNIT TESTS \\\\\\\\\\\\\\\\\\n";
print "* AUTHOR: TOM MARTIN\n";
print "* USAGE: > perl <scriptName> <-eventFile | -sessionFile> fileName\n";
print "VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV\n";

# TEST isLeapYear FUNCTION
print "-----------------------------------------------------------------\n";
print "TEST isLeapYear:\n";
print "isLeapYear(1970): " . isLeapYear(1970) . "\n";
print "isLeapYear(1971): " . isLeapYear(1971) . "\n";
print "isLeapYear(1972): " . isLeapYear(1972) . "\n";
print "isLeapYear(1973): " . isLeapYear(1973) . "\n";
print "isLeapYear(1974): " . isLeapYear(1974) . "\n";
print "isLeapYear(1975): " . isLeapYear(1975) . "\n";
print "isLeapYear(1976): " . isLeapYear(1976) . "\n";
print "isLeapYear(1977): " . isLeapYear(1977) . "\n";
print "isLeapYear(1978): " . isLeapYear(1978) . "\n";
print "isLeapYear(1979): " . isLeapYear(1979) . "\n";
print "isLeapYear(1980): " . isLeapYear(1980) . "\n";
print "\n";

# TEST countLeapDays FUNCTION
print "-----------------------------------------------------------------\n";
print "TEST countLeapDays: (Upper Boundary Excluded, multiple valus in middle)\n";
print "countLeapDays (2012, 2, 28, 1970, 1, 1): "
	. countLeapDays(2012, 2, 28, 1970, 1, 1) . "; expected value: 10\n";
print "countLeapDays (2012, 2, 29, 1970, 1, 1): "
	. countLeapDays(2012, 2, 29, 1970, 1, 1) . "; expected value: 11\n";
print "countLeapDays (2012, 3, 1, 1970, 1, 1): "
	. countLeapDays(2012, 3, 1, 1970, 1, 1) . "; expected value 11\n";
print "TEST countLeapDays: (Lower Boundary Excluded, multiple values in middle)\n";
print "countLeapDays (2012, 3, 1, 1972, 1, 1): "
	. countLeapDays(2012, 3, 1, 1972, 1, 1) . "; expected value 11\n";
print "countLeapDays (2012, 3, 1, 1972, 2, 28): "
	. countLeapDays(2012, 3, 1, 1972, 2, 28) . "; expected value 11\n";
print "countLeapDays (2012, 3, 1, 1972, 2, 29): "
	. countLeapDays(2012, 3, 1, 1972, 2, 29) . "; expected value 11\n";
print "countLeapDays (2012, 3, 1, 1972, 3, 1): "
	. countLeapDays(2012, 3, 1, 1972, 3, 1) . "; expected value 10\n";
print "TEST countLeapDays: (Upper Boundary Excluded, no values in middle)\n";
print "countLeapDays (1972, 2, 29, 1972, 2, 28): "
	. countLeapDays(1972, 2, 29, 1972, 2, 28) . "; expected value 1\n";
print "TEST countLeapDays: (Lower Boundary Excluded, no values in middle)\n";
print "countLeapDays (1972, 2, 30, 1972, 2, 29): "
	. countLeapDays(1972, 2, 30, 1972, 2, 29) . "; expected value 1\n";
print "TEST countLeapDays: (Both Boundaries Excluded, no values in middle)\n";
print "countLeapDays (1972, 2, 29, 1972, 2, 29): "
	. countLeapDays(1972, 2, 29, 1972, 2, 29) . "; expected value 1\n";
print "\n";

# TEST diffYMD FUNCTION
print "-----------------------------------------------------------------\n";
print "TEST diffYMD:\n";
print "diffYMD (2012, 3, 1, 1972, 3, 1): " . diffYMD (2012, 3, 1, 1972, 3, 1) . "\n";
print "\n";

# TEST TIMESTAMP CONVERSION FUNCTION
print "-----------------------------------------------------------------\n";
print "TEST sakaiTimeToEpochTime:\n";
print "sakaiTimeToEpochTime (\"2012-12-01 14:43:28.0\"): "
	. sakaiTimeToEpochTime ("2012-12-01 14:43:28.0")
	. "; expected value: 1,354,373,008 seconds\n";
print "\n";

# TEST CREATE FUNCTION
print "-----------------------------------------------------------------\n";
print "TEST RRDs::create:\n";
RRDs::create ("usage.rrd",
	"--start", "1023654125",
	"--step", "3600",
	"DS:mem:COUNTER:600:0:671744",
	"RRA:AVERAGE:0.5:12:24",
	"RRA:AVERAGE:0.5:288:31");
my $ERR=RRDs::error;
die "RRD ERROR: $ERR\n" if $ERR;
print "RRD created Successfully\n";
print "\n";

# TEST READ TABLE
print "-----------------------------------------------------------------\n";
readTable ($fileType, $filePath);

# TEST COUNT EVENTS OVER INTERVAL
print "-----------------------------------------------------------------\n";
print "TEST countEventsOverInterval:\n";
print "countEvents: countEventsOverInterval (\$eventsAoH,\"site.upd\",2011,12,21,5,31,12,2011,12,22,6,40,28): " 
	. countEventsOverInterval ($eventsAoH,"site.upd",2011,12,21,5,31,12,2011,12,22,6,40,28) . "; expected result: 14\n";

# TEST GET LATEST TIMESTAMP
print "-----------------------------------------------------------------\n";
print "TEST getLatestTimeStamp:\n";
print "getLatestTimeStamp (\$eventsAoH): "
. getLatestTimeStamp ($eventsAoH) 
. "; expected result: 2012-07-17 16:59:39\n";

# TEST GET EARLIEST TIMESTAMP
print "-----------------------------------------------------------------\n";
print "TEST getEarliestTimeStamp:\n";
print "getEarliestTimeStamp (\$eventsAoH): "
. getEarliestTimeStamp ($eventsAoH) 
. "; expected result: 2011-12-21 19:41:12\n";



# DECLARATIONS
my $tableType = $fileType;
my $fileLine = "1	\"2011-12-21 19:41:12\"	\"server.start\"	\"2.8.1/MAINT BRANCH\"	(null)	\"~herculesapp1~?\"	\"a\"";
$fileLine =~ s/\(|\)/\"/g;
$fileLine =~ m/([^\s|\"]*)[\s|\"]*([^|\"]*)[|\"]*([^|\"]*)[|\"]*([^|\"]*)[|\"]*([^|\"]*)[|\"]*([^|\"]*)[|\"]*([^|\"]*)[|\"]*([^|\"]*)[|\"]*([^|\"]*)[|\"]*([^|\"]*)[|\"]*([^|\"]*)[|\"]*([^|\"]*)[|\"]*/g;

#print $fileLine . "\n";

my ($eventID, $eventDate, $event, $ref, $context, $sessionID, $eventCode);
$eventID = $eventDate = $event = $ref = $context = $sessionID = $eventCode = "";
$eventID = $1;
$eventDate = $2;
$event = $4;
$ref = $6;
$context = $8;
$sessionID = $10;
$eventCode = $12;
print $eventID . "\n";
print $eventDate . "\n";
print $event . "\n";
print $ref . "\n";
print $context . "\n";
print $sessionID . "\n";
print $eventCode . "\n";

my @AoH;

push @AoH, {
    EVENT_ID => $eventID,
    EVENT_DATE => $eventDate,
    EVENT => $event,
    REF => $ref,
    CONTEXT => $context,
    SESSION_ID => $sessionID,
    EVENT_CODE => $eventCode,
};
push @AoH, {
    EVENT_ID => $eventID,
    EVENT_DATE => $eventDate,
    EVENT => $event,
    REF => $ref,
    CONTEXT => $context,
    SESSION_ID => $sessionID,
    EVENT_CODE => $eventCode,
};


for (my $i=0; $i< scalar @AoH; $i++) {
    print "row: " . $i . "\n";
    print "EVENT_ID: " . $AoH[$i]{EVENT_ID} . "\n";
    print "EVENT_DATE: " . $AoH[$i]{EVENT_DATE} . "\n";
    print "EVENT: " . $AoH[$i]{EVENT} . "\n";
    print "REF: " . $AoH[$i]{REF} . "\n";
    print "CONTEXT: " . $AoH[$i]{CONTEXT} . "\n";
    print "SESSION_ID: " . $AoH[$i]{SESSION_ID} . "\n";
    print "EVENT_CODE: " . $AoH[$i]{EVENT_CODE} . "\n";
}




	#------TEST CODE-------
	#print "secondsBeg: " . $secondsBeg . "\n";
	#print "yr1: " . $yr1 . "\n";
	#print "mo1: " . $mo1 . "\n";
	#print "dy1: " . $dy1 . "\n";
	#print "h1: " . $h1 . "\n";
	#print "m1: " . $m1 . "\n";
	#print "s1: " . $s1 . "\n";
	
	#print "secondsEnd: " . $secondsEnd . "\n";
	#print "yr2: " . $yr2 . "\n";
	#print "mo2: " . $mo2 . "\n";
	#print "dy2: " . $dy2 . "\n";
	#print "h2: " . $h2 . "\n";
	#print "m2: " . $m2 . "\n";
	#print "s2: " . $s2 . "\n";
	#exit 0;
	
			#print "$currSeconds" . $currSeconds . "\n";
		#exit 0;
		



# CALL PRINT TABLE
#print "Printing Table...\n";
#printTable ($eventsAoH, "SAKAI_EVENT", 3);
#print "[done]\n";

# TEST GET LATEST TIMESTAMP
#print "-----------------------------------------------------------------\n";
#print "TEST getLatestTimeStamp:\n";
#print "getLatestTimeStamp (\$eventsAoH): "
#. getLatestTimeStamp ($eventsAoH)
#. "; expected result: 2012-07-17 16:59:39\n";

# TEST GET EARLIEST TIMESTAMP
#print "-----------------------------------------------------------------\n";
#print "TEST getEarliestTimeStamp:\n";
#print "getEarliestTimeStamp (\$eventsAoH): "
#. getEarliestTimeStamp ($eventsAoH)
#. "; expected result: 2011-12-21 19:41:12\n";