require 'rubygems'
require 'selenium-webdriver'

# ###########################################################################
# Title:	SmartDriver
# Author:	Tom Martin
# Date:		3/21/2013
#
# ***************** THIS SCRIPT IS A WORK IN PROGRESS **********************
# THIS SCRIPT IS STILL IN DEVELOPMENT, NEEDS REFACTORING, CLEANUP, STRUCTURE
# AND PROBABLY A BUNCH OF OTHER STUFF.  IT STARTED OFF AS A PROOF OF CONCEPT
# AND EVOLVED INTO A TOOL USED TO SOLVE A SPECIFIC PROBLEM.  I BELEIVE THAT
# THE APPROACH TAKEN HERE IS APPLICABLE TO MOST BROWSER AUTOMATION PROBLEMS
# BUT THIS IMPLEMENTATION IS NOT YET A MATURE PRODUCT.  USE WITH CAUTION.
#
# **************************************************************************
# Selenium 2 is a low-level tool for automating web browers.  It's low-level
# nature affords it tremendous flexibility, but this flexibility is often
# burdensome for scripts which do not necessarily need all of the flexibility.
#
# SmartDriver aims to fix this by wrapping the low-level selenium API into
# a more accessibile api.  Features of SmartDriver:
#       1. Frames are handled auto-magically.
#       2. Interactive controls can be auto-magically located by vertical adjacency in the HTML tree.
#       3. Elements can be located with out specifying the method by which they are located.
#
# Scripts which use SmartDriver are:
#       1. ...shorter
#       2. ...contain less logic.
#       3. ...identify objects with reduced specificity.
#       4. ...more resilient to changes in the websites being tested.
#
# ###########################################################################


