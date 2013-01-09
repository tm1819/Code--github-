#!/usr/bin/perl -w

#=========================================================================
# MODULES
use strict;
use warnings;
use CGI;
use CGI::Carp 'fatalsToBrowser', 'croak';
use lib qw( /usr/local/rrdtool-1.0.41/lib/perl ../lib/perl /opt/local/lib/perl5/vendor_perl/5.12.4/);
use RRDs;
use SA2LIB;
use Scalar::Util qw(looks_like_number);

#=========================================================================
# VARIABLES
my ($query,       # CGI query object
	$maxFields,   # maximum number of fields to accept
	@params,      # array of all fields sent
	$key,$val,    # key an value for $fileinfo hash
	);
$query=CGI->new;	# get CGI object
$maxFields=100;		# maximum number of fields to accept

#=========================================================================
# PRINT HEADER
print $query->header;

#=========================================================================
# GET PARAMETERS
@params = $query->param;
if (@params > $maxFields)
	{croak "ERROR: Number of fields has exceeded $maxFields<br>"}
	
#=========================================================================
# PRINT KEYS
my $lastHours = 0;
foreach my $paramKey (@params) {
	#print $paramKey . ":" . $query->param($paramKey) . "<br>";
	if ($paramKey eq "lastHours") {
		if (looks_like_number($query->param($paramKey))) {
			$lastHours = $query->param($paramKey);
		}
	}
}

# VALIDATE COMMAND LINE INPUT
my ($fileType, $filePath);
$fileType = "-eventFile";
$filePath = "SAKAI_EVENT_1DAY.csv";

# CALL READ TABLE
#print "Reading Table...<br>";
my $eventsAoH = readTable ($fileType, $filePath);
#print "[done]<br><br>";

# CALL LAST DAY STATS
#print "Gathering Last Hour Stats...<br>";
my @interestingEvents = (
    "annc.create",
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
graphLastHours($eventsAoH, $lastHours, \@interestingEvents);
#print "[done]<br><br>";

#=========================================================================
# UPDATE AND RELOAD THE PAGE
open FILE_HANDLE, "<", "sa2.html" or die "ERROR:readTable: Can't open file $!<br>";
my $i = 0;
while (my $fileLine = <FILE_HANDLE>) {
	print $fileLine;
}
