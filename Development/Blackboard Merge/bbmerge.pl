#!/usr/bin/perl
#use strict;

print "**************************** USAGE ******************************\n";
print "*	> perl bbmerge bbFile.txt cleTable.txt *                     \n";
print " Blackboard File should be ls command                            \n";
print " CLE Table should be a tab-delimited dump of the CLE table       \n";
print "*****************************************************************\n";
print "BlackBoard File: " . $ARGV[0] . "\n";
print "CLE Table: " . $ARGV[1] . "\n";
print "-----------------------------------------------------------------\n";

# COPY BB_FILE INTO ARRAY.
@bbLines;
open BB_FILE, "<", $ARGV[0] or die "Can't open BB file $!\n";
while (my $bbFileLine = <BB_FILE>) {
	push(@bbLines, $bbFileLine);
}
close BB_FILE;

# COPY CLE_FILE INTO ARRAY.
local $/ = "\r"; # CR, use "\r\n" for CRLF or "\n" for LF
@cleLines;
open CLE_FILE, "<:encoding(UTF-8)", $ARGV[1] or die "Can't open CLE file $!\n";
while (my $cleFileLine = <CLE_FILE>) {
	push(@cleLines, $cleFileLine);
}
close CLE_FILE;

# OPEN OUTPUT FILE FOR WRITING
open OUT_FILE, ">", "meged.txt" or die "Can't open/create output file $!\n";

# WRITE HEADING ROW TO OUT_FILE
print OUT_FILE "SIZE_GiB	TERM	COURSE_ID	COURSE_NAME	INST_NET_ID	FIRST_NAME	LAST_NAME\n";

# ADD SIZE COLUMN
for ($i=0; $i < scalar @cleLines; $i++) {
	my $matchFound = 0;
	
    my $cleCapture = "";
    my $cleCaptureFormatted = "";
    $cleLines[$i] =~ /(?m)\t([A-Z]+-[^\t]+)\t/;
    $cleCapture = $1;
    $cleCaptureFormatted = $cleCapture;
    $cleCaptureFormatted =~ s/\.|-/_/g;
    
    if (!$cleCaptureFormatted eq "") {
    	$matchFound = 0;
    	for ($j=0; ($j < scalar @bbLines) && (!$matchFound); $j++) {
    		my $bbCapture = "";
    		my $bbCaptureFormatted = "";
    		$bbLines[$j] =~ /ArchiveFile_(.*).zip/;
    		$bbCapture = $1;
    		$bbCaptureFormatted = $bbCapture;
    		$bbCaptureFormatted =~ s/\.|-/_/g;
    	
    		if (!$bbCaptureFormatted eq "") {
    			if ($bbCaptureFormatted eq $cleCaptureFormatted) {
    				# SET MATCH FOUND FLAG
    				$matchFound = 1;
    				
    				# WRITE OUT ROW WITH FILE SIZE
    				my $fileSizeCapture = "";
    				$bbLines[$j] =~ /\s+([0-9]+)\s+[^\s]+\s+[^\s]+\s+[^\s]+\s+[^\s]+.zip/;  
    				$fileSizeCapture = $1;
    				$fileSizeCaptureInGB = $fileSizeCapture/1024/1024/1024;
    				$fileSizeCaptureInGB = sprintf "%.3f", $fileSizeCaptureInGB;
    				print OUT_FILE $fileSizeCaptureInGB . "	" . $cleLines[$i];
    			}
    		} else {
    			# SUPPRESS WARNING IF THE OFFENDING LINE IS THE HEADING ROW
    			if ($j>0) {
        			print "Warning at line '" . $j . "' in file '" . $ARGV[0] . "':\n     Desc: BB text does not match regex\n";
        			print "     BB Text: '" . $bbLines[$j] . "' \n\n";
        		}
   			}
		}
		if (!$matchFound) {
			print "Warning at line '" . $i . "' in file '" . $ARGV[1] . "':\n     Desc: CLE line could not be found in BB file\n";
        	print "     CLE Line: '" . $cleLines[$i] . "' \n\n";
		}
    } else {
    	# SUPPRESS WARNING IF THE OFFENDING LINE IS THE HEADING ROW
    	if ($i>0) {
        	print "Warning at line '" . $i . "' in file '" . $ARGV[1] . "':\n     Desc: Text does not match regex\n";
        	print "     CLE Text: '" . $cleLines[$i] . "' \n\n";
        }
    }
}

# CLOSE OUTPUT FILE
close OUT_FILE;
