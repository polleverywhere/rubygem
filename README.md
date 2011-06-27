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
    
    # Create a multiple choice poll
    poll = PollEverywhere::MultipleChoicePoll.new
    poll.title = 'Do you love numbers?'
    poll.options = %w[1 2 3]
    poll.save
    # Create a free text poll    
    poll = PollEverywhere::FreeTextPoll.new
    poll.title = 'What is your favorite thing about vacation?'
    poll.save
    # Now start playing! Get a list of your polls
    polls = PollEverywhere::Poll.all

You can do all sorts of fun stuff with polls!

A roadmap for our API:

* API models and documentation for more pieces of our application
* Asyn/Evented HTTP adapter
* App layer specs
* Protocol/API layer specs
* Implement documentation system around protocol/API layer specs so that we can run our specs againts a staging environment and validate that it works.