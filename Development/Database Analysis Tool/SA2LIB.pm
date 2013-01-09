#!/usr/bin/perl -w

# +***************************** SAKAI ANALYTICS 2 *************************************+
# | TITLE:		SAKAI ANALYTICS 2														|
# | AUTHOR:		TOM MARTIN																|
# | DESC:		PRODUCES A GRAPH CONTAINING USAGE GRAPHS AND ANALYTICS					|
# |				THE FOLLOWING METRICS ARE REPORTED:										|
# |					• LAST HOUR COUNTS BY TOOL IN A STACKED BAR GRAPH					|
# |					• LAST DAY COUNTS BY TOOL IN A STACKED BAR GRAPH					|
# +*************************************************************************************+
package SA2LIB;
use Exporter 'import';
our @EXPORT_OK = qw( stripLeadingZeros isLeapYear countLeapDays daysSinceJanuary diffYMD ymdhmsToSecondsSinceEpoch sakaiTimeToEpochTime readTable printTable countEventsOverIntervalSSE countEventsOverInterval getLatestTimeStamp getEarliestTimeStamp genColors graphLastHours);
our @EXPORT = qw( stripLeadingZeros isLeapYear countLeapDays daysSinceJanuary diffYMD ymdhmsToSecondsSinceEpoch sakaiTimeToEpochTime readTable printTable countEventsOverIntervalSSE countEventsOverInterval getLatestTimeStamp getEarliestTimeStamp genColors graphLastHours);
use lib qw( /usr/local/rrdtool-1.0.41/lib/perl ../lib/perl );
use RRDs;


# +----------------------------- stripLeadingZeros -------------------------------------+
# | DESC:		STRIPS LEADING ZEROS FROM NUMBER AS STRING								|
# | TAKES:		$iNum AS SCALAR															|
# | RETURNS:	$oNum AS SCALAR															|
# | ERROR:		DOES NOT PERFORM FORMAT CHECKING										|
# | EXAMPLE:	$sYear = stripLeadingZeros($sYear);										|	
# +-------------------------------------------------------------------------------------+
sub stripLeadingZeros {
	my ($number) = @_;
	$number =~ s/^0+//;
	return $number;
}

# +--------------------------------- isLeapYear ----------------------------------------+
# | DESC:		DETERMINES WHETHER THE SPECIFIED YEAR IS A GREGORIAN LEAP YEAR			|
# | TAKES:		COMPLETE YEAR WITHOUT LEADING ZEROS										|
# | RETURNS:	1 IF YEAR IS LEAP YEAR, 0 OTHERWISE										|
# | ERROR:		LEADING ZEROS NOT PERMITTED												|
# |				DOES NOT CHECK DATE FOR FORMAT ACCURACY (LEADING ZEROS, ETC...)			|
# | EXAMPLE:	$bool = isLeapYear(1970);												|	
# +-------------------------------------------------------------------------------------+
sub isLeapYear {
	my ($year) = @_;
	if ($year % 400 == 0) {
   		return 1;
	} elsif ($year % 100 == 0) {
   		return 0;
	} elsif ($year % 4 == 0) {
   		return 1;
	} else {
  		return 0;
  	}
}

