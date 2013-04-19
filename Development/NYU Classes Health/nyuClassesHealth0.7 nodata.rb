# ###########################################################################
# Title:	NYU Classes Health Check
# Author:	Tom Martin
# Date:		4/19/2013
#
# This script checks the status of a list of NYU Classes Servers, and sends an email
# message in the event of a status change.
# ###########################################################################
require 'net/http'
require 'net/https'
require 'net/smtp'
require 'open-uri'
require 'uri'
require 'time'

# ###########################################################################
# Script Parameters
# ###########################################################################
scriptName = "nyuClassesHealth"                                 # the name of the script
downTitle = "NYU Classes Availability Alert"                    # title for notification email
                                                                # body text for notification email
downMessage = "NYU Classes Health Check has discovered a change in app server availibility."
port = "<port>"                                                 # the port number
protocol = "http"                                               # the protocol
appServerList = [                                               # list of app servers to test
    "<appserver1>.<domain>",
    "<appserver2>.<domain>",
    "<appserver1>.<domain>"
]
loginPath = "portal/relogin"									# the login page
userName = "<username>"											# the login username
password = "<password>"                                         # the login password
serverFilter = /sakaiCopyrightInfo[^<]*[^>]*>[\s]*([^\s]*)/		# regex for app server name
recipientList = [												# addresses that will receive status messages
    "<email1>@<domain>",
    "<email2>@<domain>",
    "<email3>@<domain>"
]

# ###########################################################################
# Script Action
# ###########################################################################

# get array of servers we reached last run
# if the file does not exist, assume it is empty
# it will get created in the next step
prevServers = []
begin
	logFile = File.open("#{scriptName}.log", 'r')
	logFile.each do |line|
	    prevServers.push line.chop
	end
	logFile.close
rescue Exception=>e
end

# Open log file in read/write mode
logFile = File.open("#{scriptName}.log", 'w')

# get array of servers we can access on this run
currServers = []
appServerList.each { |appServer|    
    # Simulate Login.  Notify Recipients in the event of an error
    command = "curl -s \"#{protocol}://#{appServer}:#{port}/#{loginPath}&eid=#{userName}&pw=#{password}&submit=Login\""
    result = %x(#{command})
    
    # Assertion for App server text.
    # Only record the server name if the login is successful
    if result =~ serverFilter
        currServers.push $1
        logFile.puts $1
    end
}

# Close the log file
logFile.close

# Which Servers were added and lost
gainedServers = currServers - prevServers
lostServers = prevServers - currServers

# Notify observers of the servers which were gained and lost
if gainedServers.count > 0 or lostServers.count > 0
    errMsg = "\n\nWARNING: App Servers were gained and/or lost from the pool:\n\nGained:#{gainedServers}\nLost:#{lostServers}"
    
    # send email notification to observers
    puts "\nNotifying Recipipients of #{downMessage+errMsg}\n"
    recipientList.length.times do |i|
        command = "echo \"#{downMessage+errMsg}\" | mail -s \"#{downTitle}\" #{recipientList[i]}"
        result = %x(#{command})
    end
    
    # Print Sample Results
    puts "\nGained Servers:"
    gainedServers.each do |gained|
        puts gained
    end
    
    puts "\nLost Servers:"
    lostServers.each do |lost|
        puts lost
    end
else
    puts "\nServer accessibility is the same as last time."
end

