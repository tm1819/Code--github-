# ###########################################################################
# Title:	NYU Classes Health Check
# Author:	Tom Martin
# Date:		2/25/2013
#
# This script checks the status of an NYU Classes Server, and sends an email
# message in the event of a status change.
#
# The script maintains a list of 
# ###########################################################################

# ###########################################################################
# Ruby Required Libraries
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
downMessage = "NYU Classes Health Check has discovered a change in app server availibility."                     # body text for notification email
baseServer = "http://newclasses.nyu.edu"						# the base site url
loginPath = "portal/relogin"									# the login page
userName = "****"												# the login username
password = "****"											# the login password
serverFilter = /sakaiCopyrightInfo[^<]*[^>]*>[\s]*([^\s]*)/		# regex for app server name
recipientList = [												# addresses that will receive status messages
    "******************@maildomain.com",
    "******************@maildomain.edu"
]
numAttempts = 60                                                # number of login attempts at 1 second intervals


# ---------------------------------------------------------------------------
# Name:     httpsRequest
# Desc:     Sends an HTTPS request, which requires different code from HTTP
# ---------------------------------------------------------------------------
def httpsRequest (url)
	uri = URI.parse(url)
	http = Net::HTTP.new(uri.host, uri.port)
	http.use_ssl = true
	http.verify_mode = OpenSSL::SSL::VERIFY_NONE
	request = Net::HTTP::Get.new(uri.request_uri)
	response = http.request(request)
	return response
end

# ---------------------------------------------------------------------------
# Name:     httpRequest
# Desc:     Sends an HTTP request, which requires different code from HTTPS
# ---------------------------------------------------------------------------
def httpRequest (url)
	uri = URI.parse(url)
	http = Net::HTTP.new(uri.host, uri.port)
	response = http.request(Net::HTTP::Get.new(uri.request_uri))
end

# ---------------------------------------------------------------------------
# Name:     webRequest
# Desc:     Sends a generic web request (either HTTP or HTTPS)
# ---------------------------------------------------------------------------
def webRequest (url)
	if url =~ /(https)/
		return httpsRequest(url)
	else
		return httpRequest(url)
	end
end

# ---------------------------------------------------------------------------
# Name:     autoRedirectWebRequest 
# Desc:     Submits a generic web request and automatically follows redirects.
# Returns:  A struct containing the eventual url, and an http response.
# ---------------------------------------------------------------------------
Redirect = Struct.new(:newURL, :response)
def autoRedirectWebRequest (url)
	response = webRequest(url)
	if response.code == "301" or response.code == "302" or response.code == "307"
        location = response["location"]
		return autoRedirectWebRequest(location)
	else
		redirectResponse = Redirect.new(url,response)
		return redirectResponse
	end
end

# ---------------------------------------------------------------------------
# Name:     notifyRecipients
# Desc:     Sends email notification to recipient list
#           Relies on host environment's SendMail service
# ---------------------------------------------------------------------------
def notifyRecipients (recipientList, downTitle, downMessage)
    puts "\nNotifying Recipipients."
    recipientList.length.times do |i|        
	command = "echo \"#{downMessage}\" | mail -s \"#{downTitle}\" #{recipientList[i]}"
        result = %x(#{command})
    end
end

# ###########################################################################
# Script Action
# ###########################################################################

# get array of servers we accessed last run
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
for i in 0..numAttempts
    # Print remaining time
    fI = i + 0.0
    fNumAttempts = numAttempts + 0.0
    pctComplete = fI/fNumAttempts*100.0
    print "\rSampling: " + "%0.0f" % pctComplete + "% complete."
    $stdout.flush
    
    # Simulate Login.  Notify Recipients in the event of an error
    begin
        redirectResponse = autoRedirectWebRequest(baseServer)
        redirectResponse = autoRedirectWebRequest(redirectResponse.newURL + loginPath + "&eid=" + userName + "&pw=" + password + "&submit=Login")
    rescue Exception=>e
        errMsg = "\n\nERROR: Failed to resolve url: #{baseServer}."
        puts errMsg
        notifyRecipients(recipientList, downTitle, downMessage+errMsg)
    end
    
    # Assertion for App server text.  If not found, notify recipients
    if redirectResponse.response.body =~ serverFilter
        # puts "MESSAGE: " + scriptName + ": Server '" + $1 + "' is up and running."
        # Push server to log file if it has not yet been visited in the current script ececution
        duplicateEntry = false
        currServers.each do |element|
            if element == $1
                duplicateEntry = true
            end
        end
        if not duplicateEntry
            currServers.push $1
            logFile.puts $1
        end
    else
            errMsg = "\n\nERROR: Login failed on an undetermined app server."
            puts errMsg
            notifyRecipients(recipientList, downTitle, downMessage+errMsg)
    end
    
    sleep 1
end

# Close the log file
logFile.close

# Which Servers were added?
gainedServers = currServers - prevServers

# Which Servers were lost?
lostServers = prevServers - currServers

# Notify observers of the servers which were gained and lost
if gainedServers.count > 0 or lostServers.count > 0
    errMsg = "\n\nWARNING: App Servers were gained and/or lost from the pool:\n\nGained:#{gainedServers}\nLost:#{lostServers}"
    notifyRecipients(recipientList, downTitle, downMessage+errMsg)
    
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