# +------------------------------- countLeapDays ---------------------------------------+
# | DESC:		COUNTS THE LEAP DAYS BETWEEN TWO DATES									|
# |				IF A ONE OR BOTH SPECIFIED YEARS IS A LEAP DAY, THAT WILL COUNT 		|
# |				TOWARDS THE TOTAL														|
# | TAKES:		$y2, $m2, $d2, $y1, $m1, $d1 WITHOUT LEADING ZEROS						|
# | RETURNS:	NUMBER OF LEAP DAYS														|
# | ERROR:		LEADING ZEROS NOT PERMITTED												|
# |				DOES NOT CHECK THAT FIRST y2m2d2 COMES AFTER y1m2d1						|
# |				DOES NOT CHECK DATE FOR FORMAT ACCURACY (LEADING ZEROS, ETC...)			|
# |				DOES NOT CHECK DATE FOR GREGORIAN CALENDAR ACCURACY 					|
# |					EG1: 2012/56/45 (DAY AND MONTH OUT OF BOUNDS) 						|
# |					EG2: 2011/2/29 (DAY OUT OF BOUNDS B/C 2011 IS NOT A LEAP YEAR)		|
# | EXAMPLE:	$numLeapDays = countLeapDays ($"2", $"28", $"2012", "1", "1", "1970")	|
# +-------------------------------------------------------------------------------------+
sub countLeapDays {
	# DECLARATIONS
    my ( $y2, $m2, $d2, $y1, $m1, $d1 ) = @_;
    my $numLeapDays;

    # COUNT LEAP DAYS
    # CONSIDER ALL YEARS INSIDE THE YEAR RANGE
    my ( $startYear, $endYear );
    
    # ONLY CONSIDER Y2 IF IT INCLUDES THE WOULD-BE LEAP DAY
    if ($m2 > 2) {
    	$endYear = $y2;
    } elsif ( ($m2 == 2) && ($d2 > 28) ) {
    	$endYear = $y2;
    } else {
    	$endYear = $y2-1;
    }
    
    # ONLY CONSIDER Y1 IF IT INCLUDES THE WOULD-BE LEAP DAY
    if ($m1 < 3) {
    	$startYear = $y1;
    } else {
    	$startYear = $y1+1;
    } 
    
    # IF THE BOUNDARY YEARS ARE THE ONLY YEARS BEING CONSIDERED, 
    # AND NEITHER INCLUDES POSSIBLE LEAP DAYS, THEN REPORT 0 LEAP DAYS
    if ($startYear > $endYear) {
    	return 0;
    }
    
    # COUNT THE LEAP DAYS FOR THE GIVEN YEARS, CONSIDERING BOUNDARY DAYS AS DETERMINED ABOVE
    my $leapDayCount = 0;
    for (my $i=$startYear; $i<=$endYear; $i++) {
    	if (isLeapYear($i)) {
    		$leapDayCount++;
    	}
    }
    return $leapDayCount;
}

# +------------------------------ daysSinceJanuary -------------------------------------+
# | DESC:		COUNTS THE NUMBER OF DAYS SINCE JANUARY									|
# | 			ASSUMES 28 DAYS FOR FEBRUARY											|
# | TAKES:		$month, $day, WITHOUT LEADING ZEROS										|
# | RETURNS:	NUMBER OF DAYS SINCE JANUARY											|
# | ERROR:		LEADING ZEROS NOT PERMITTED												|
# |				DOES NOT CHECK THAT FIRST y2m2d2 COMES AFTER y1m2d1						|
# |				DOES NOT CHECK DATE FOR FORMAT ACCURACY (LEADING ZEROS, ETC...)			|
# |				DOES NOT CHECK DATE FOR GREGORIAN CALENDAR ACCURACY 					|
# |					EG1: 56/45 (DAY AND MONTH OUT OF BOUNDS) 							|
# | EXAMPLE:	$numDays = daysSinceJanuary (28, 2);									|
# +-------------------------------------------------------------------------------------+
sub daysSinceJanuary {
	# DECLARATIONS
	my ( $month, $day ) = @_; 
	
	my $numDays = $day;
	if ($month>=1) {
		#JANUARY
		$numDays += 31;
	} 
	if ($month>=2) {
		#FEBRUARY
		$numDays += 28;
	} 
	if ($month>=3) {
		#MARCH
		$numDays += 31;
	} 
	if ($month>=4) {
		#APRIL
		$numDays += 30;
	} 
	if ($month>=5) {
		#MAY
		$numDays += 31;
	} 
	if ($month>=6) {
		#JUNE
		$numDays += 30;
	} 
	if ($month>=7) {
		#JULY
		$numDays += 31;
	} 
	if ($month>=8) {
		#AUGUST
		$numDays += 31;
	} 
	if ($month>=9) {
		#SEPTEMBER
		$numDays += 30;
	} 
	if ($month>=10) {
		#OCTOBER
		$numDays += 31;
	} 
	if ($month>=11) {
		#NOVEMBER
		$numDays += 30;
	} 
	if ($month>=12) {
		#DECEMBER
		$numDays += 31;
	}
	return $numDays;
}