# try to identify by label, then by id, then by attribute xpath, in that order
# for each method, traverse the tree one node one node up and three nodes down
# do this entire process for each frame
# syntax for id is different from label which is yet different from the xpath "typical" case
class SmartDriver
    public
    
    def initialize(depth, num_retries, verbose)
        profile = Selenium::WebDriver::Firefox::Profile.new
        @driver = Selenium::WebDriver.for :firefox, :profile => profile
        @sleep_time = 0 #don't need this
        @search_depth = depth
        @verbose_mode = verbose
        @fail_count = 0
        @max_retries = num_retries
        @retry_sleep_time = 5
        @ignore_errors = false
    end
    
    def enable_errors ()
        @ignore_errors = false
    end
    
    def disable_errors ()
        @ignore_errors = true
    end
    
    def getDriver ()
        return @driver
    end
    
    def submit (match_text)
        sleep @sleep_time
        perform_op(match_text,"submit",'')
    end
    
    def click (match_text)
        sleep @sleep_time
        perform_op(match_text,"click",'')
    end
    
    def send_keys (match_text, input_text)
        sleep @sleep_time
        perform_op(match_text, "send_keys", input_text)
    end
    
    def list_select (match_text, item_index)
        sleep @sleep_time
        perform_op(match_text, "list_select", item_index)
    end
    
    def get (url)
        sleep @sleep_time
        @driver.get(url)
    end
    
    def clear (match_text)
        sleep @sleep_time
        perform_op(match_text,"clear",'')
    end
    
    # returns true if the operation is successful on "some" frame
    # the operation is carried out in the "-> for each frame ... <- for each frame" section
    def iterate_frames_recursor(in_frame, param, op, data)
        if in_frame == "default_content"
            begin
                if @verbose_mode
                    puts "frame: default_content"
                end
                begin
                    @driver.switch_to.default_content
                rescue
                    puts "Error switching to frame."
                    raise "Error switching to frame."
                end
            rescue
                return false
            end
        else
            begin
                if @verbose_mode
                    print "frame: #{in_frame}, name: "
                    begin
                        puts "name: #{in_frame.attribute('title')}"
                    rescue
                        puts "<name not found>"
                    end
                end
                begin
                    @driver.switch_to.frame(in_frame)
                rescue
                    puts "Error switching to frame."
                    raise "Error switching to frame."
                end
            rescue
                return false
            end
        end
        
        # -> for each frame
        begin
            op_down_by_attrib(param, op, data, 0)
            return true
        rescue
        end
        # <- for each frame
        
        new_frames = @driver.find_elements(:tag_name, 'iframe')
        new_frames.each { |new_frame|
            return iterate_frames_recursor(new_frame, param, op, data)
        }
        return false
    end
    
    # returns true if the operation is successful on "some" frame
    # the operation is carried out in the "-> for each frame ... <- for each frame" section
    # this function with said "for each ->" section is in the helper function iterate_frames_recursor
    def iterate_frames(param, op, data)
        return iterate_frames_recursor("default_content", param, op, data)
    end
    
    private
    def perform_op (param, op, data)
        if iterate_frames(param, op, data)
            if @verbose_mode
                puts "SUCCESS #{param}, #{op}, #{data}"
            end
        else
            puts "FAIL_OP #{param}, #{op}, #{data}"
            if (!@ignore_errors)
                @fail_count = @fail_count + 1
                if @fail_count >= @max_retries
                    puts("Error limit reached.  Encountered #{@fail_count} error(s). Exiting.")
                    exit
                else
                    puts "Will retry in #{@retry_sleep_time} seconds..."
                    sleep @retry_sleep_time
                    perform_op(param, op, data)
                end
            else
                puts "Ingoring error."
            end
        end
        @fail_count = 0
    end
    
    def op_down_by_attrib (param, op, data, curr_level)
        if curr_level > @search_depth
            if @verbose_mode
                puts "op_down_by_attrib: #{param} not found."
            end
            raise "op_down_by_attrib: #{param} not found."
            return
        else
            begin
                augment_string = ""
                if curr_level > 0
                    for i in 0..curr_level-1 do
                        augment_string = augment_string + '/*'
                    end
                end
                    
                if op == "click"
                    begin
                        @driver.find_element(:link_text, "#{param}").click
                        if @verbose_mode
                            puts "[op_down_by success, link_text method: #{param}, #{op}, #{data}, #{curr_level}]"
                        end
                    rescue
                        begin
                            element = @driver.find_element(:id, "#{param}").click
                            if @verbose_mode
                                puts "[op_down_by success, id method: #{param}, #{op}, #{data}, #{curr_level}]"
                            end
                        rescue
                            begin
                                element = @driver.find_element(:xpath, "//*[@*=\'#{param}\']#{augment_string}").click
                                if @verbose_mode
                                    puts "[op_down_by success, attribute method: #{param}, #{op}, #{data}, #{curr_level}]"
                                end
                            rescue
                                begin
                                    element = @driver.find_element(:xpath, "//*[*=\'#{param}\']#{augment_string}").send_keys(data).click
                                    if @verbose_mode
                                        puts "[op_down_by success, attribute + augmentation method: #{param}, #{op}, #{data}, #{curr_level}]"
                                    end
                                rescue
                                    raise "op_down_by_attrib:/send_keys: #{param} not found."
                                end
                            end
                        end
                    end
                elsif op == "send_keys"
                    begin
                        element = @driver.find_element(:id, "#{param}")
                        # raise error if sendkeys didn't work
                        value_before = element.attribute("value")
                        element.send_keys(data)
                        value_after = element.attribute("value")
                        if value_before == value_after
                            raise "send_keys failed"
                        end
                        if @verbose_mode
                            puts "[op_down_by success, id method: #{param}, #{op}, #{data}, #{curr_level}]"
                        end
                    rescue
                        begin
                            element = @driver.find_element(:xpath, "//*[@*=\'#{param}\']#{augment_string}")
                            # raise error if sendkeys didn't work
                            value_before = element.attribute("value")
                            element.send_keys(data)
                            value_after = element.attribute("value")
                            if value_before == value_after
                                raise "send_keys failed"
                            end
                            if @verbose_mode
                                puts "[op_down_by success, attribute method: #{param}, #{op}, #{data}, #{curr_level}]"
                            end
                        rescue
                            begin
                                element = @driver.find_element(:xpath, "//*[*=\'#{param}\']#{augment_string}").send_keys(data)
                                # raise error if sendkeys didn't work
                                value_before = element.attribute("value")
                                element.send_keys(data)
                                value_after = element.attribute("value")
                                if value_before == value_after
                                    raise "send_keys failed"
                                end
                                if @verbose_mode
                                    puts "[op_down_by success, attribute + augmentation method: #{param}, #{op}, #{data}, #{curr_level}]"
                                end
                            rescue
                                raise "op_down_by_attrib:/send_keys: #{param} not found."
                            end
                        end
                    end
                    
                elsif op == "submit"
                    begin
                        @driver.find_element(:xpath, "//*[@*=\'#{param}\']#{augment_string}").submit
                    rescue
                        begin
                            @driver.find_element(:xpath, "//*[*=\'#{param}\']#{augment_string}").submit
                        rescue
                            raise "op_down_by_attrib:/submit: #{param} not found."
                        end
                    end
                    
                elsif op == "clear"
                    begin
                        if @verbose_mode
                            puts "op_down_by, id method: #{param}, #{op}, #{data}, #{curr_level}..."
                        end
                        @driver.find_element(:id, "#{param}").clear
                    rescue
                        begin
                            if @verbose_mode
                                puts "op_down_by, attribute method: #{param}, #{op}, #{data}, #{curr_level}..."
                            end
                            @driver.find_element(:xpath, "//*[@*=\'#{param}\']#{augment_string}").clear
                        rescue
                            begin
                                if @verbose_mode
                                    puts "op_down_by: attribute + augmentation method:  #{param}, #{op}, #{data}, #{curr_level}..."
                                end
                                @driver.find_element(:xpath, "//*[*=\'#{param}\']#{augment_string}").clear
                            rescue
                                raise "op_down_by_attrib:/submit: #{param} not found."
                            end
                        end
                    end
                    
                elsif op == "list_select"
                    if @verbose_mode
                        puts "THE LIST SELECT HAPPENED!!!"
                    end
                    begin
                        if @verbose_mode
                            puts "Attempting list_select/find_element. param: #{param}, data: #{data}"
                        end
                        element = @driver.find_element(:xpath, "//*[@*=\'#{param}\']#{augment_string}")
                        if @verbose_mode
                            puts "Attempting list_select/identify dropdown. param: #{param}, data: #{data}, element: #{element}"
                        end
                        dropdown = Selenium::WebDriver::Support::Select.new(element)
                        if @verbose_mode
                            puts "Attempting list_select/select_by: #{param}, data: #{data}"
                        end
                        dropdown.select_by(:index, data)
                        if @verbose_mode
                            puts "Asserting that list_select/select_by actually worked."
                        end
                    rescue
                        raise "op_down_by_attrib:/list_select: #{param} not found."
                    end
                    
                elsif op == "assert"
                    begin
                        @driver.find_element(:xpath, "//*[@*=\'#{param}\']#{augment_string}")
                        return true
                    rescue
                        begin
                            @driver.find_element(:xpath, "//*[@*=\'#{param}\']#{augment_string}")
                            return true
                        rescue
                            raise "op_down_by_attrib:/assert: #{param} not found."
                        end
                    end
                    
                else
                    puts "invalid operation"
                end
                return true
            rescue
                return op_down_by_attrib(param, op, data, curr_level+1)
            end
        end
    end
        
