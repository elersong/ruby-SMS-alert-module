# ============================================================================== Pseudocode Algorithm
#
# 1. acquire the receiving service provider, phone #, sender email and message
# 2. load the web page for the SMS sending web-app
# 3. fill in the appropriate information to the web form
# 4. evaluate the captcha
# 5. submit the form (return true if successful & false if not)
#
# ============================================================================== Module Definition

module NotifySMS
  require 'mechanize'
  require 'open-uri'
  
  # If you only want to use one phone number to send any notifications, you can
  # set it once by adding that number here. Not required. example: "5551234567"
  DEV_PHONE = "change this"
  
  def self.service_provider=(name)
    @@service_provider = name 
  end
  
  def self.service_provider
    @@service_provider ||= nil
  end
  
  def self.phone_number=(number_string)
    @@phone_number = number_string unless DEV_PHONE != "change this"
  end
  
  def self.phone_number
    return DEV_PHONE unless (DEV_PHONE == "change this")
    @@phone_number ||= nil 
  end
  
  def self.sender_email=(email)
    @@sender_email = email
  end
  
  def self.sender_email
    @@sender_email ||= nil
  end
  
  def self.message=(message)
    @@message = message
  end
  
  def self.message
    @@message ||= nil
  end

  def self.send
    NotifySMS.connect
    
    if NotifySMS.ready?
      NotifySMS.select_option(NotifySMS.service_provider)     # select service provider
      @@form["to"] = NotifySMS.phone_number                   # enter receiver phone number
      @@form["email"] = NotifySMS.sender_email                # enter sender email
      @@form["message"] = NotifySMS.message                   # enter message
    else
      raise "One or more attributes have not been set."
      false
    end
    
    @@form.submit
    true
  end
  
  private
  
  def self.connect
    agent = Mechanize.new
    @@page = agent.get("http://www.textsendr.com/")
    @@form = @@page.forms[1]
    @@form["mathcha"] = NotifySMS.solve_captcha     # solve mathcha
  end
  
  def self.ready?
    if (NotifySMS.phone_number == nil ||
        NotifySMS.sender_email == nil ||
        NotifySMS.message == nil      ||
        NotifySMS.service_provider == nil)
      false
    else
      true
    end
  end
  
  def self.select_option(name)
    value = nil
    
    @@form.field_with(:name => "provider").options.each do |option| 
      value = option if (option.text.downcase == name.downcase || option.text.downcase.include?(name.downcase))
    end
    
    raise ArgumentError, "No option with text '#{name}' in field 'provider'" unless value
    @@form.field_with(:name => "provider").value = value
    #puts "successful provider: #{name}"
  end
  
  def self.solve_captcha
    label_with_mathcha = @@page.search(".//label[@align='right']")
    #puts label_with_mathcha.text
    
    numbers = label_with_mathcha.text.scan(/\d+/)
    total = numbers[0].to_i + numbers[1].to_i
    #puts "Total = #{total}"
    total.to_s
  end

end

# ============================================================================== Testing Code

NotifySMS.service_provider = "Sprint"
NotifySMS.phone_number = "5551234567"
NotifySMS.sender_email = "grey@hackhands.com"
NotifySMS.message = "This is a message. Check it out!."

NotifySMS.send