# +---------------------------------- diffYMD ------------------------------------------+
# | DESC:		FINDS DIFFERENCE BETWEEN TWO DATES IN YMD FORMAT						|
# |				DOES NOT INCLUDE THE END DATE											|
# | TAKES:		$y2, $m2, $d2, $y1, $m1, $d1 WITHOUT LEADING ZEROS						|
# | RETURNS:	$numDays																|
# | ERROR:		LEADING ZEROS NOT PERMITTED												|
# |				DOES NOT CHECK THAT FIRST y2m2d2 COMES AFTER y1m2d1						|
# |				DOES NOT CHECK DATE FOR FORMAT ACCURACY (LEADING ZEROS, ETC...)			|
# |				DOES NOT CHECK DATE FOR GREGORIAN CALENDAR ACCURACY 					|
# |					EG1: 2012/56/45 (DAY AND MONTH OUT OF BOUNDS) 						|
# |					EG2: 2011/2/29 (DAY OUT OF BOUNDS B/C 2011 IS NOT A LEAP YEAR)		|
# | EXAMPLE:	my ($dYear, $dMonth, $dDay) = 											|
# |				diffYMD ($sYear, $sMonth, $sDay, "1", "1", "1970");						|		
# +-------------------------------------------------------------------------------------+
sub diffYMD {
	# DECLARATIONS
    my ( $y2, $m2, $d2, $y1, $m1, $d1 ) = @_;
    my $numDays;
    
    # CALCULATE THE NUMBER OF LEAP DAYS (EXCLUDING CURRENT DAY IF IT HAPPENS TO BE A LEAP DAY)
    $numDays = countLeapDays($y2, $m2, $d2, $y1, $m1, $d1);
    
    # ADD YEARS
    $numDays += 365 * ( $y2 - $y1 );
    
    # CALCULATE DAYS SINCE JANUARY FOR DATE2 AND DATE1
    # ASSUME 28 DAYS FOR FEBRUARY, SINCE LEAP DAYS WERE CALCULATED ABOVE 
    # AND ADD THE DIFFERENCE TO THE TOTAL NUMBER OF DAYS
    $numDays += daysSinceJanuary($m2,$d2) - daysSinceJanuary($m1,$d1);
    
    return $numDays;
}

# +------------------------- ymdhmsToSecondsSinceEpoch ---------------------------------+
# | DESC:		CONVERTS YMDHMS TIMESTAMP TO SECONDS SINCE EPOCH						|
# | TAKES:		SSKAI_DATE AS STRING IN FORMAT: YMD-HMS-TENTH_OF_SECOND					|
# | RETURNS:	TIME SINCE EPOCH, WHICH IS DEFINED AS 01-01-1970						|
# | ERROR:		LEADING ZEROS NOT PERMITTED												|
# |				DOES NOT CHECK THAT FIRST y2m2d2 COMES AFTER y1m2d1						|
# |				DOES NOT CHECK DATE FOR FORMAT ACCURACY (LEADING ZEROS, ETC...)			|
# |				DOES NOT CHECK DATE FOR GREGORIAN CALENDAR ACCURACY 					|
# |					EG1: 2012/56/45 (DAY AND MONTH OUT OF BOUNDS) 						|
# |					EG2: 2011/2/29 (DAY OUT OF BOUNDS B/C 2011 IS NOT A LEAP YEAR)		|
# | EXAMPLE:	ex. 2012-12-01 14:43:28.0												|
# +-------------------------------------------------------------------------------------+
sub ymdhmsToSecondsSinceEpoch {
	# DECLARATIONS AND FORCE NUMERIC CONTEXT
	my ( $sYear, $sMonth, $sDay, $sHours, $sMinutes, $sSeconds) = @_;
	
    # STRIP LEADING ZEROS AND FORCE RESULT IN NUMERIC CONTEXT IF RESULT SHOULD BE 0
    $sYear = stripLeadingZeros($sYear);
    $sMonth = stripLeadingZeros($sMonth);
    $sDay = stripLeadingZeros($sDay);
    $sHours = stripLeadingZeros($sHours);
    $sMinutes = stripLeadingZeros($sMinutes);
    $sSeconds = stripLeadingZeros($sSeconds);
    if ($sYear eq "") {
		$sYear = 0;
	} 
	if ($sMonth eq "") {
		$sMonth = 0;
	} 
	if ($sDay eq "") {
		$sDay = 0;
	} 
	if ($sHours eq "") {
		$sHours = 0;
	} 
	if ($sMinutes eq "") {
		$sMinutes = 0;
	} 
	if ($sSeconds eq "") {
		$sSeconds = 0;
	}
    
    # DETERMINE DAYS SINCE EPOCH
    my $daysSinceEpoch = diffYMD ($sYear, $sMonth, $sDay, 1970, 1, 1);
    
    # CONVERT DAYS TO SECONDS
    my $secondsSinceEpoch = $daysSinceEpoch * 24*60*60;
    
    # ADD SECONDS FOR CURRENT DAY HMS
    $secondsSinceEpoch += $sHours*60*60 + $sMinutes*60 + $sSeconds;
    
    return $secondsSinceEpoch;
}