end

    
# Script helper functions ---------------------------------------------------------------------------------------
def integer_to_instructor_id (integer)
    if integer>240
        exit
    end
    return_string = "#{integer}"
    for i in 0..(8-return_string.length)
        return_string = "0#{return_string}"
    end
    return_string = "instructor#{return_string}"
    return return_string
end
    
def integer_to_user_id (integer)
    if integer>7000
        exit
    end
    return_string = "#{integer}"
    for i in 0..(8-return_string.length)
        return_string = "0#{return_string}"
    end
    return_string = "user#{return_string}"
    return return_string
end

# Instantiation ---------------------------------------------------------------------------------------------
driver = SmartDriver.new(3,3,false)
    
# Login -----------------------------------------------------------------------------------------------------
driver.get('<SITE URL>')
driver.send_keys('eid','<USERNAME>')
driver.send_keys('pw','<PASSWORD>')
driver.submit('pw')
    
# Get Next Site Number  -------------------------------------------------------------------------------------
for site_index in 1..200

# Create Course Site ----------------------------------------------------------------------------------------
driver.click('Administration Workspace') # click "Administration Workspace" tab
driver.click('icon-sakai-sitesetup ') # click "Setup Course Sites" tool
driver.click('New') # click "New" button
driver.click('course') # click course site
driver.click('submitBuildOwn') # click continue
driver.list_select('idField_0',1) # select first valid Subject
driver.list_select('idField_1',1) # select first valid Course
driver.list_select('idField_2',1) # select first valid Section
driver.send_keys('uniqname', 'admin') # specify Authorizer's Username
driver.click('continueButton') # click continue

