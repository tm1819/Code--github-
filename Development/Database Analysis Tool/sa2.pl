#!/usr/bin/perl -w

# +***************************** SAKAI ANALYTICS 2 *************************************+
# | TITLE:		SAKAI ANALYTICS 2														|
# | AUTHOR:		TOM MARTIN																|
# | DESC:		PRODUCES A GRAPH CONTAINING USAGE GRAPHS AND ANALYTICS					|
# |				THE FOLLOWING METRICS ARE REPORTED:										|
# |					• LAST HOUR COUNTS BY TOOL IN A STACKED BAR GRAPH					|
# |					• LAST DAY COUNTS BY TOOL IN A STACKED BAR GRAPH					|
# +*************************************************************************************+
use strict;
use warnings;
use SA2LIB;

# VALIDATE COMMAND LINE INPUT
my ($fileType, $filePath);
for (my $i=0; $i < scalar @ARGV-1; $i++) {
	if (!($ARGV[$i+1] eq "-eventFile" || $ARGV[$i+1] eq "-sessionFile")) {
		if ($ARGV[$i] eq "-eventFile" || $ARGV[$i] eq "-sessionFile") {
			$fileType = $ARGV[$i];
			$filePath = $ARGV[$i+1];
			last;
		} 
	} 
}
if (!(	# FILE_TYPE MUST BE DEFINED
		($fileType eq "-eventFile" || $fileType eq "--sessionFile") 
		# FILE_PATH MUST BE DEFINED
		&& (!$filePath eq "")
		# ONLY TWO ARGUMENTS ALLOWED
		&& (scalar @ARGV == 2))) 
{
	# PRINT BOILER PLATE PLATE
	print "**************************** USAGE ******************************\n";
	print "* AUTHOR: TOM MARTIN\n";
	print "* USAGE: > perl <scriptName> <-eventFile | -sessionFile> fileName\n";
	print "*****************************************************************\n";
	print "ERROR: Command Line Args\n";
	exit 0;
}
	
# CALL READ TABLE
print "Reading Table...\n";
my $eventsAoH = readTable ($fileType, $filePath);
print "[done]\n\n";

# CALL LAST DAY STATS
print "Gathering Last Hour Stats...\n";
my @interestingEvents = (
    "annc.create",
    "pres.begin",
    "user.login",
    "user.logout",
    "realm.add",
    "realm.upd",
    "calendar.create",
    "content.available",
    "content.new",
    "site.add",
    "pres.begin",
    "pres.end",
    "profile.view.own",
    "profile.friends.view.own",
    "profile.view.other",
    "profile.friends.view.other",
    "webcontent.read",
    "roster.view",
);
graphLastHours($eventsAoH, 24, \@interestingEvents);
print "[done]\n\n";



