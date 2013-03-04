# ###########################################################################
# Title:	NYU Classes Health Check
# Author:	Tom Martin
# Date:		2/25/2013
#
# This script checks the status of an NYU Classes Server, and sends an email
# message in the event of a status change.
# ###########################################################################

# ###########################################################################
# Ruby Required Libraries
# ###########################################################################
require 'net/http'
require 'net/https'
require 'net/smtp'
require 'open-uri'
require 'uri'

# ###########################################################################
# Script Parameters
# ###########################################################################
scriptName = "NYU Classes Health Check"                         # the name of the script
downTitle = "NYU Classes App Server Down"                       # title for notification email
downMessage = "NYU Classes is unavailable."                     # body text for notification email
statusMsgAddress = "********@maildomain.com"                    # source address for notification email
statusMsgPassword = "******************"                        # password for notification email
baseServer = "http://newclasses.nyu.edu"						# the base site url
loginPath = "portal/relogin"									# the login page
userName = "*****"												# the login username
password = "*****"											# the login password
serverFilter = /sakaiCopyrightInfo[^<]*[^>]*>[\s]*([^\s]*)/		# regex for app server name
recipientList = [												# addresses that will receive status messages
    "*************@maildomain.com",
    "*************@maildomain.edu"
]

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
# ---------------------------------------------------------------------------
def notifyRecipients (statusMsgAddress, statusMsgPassword, recipientList, downTitle, downMessage)
    recipientList.length.times do |i|
        msg = "Subject: #{downTitle}\n\n#{downMessage}"
        smtp = Net::SMTP.new 'smtp.gmail.com', 587
        smtp.enable_starttls
        smtp.start("gmail", statusMsgAddress, statusMsgPassword, :login) do
            smtp.send_message(msg, statusMsgAddress, recipientList[i])
        end
    end
end

# ###########################################################################
# Script Action
# ###########################################################################

# Simulate Login.  Notify Recipients in the event of an error
begin
    redirectResponse = autoRedirectWebRequest(baseServer)
    redirectResponse = autoRedirectWebRequest(redirectResponse.newURL + loginPath + "&eid=" + userName + "&pw=" + password + "&submit=Login")
rescue Exception=>e
    errMsg = "\nERROR: " + scriptName + ": Can't resolve URL"
    notifyRecipients(statusMsgAddress, statusMsgPassword, recipientList, downTitle, downMessage+errMsg)
end

# Assertion for App server text.  If not found, notify recipients
if redirectResponse.response.body =~ serverFilter
	#puts "MESSAGE: " + scriptName + ": Server '" + $1 + "' is up and running."
else
	errMsg = "\nERROR: " + scriptName + ": Can't find server name.  May be down."
    notifyRecipients(statusMsgAddress, statusMsgPassword, recipientList, downTitle, downMessage+errMsg)
end