# +--------------------------- sakaiTimeToEpochTime ------------------------------------+
# | DESC:		CONVERTS SAKAI TIMESTAMP TO TIME SINCE EPOCH							|
# | TAKES:		SSKAI_DATE AS STRING IN FORMAT: YMD-HMS-TENTH_OF_SECOND					|
# | RETURNS:	TIME SINCE EPOCH, WHICH IS DEFINED AS 01-01-1970						|
# | ERROR:		LEADING ZEROS NOT PERMITTED												|
# |				DOES NOT CHECK THAT FIRST y2m2d2 COMES AFTER y1m2d1						|
# |				DOES NOT CHECK DATE FOR FORMAT ACCURACY (LEADING ZEROS, ETC...)			|
# |				DOES NOT CHECK DATE FOR GREGORIAN CALENDAR ACCURACY 					|
# |					EG1: 2012/56/45 (DAY AND MONTH OUT OF BOUNDS) 						|
# |					EG2: 2011/2/29 (DAY OUT OF BOUNDS B/C 2011 IS NOT A LEAP YEAR)		|
# | EXAMPLE:	ex. 2012-12-01 14:43:28.0												|
# +-------------------------------------------------------------------------------------+
sub sakaiTimeToEpochTime {
	# DECLARATIONS
	my ( $time ) = @_;
	my ( $sYear, $sMonth, $sDay, $sHours, $sMinutes, $sSeconds );
    
    # TOKENIZE TIMESTAMP
    $time =~ /([0-9]*)[^0-9]*([0-9]*)[^0-9]*([0-9]*)[^0-9]+([0-9]*)[^0-9]*([0-9]*)[^0-9]*([0-9]*)/;
    $sYear = $1;
    $sMonth = $2;
    $sDay = $3;
    $sHours = $4;
    $sMinutes = $5;
    $sSeconds = $6;
    
    # CALL secondsSinceEpoch
    return ymdhmsToSecondsSinceEpoch ($sYear, $sMonth, $sDay, $sHours, $sMinutes, $sSeconds);
}

