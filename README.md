# The Official Poll Everywhere API Gem

The Poll Everywhere gem is the best way to integrate Poll Everywhere with your applications.

# Getting Started

Install the Poll Everywhere rubygem:

    sudo gem install polleverywhere

If you're using bundler, add the following line to your Gemfile:

    gem "polleverywhere"

# Accessing your polls

    require 'polleverywhere'
    
    # Specify your username and password here
    PollEverywhere.config do
      username  "my_username"
      password  "my_password"
    end
    
    # Now start playing!
    polls = PollEverywhere::Poll.all
    poll = poll.first
    poll.close
    poll.title = "Hey there, I like changing titles around"
    poll.options = %w[uno dos tres]
    poll.save
    poll.open

You can do all sorts of fun stuff with polls!

A roadmap for our API:

* API models and documentation for more pieces of our application
* Asyn/Evented HTTP adapter
* App layer specs
* Protocol/API layer specs
* Implement documentation system around protocol/API layer specs so that we can run our specs againts a staging environment and validate that it works.