# Specify Site Title
driver.clear('title')
driver.send_keys('title', "TOMTEST_#{site_index}")

# Specify Long Description
# this will report a failure because validation is based on comparing the current value of the
# control the the value after.  But this control creates a subnode <p> on text entry.  That
# entry recieves text. This is unavoidable.  Just ignore this error.
driver.disable_errors
driver.send_keys('cke_show_borders',
    'In software engineering, performance testing is in general testing ' +
    'performed to determine how a system performs in terms of responsiveness' +
    ' and stability under a particular workload. It can also serve to investigate,' +
    ' measure, validate or verify other quality attributes of the system' +
    ', such as scalability, reliability and resource usage.')
driver.enable_errors
 
# Specify Short Description
driver.send_keys('short_description', 'This is a site on performance testing.')

# Click Continue
driver.click('active')

# Select Tests and Quizzes
driver.click('sakai.samigo')

driver.click('Continue') # Click Continue
driver.click('active') # Click Continue
driver.click('addSite') # Click Request Site

# Log out / in ---------------------------------------------------------------------------------------------
driver.click('Logout')
driver.get('<SITE URL>')
driver.send_keys('eid','<USERNAME>')
driver.send_keys('pw','<PASSWORD>')
driver.submit('pw')
    
# Navigate to Course Site -----------------------------------------------------------------------------------
# Go to your new site
#driver.click('goToSiteLink')
driver.click("TOMTEST_#{site_index}")

# Add gradebook items
driver.click('Gradebook')
for i in 1..5
    driver.click('Add Gradebook Item(s)')
    driver.send_keys('gbForm:bulkNewAssignmentsTable:0:title', "Tom Gradebook Item #{i}")
    driver.send_keys('gbForm:bulkNewAssignmentsTable:0:points','100')
    driver.send_keys('gbForm:bulkNewAssignmentsTable:0:dueDate','3/28/14')
    driver.click('gbForm:saveButton')
end
        
# Add Assessment Items
driver.click('Tests & Quizzes')
for i in 1..5
    driver.send_keys('authorIndexForm:title', "Tom Assessment Item #{i}") #assessment title
    driver.click('submit')
    
    # Add multiple choice questions
    for i in 1..5
        driver.list_select('clickInsertLink(this);', 1) #multipole choice question type
        driver.clear('itemForm:answerptr')
        driver.send_keys('itemForm:answerptr', '20') #point value 100
        driver.send_keys('itemForm:_id81_textinput', 'What is the wingspan of a swallow?') #question text
        driver.click('A')
        driver.send_keys('itemForm:mcchoices:0:_id139_textinput','Is that an african swallow?') #answer a
        driver.send_keys('itemForm:mcchoices:1:_id139_textinput','What is your name?') #answer b
        driver.send_keys('itemForm:mcchoices:2:_id139_textinput','Why are we doing this?') #answer c
        driver.send_keys('itemForm:mcchoices:3:_id139_textinput','ahhhhhhhh') #answer d
        driver.click('Save')
    end
    
    # Publish Assessment i
    driver.click('Publish') #click publish toolbar icon
    driver.click('Publish') #click publish button on confirmation screen
end

# Add Students
driver.click('Settings')
driver.click('Add Participants')
for i in 1..30
    driver.send_keys('content::officialAccountParticipant',integer_to_user_id(site_index*30+i) + "\n")
end
driver.click('Continue')
driver.click('Student') #student radio button
driver.click('Continue')
driver.click('Continue')
driver.click('Finish')
    
# Add Instructor
driver.click('Add Participants')
driver.send_keys('content::officialAccountParticipant',integer_to_instructor_id(site_index))
driver.click('Continue')
driver.click('Instructor') #student radio button
driver.click('Continue')
driver.click('Continue')
driver.click('Finish')

puts "TOMTEST_#{site_index} created successfully."

end

    

    
    
    
    
    