# +--------------------------------- readTable -----------------------------------------+
# | DESC:		READS A SAKAI EVENTS TABLE DUMP INTO AN ARRAY OF HASHES					|
# | 			TABLE DATA ASSUMED TO BE IN CSV FORMAT									|
# | TAKES:		TYPE OF TABLE CONTAINED IN FILE (AS SCALAR).  SUPPORTED TYPES ARE:		|
# |					• SAKAI_EVENT														|
# |					• SAKAI_SESSION														|
# |				PATH TO EVENTS FILE SPECIFIED ON THE COMMAND LINE						|
# |					EG: <user>$ perl <scriptName>.pl -eventFile sakaiEvents.csv			|
# | RETURNS:	SAKAI_EVENTS TABLE AS A REFERENCE TO AN ARRAY OF HASHES 				|
# | ERROR:		REPORTS FAILURE IF FILE CANNOT BE OPENED. DOES NOT INVESTIGATE FURTHER	|
# |				REPORTS FAILURE IF THE TABLE TYPE ARGUMENT IS INVALID					|
# |				NO OTHER ERRORS ARE HANDLED.  THIS INCLUDES:							|
# |					• FILE NOT FOUND - NOT HANDLED OR REPORTED							|
# |					• FILE IS IN WRONG FORMAT - NOT HANDLED OR REPORTED					|
# |					• FILE IS IN USE BY ANOTHER APPLICATION	- NOT HANDLED OR REPORTED	|
# +-------------------------------------------------------------------------------------+
sub readTable {
	# DECLARATIONS
	my ( $tableType, $filePath ) = @_;
	my $fileLine;
	my ($eventID, $eventDate, $event, $ref, $context, $sessionID, $eventCode);
	my @AoH;
	
	# COPY EVENT FILE INTO ARRAY OF HASHES
	open FILE_HANDLE, "<", $filePath or die "ERROR:readTable: Can't open file $!<br>";
	my $i = 0;
	while (my $fileLine = <FILE_HANDLE>) {
		# CONVERT CELLS WITH (null) ENTRIES TO "null"
		$fileLine =~ s/\(|\)/\"/g;
		
		# TOKENIZE LINE VALUES
		$fileLine =~ m/([^\s|\"]*)[\s|\"]*([^|\"]*)[|\"]*([^|\"]*)[|\"]*([^|\"]*)[|\"]*([^|\"]*)[|\"]*([^|\"]*)[|\"]*([^|\"]*)[|\"]*([^|\"]*)[|\"]*([^|\"]*)[|\"]*([^|\"]*)[|\"]*([^|\"]*)[|\"]*([^|\"]*)[|\"]*/g;
		$eventID = $eventDate = $event = $ref = $context = $sessionID = $eventCode = "";
		$eventID = $1;
		$eventDate = $2;
		$event = $4;
		$ref = $6;
		$context = $8;
		$sessionID = $10;
		$eventCode = $12;
		
		# PUSH A NEW HASH CONTAINING THE TOKENIZED LINE VALUES ONTO THE ARRAY
		# SKIP THE HEADING ROW, WHICH WE DETECT BY MULTIPLE FIELDS FAILING TO MATCH THE REGEX
		if (($eventID eq "") || ($eventDate eq "") || ($event eq "") || ($ref eq "")
		|| ($context eq "") || ($sessionID eq "") || ($eventCode eq "") ) {
			print "WARNING:readTable: Could not read line '" . $i . "'";
			if ($i==0) {
				print " (if row 0 is the heading row, ignore this warning)";
			} 
			print "<br>";
		} else {
			push @AoH, {
    			EVENT_ID => $eventID,
    			EVENT_DATE => $eventDate,
    			EVENT => $event,
   				REF => $ref,
    			CONTEXT => $context,
    			SESSION_ID => $sessionID,
    			EVENT_CODE => $eventCode,
                TIME_SINCE_EPOCH => sakaiTimeToEpochTime($eventDate),
			};
		}
		$i++;
	}
	close FILE_HANDLE;
	
	# RETURN REFERENCE TO ARRAY OF HASHES
	return \@AoH;
}

# +--------------------------------- printTable ----------------------------------------+
# | DESC:		PRINTS THE TABLE READ BY readTable (USEFUL FOR DEBUGGING)				|
# | TAKES:		• SAKAI_EVENT OR SAKAI_SESSION TABLE AS REFERENCE TO AN ARRAY OF HASHES	|
# |				• TYPE OF TABLE SPECIFIED (EITHER SAKAI_EVENT OR SAKAI_SESSION)			|
# |				• NUMBER OF ROWS TO PRINT (FIRST N ROWS OF THE TABLE)					|
# | RETURNS:	NOTHING 																|
# | ERROR:		NO ERROR HANDLING														|
# +-------------------------------------------------------------------------------------+
sub printTable {
	# DECLARATIONS
	my ( $AoH, $tableType, $numLinesToPrint ) = @_;
	
	# CLAMP NUM_LINES
	if ($numLinesToPrint > scalar @$AoH) {
		$numLinesToPrint = scalar @$AoH;
	}
	
	# PRINT THE EVENTS TABLE
	if ($tableType eq "SAKAI_EVENT") {
		for (my $i=0; $i< $numLinesToPrint; $i++) {
    		print "row: " . $i . "<br>";
    		print "EVENT_ID: " . $$AoH[$i]{EVENT_ID} . "<br>";
   			print "EVENT_DATE: " . $$AoH[$i]{EVENT_DATE} . "<br>";
    		print "EVENT: " . $$AoH[$i]{EVENT} . "<br>";
    		print "REF: " . $$AoH[$i]{REF} . "<br>";
    		print "CONTEXT: " . $$AoH[$i]{CONTEXT} . "<br>";
    		print "SESSION_ID: " . $$AoH[$i]{SESSION_ID} . "<br>";
    		print "EVENT_CODE: " . $$AoH[$i]{EVENT_CODE} . "<br>";
            print "TIME_SINCE_EPOCH: " . $$AoH[$i]{TIME_SINCE_EPOCH} . "<br><br>";
		}
	} elsif ($tableType eq "SAKAI_SESSION") {
		print "WARNING:printTable: SAKAI_SESSION type not implemented<br>";
	} else {
		print "WARNING:printTable: Table type not supported<br>";
	}
}

# +-------------------------- countEventsOverIntervalSSE -------------------------------+
# | DESC:		COUNTS THE SPECIFIED EVENT OVER THE SPECIFIED TIME INTERVAL				|
# | TAKES:		• SAKAI_EVENTS TABLE AS A REFERENCE TO AN ARRAY OF HASHES 				|
# |				• NAME OF THE EVENT WHICH IS TO BE COUNTED								|
# |				• TIME INTERVAL IN SECONDS-SINCE-EPOCH FORMAT                           |
# | RETURNS:	ARRAY OF HASHES, SUCH THAT:												|
# |					• 24 HOURLY ARRAY INDICES POINTING TO HASH DATA						|
# | 				• EACH HOURLY HASH CONTAINS "EVENT" AND "COUNT" DATA				|
# | ERROR:		DOES NOT CHECK THAT FIRST y2m2d2 COMES AFTER y1m2d1						|
# |				DOES NOT CHECK DATE FOR GREGORIAN CALENDAR ACCURACY 					|
# |					EG1: 2012/56/45 (DAY AND MONTH OUT OF BOUNDS) 						|
# |					EG2: 2011/2/29 (DAY OUT OF BOUNDS B/C 2011 IS NOT A LEAP YEAR)		|
# +-------------------------------------------------------------------------------------+
sub countEventsOverIntervalSSE {
	# DECLARATIONS
	my ($AoH, $eventName, $secondsBeg, $secondsEnd) = @_;
	my $currSeconds = 0;
	my $currEventName = "";
	my $count = 0;
	
	# STEP THROUGH TABLE
	for (my $i=0; $i< scalar @$AoH; $i++) {
		# EXTRACT EVENT TYPE FROM CURRENT ROW
		$currEventName = $$AoH[$i]{EVENT};
        
		# EXTRACT EVENT TIMESTAMP FROM CURRENT ROW (FORCE NUMERIC CONTEXT)
		# $currSeconds = sakaiTimeToEpochTime($$AoH[$i]{EVENT_DATE});
        $currSeconds = $$AoH[$i]{TIME_SINCE_EPOCH};
		
		# UPDATE COUNT IF CRITERIA MET
		if (($currEventName eq $eventName) && ($currSeconds > $secondsBeg) && ($currSeconds < $secondsEnd)) {
			$count++;
		}
	}
	return $count;
}

# +--------------------------- countEventsOverInterval ---------------------------------+
# | DESC:		COUNTS THE SPECIFIED EVENT OVER THE SPECIFIED TIME INTERVAL				|
# | TAKES:		• SAKAI_EVENTS TABLE AS A REFERENCE TO AN ARRAY OF HASHES 				|
# |				• NAME OF THE EVENT WHICH IS TO BE COUNTED								|
# |				• TIME INTERVAL IN YMDHMS FORMAT										|
# |					(I.E. $y1,$m1,$d1,$h1,$m1,$s1,$y2,$m2,$d2,$h2,$m2,$s2)				|
# | RETURNS:	ARRAY OF HASHES, SUCH THAT:												|
# |					• 24 HOURLY ARRAY INDICES POINTING TO HASH DATA						|
# | 				• EACH HOURLY HASH CONTAINS "EVENT" AND "COUNT" DATA				|
# | ERROR:		DOES NOT CHECK THAT FIRST y2m2d2 COMES AFTER y1m2d1						|
# |				DOES NOT CHECK DATE FOR GREGORIAN CALENDAR ACCURACY 					|
# |					EG1: 2012/56/45 (DAY AND MONTH OUT OF BOUNDS) 						|
# |					EG2: 2011/2/29 (DAY OUT OF BOUNDS B/C 2011 IS NOT A LEAP YEAR)		|
# +-------------------------------------------------------------------------------------+
sub countEventsOverInterval {
	# DECLARATIONS
	my ($AoH, $eventName, $yr1, $mo1, $dy1, $h1, $m1, $s1, $yr2, $mo2, $dy2, $h2, $m2, $s2) = @_;
    
    # DEBUG COUNT
    #print "<br>BEG DEBUG-------><br>";
    #print "startDate:   " . "" . $yr1 . "-" . $mo1 . "-" . $dy1 . ", " . $h1 . ":" . $m1 . ":" . $s1 . "<br>";
    #print "endDate:     " . "" . $yr2 . "-" . $mo2 . "-" . $dy2 . ", " . $h2 . ":" . $m2 . ":" . $s2 . "<br>";
    #print "<-------END DEBUG<br><br>";
	
	# CONVERT DATE/TIMES TO SECONDS SINCE EPOCH FOR EASIER COMPARISON
	$secondsBeg = ymdhmsToSecondsSinceEpoch($yr1,$mo1,$dy1,$h1,$m1,$s1);
	$secondsEnd = ymdhmsToSecondsSinceEpoch($yr2,$mo2,$dy2,$h2,$m2,$s2);
    
    # CALL COUNT EVENTS OVER INTERVAL SSE
    return countEventsOverIntervalSSE ($AoH, $eventName, $secondsBeg, $secondsEnd);
}

# +---------------------------- getLatestTimeStamp -------------------------------------+
# | DESC:		GETS THE LATEST TIMESTAMP FROM THE SPECIFIED EVENTS TABLE				|
# | TAKES:		EVENTS TABLE AS HASH ARRAY												|
# | RETURNS:	LARGEST VALUE FOR SECONDS SINCE EPOCH									|
# | ERROR: 		NO ERROR HANDLING														|
# +-------------------------------------------------------------------------------------+
sub getLatestTimeStamp {
	my ($AoH) = @_;
	my ($currSeconds, $maxSeconds, $maxTSF);
	$currSeconds = $maxSeconds = 0;
	$maxTSF = "";
	
	# STEP THROUGH TABLE
	for (my $i=0; $i< scalar @$AoH; $i++) {
		$currSeconds = $$AoH[$i]{TIME_SINCE_EPOCH};
		if ($currSeconds > $maxSeconds) {
			$maxSeconds = $currSeconds;
			$maxTSF = $$AoH[$i]{EVENT_DATE};
		}
	}
	
	#return $maxSeconds;
	return $maxTSF;
}

# +---------------------------- getEarliestTimeStamp -----------------------------------+
# | DESC:		GETS THE EARLIEST TIMESTAMP FROM THE SPECIFIED EVENTS TABLE				|
# | TAKES:		EVENTS TABLE AS HASH ARRAY												|
# | RETURNS:	SMALLEST VALUE FOR SECONDS SINCE EPOCH									|
# | ERROR: 		NO ERROR HANDLING														|
# +-------------------------------------------------------------------------------------+
sub getEarliestTimeStamp {
	my ($AoH) = @_;
	my ($currSeconds, $minSeconds);
	$currSeconds = 0;
	$minSeconds = -1;
	$minTSF = "";
	
	# STEP THROUGH TABLE
	for (my $i=0; $i< scalar @$AoH; $i++) {
		$currSeconds = $$AoH[$i]{TIME_SINCE_EPOCH};
		if (($minSeconds == -1) && ($currSeconds > 0)) {
			$minSeconds = $currSeconds;
			$minTSF = $$AoH[$i]{EVENT_DATE};
		}
		if ($currSeconds < $minSeconds) {
			$minSeconds = $currSeconds;
			$minTSF = $$AoH[$i]{EVENT_DATE};
		}
	}
	
	#return $minSeconds;
	return $minTSF;
}

# +---------------------------------- genColors ----------------------------------------+
# | DESC:		COLOR INDEX FOR GRAPH                                                   |
# | TAKES:		INDEX                                                                   |
# | RETURNS:	COLOR IN FORMAT #RRGGBB (AS HEX)                                        |
# | ERROR: 		NO ERROR HANDLING														|
# +-------------------------------------------------------------------------------------+
sub genColors {
    my ($index) = @_;
    
    if ($index == 0) { $hexval="#DC143C"; }
    if ($index == 1) { $hexval="#F5DEB3"; }
    if ($index == 2) { $hexval="#B8860B"; }
    if ($index == 3) { $hexval="#B22222"; }
    if ($index == 4) { $hexval="#FF7F50"; }
    if ($index == 5) { $hexval="#FFA500"; }
    if ($index == 6) { $hexval="#FAFAD2"; }
    if ($index == 7) { $hexval="#EEE8AA"; }
    if ($index == 8) { $hexval="#FF00FF"; }
    if ($index == 9) { $hexval="#8A2BE2"; }
    if ($index == 10) { $hexval="#4B0082"; }
    if ($index == 11) { $hexval="#ADFF2F"; }
    if ($index == 12) { $hexval="#00FA9A"; }
    if ($index == 13) { $hexval="#228B22"; }
    if ($index == 14) { $hexval="#808000"; }
    if ($index == 15) { $hexval="#008B8B"; }
    if ($index == 16) { $hexval="#40E0D0"; }
    if ($index == 17) { $hexval="#B0C4DE"; }
    if ($index == 18) { $hexval="#00BFFF"; }
    if ($index == 19) { $hexval="#0000CD"; }
    if ($index == 20) { $hexval="#D3D3D3"; }
    if ($index == 21) { $hexval="#808080"; }
    if ($index == 22) { $hexval="#FFE4C4"; }
    if ($index == 23) { $hexval="#BDB76B"; }
    if ($index == 24) { $hexval="#A0522D"; }
    if ($index == 25) { $hexval="#800000"; }
    if ($index == 26) { $hexval="#FF4500"; }
    if ($index == 27) { $hexval="#FFFFE0"; }
    if ($index == 28) { $hexval="#FFE4B5"; }
    if ($index == 29) { $hexval="#D8BFD8"; }
    if ($index == 30) { $hexval="#BA55D3"; }
    
    return $hexval;
}

# +------------------------------ graphLastHours ---------------------------------------+
# | DESC:		BREAKDOWN OF EVENTS FOR THE LAST COMPLETE DAY							|
# | 			PRODUCES DATA IN A 2D TABLE												|
# |					• DATA TABLE CAN BE PRINTED VIA PRINT FORMATTER						|
# |					• DATA TABLE CAN BE GRAPHED AS A STACKED BAR GRAPH					|
# | TAKES:		ARRAY OF BREAKDOWNS OVER A SPECIFIED TIME INTERVAL						|
# | RETURNS:	ARRAY OF HASHES, SUCH THAT:												|
# |					• 24 HOURLY ARRAY INDICES POINTING TO HASH DATA						|
# | 				• EACH HOURLY HASH CONTAINS "EVENT" AND "COUNT" DATA				|
# +-------------------------------------------------------------------------------------+
sub graphLastHours {
	# DECLARATIONS
	my ($AoH, $xHours, $eventsList) = @_;
	my ( $endYear, $endMonth, $endDay, $endHours, $endMinutes, $endSeconds );
	my ( $siteUpdCount, $realmUpdCount, $serverStartCount, $realmDelCount, $contentDeleteCount, $contentAvailableCount, $realmAddCount, $contentReviseCount );
	$siteUpdCount = $realmUpdCount = $serverStartCount = $realmDelCount = $contentDeleteCount = $contentAvailableCount = $realmAddCount = $contentReviseCount = 0;
    
    # TIME QUANTIFIERS
    my $oneDay = 86400;
    my $oneHour = 3600;
    my $halfHour = 1800;
    my $quarterHour = 900;
    my $oneMinute = 60;
    
    # DEFINITIONS OF TIME WINDOW
	my $startTime = sakaiTimeToEpochTime(getEarliestTimeStamp($AoH));
	my $endTime = sakaiTimeToEpochTime(getLatestTimeStamp($AoH));
    $endTime = $endTime-($endTime % $oneHour); # MAKE SURE END TIME IS ON AN EXACT HOUR BOUNDARY
    $startTime = $endTime-$oneHour*$xHours;
    
    # ERROR CHECKING - MAKE SURE THAT AT LEAST ONE FULL DAY'S WORTH OF DATA EXISTS
	if (abs($endTime - $startTime) < $xHours) {
		print "WARNING:graphLastHours: Function requires at least one full " . $xHours . " hour's worth of data.  Skipping...<br>";
		return;
	}
    
    # USE RRDTOOL TO GENERATE GRAPH OF DATA
    my @dataSources;
    for (my $i=0; $i < scalar @$eventsList; $i++) {
        $dataSources[$i] = "DS:" . "ds" . $i . ":GAUGE:" . $oneHour . ":0:U";
    }
    
    RRDs::create (
        "sa2.rrd",
        "--start", $startTime,
        "--step", 1,
        @dataSources,
        "RRA:AVERAGE:0.5:1:" . $oneHour*$xHours,
    );
    my $ERR=RRDs::error;
    die "ERROR:graphLastHours:RRD:create: $ERR<br>" if $ERR;
    
    # CREATE ARRAY OF KEY VALUE PAIRS
    
    my @rosterViewCounts; $rosterViewCounts[$xHours] = 0;
    my @presEndCounts; $presEndCounts[$xHours] = 0;
    
    # ADD DATA TO DATABASE
    for (my $i=0; $i<$xHours; $i++) {
        my $countString = "";
        for (my $j=0; $j < scalar @$eventsList; $j++) {
            my $currEventName = $eventsList->[$j];
            my $currEventCount = countEventsOverIntervalSSE ($AoH, $currEventName, $startTime+$i*$oneHour, $startTime+$i*$oneHour+$oneHour);
            if ($currEventCount eq "") {
                $currEventCount = "0";
            }
            $countString = $countString . ":" . $currEventCount;
        }
        RRDs::update ("sa2.rrd", $startTime+$i*$oneHour . $countString);
        RRDs::update ("sa2.rrd", $startTime+$i*$oneHour+$oneHour  . $countString);
    }
    
    # GENERATE GRAPH
    my @defs;
    for (my $i=0; $i < scalar @$eventsList; $i++) {
        $defs[$i] = "DEF:" . "lb" . $i . "=sa2.rrd:" . "ds" . $i . ":AVERAGE";
    }
    
    my @drawings;
    for (my $i=0; $i < scalar @$eventsList; $i++) {
        $drawings[$i] = "AREA:" . "lb" . $i . "" . genColors($i) . ":" . $eventsList->[$i] . ":STACK";
    }
    
    RRDs::graph(
        "LastHours.png",
        "--start", "end-". $xHours ." hours",
        "--end", $endTime,
        "--imgformat", "PNG", "--width", "800", "--height", "300",
        "--title", "Last ". $xHours ." Hours",
        "--vertical-label", "Count",
        @defs,
        @drawings
    );
    
    $ERR=RRDs::error;
    die "ERROR:graphLastHours:RRD:graph: $ERR<br>" if $ERR;
}





