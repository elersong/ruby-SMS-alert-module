__Date: 29 Jan 2015__
__Author: Grey Elerson__
#Title: Ruby NotifySMS Alert Module

This project is created with ruby version 2.1.5p273 and serves the purpose
of sending SMS text-only messages to a phone number of your choosing using
the Mechanize gem and a free online texting service called TextSendr.

The module performs as expected as of this date, but changes in updated
versions of ruby, mechanize or TextSendr could render this module obsolete.
Code presented here is free to use as desired without any attribution 
required as to the original author. Likewise, any repercussions incurred
stemming from the use of this code for evil instead of good will be treated
as your own fault. The original author assumes absolutely no liability. 

Programmer descretion is advised. 

To use the NotifySMS module, simply include the code in your project, and set
up the required attributes before calling the `send` method as follows. Keep
in mind that you will need to make any changes by hand if you wish to send more
than one message. The module will persist the message information so that if
you send a message twice without changing the recipient or the message text, 
that same phone will recieve two identical messages.

Example:

```ruby
NotifySMS.service_provider = "Verizon"
NotifySMS.phone_number = "5551234567"
NotifySMS.sender_email = "notificationse@testapp.com"
NotifySMS.message = "Over 500 users have registered today for TestApp.com"

NotifySMS.send
```