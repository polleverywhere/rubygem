require 'uri'
require 'base64'

module PollEverywhere
  # Configuration information for the Poll Everywhere gem.
  class Configuration
    include Configurable
    configurable :url, :username, :password, :http_adapter

    # Setup default values for configuration class as instance variables.
    def initialize
      self.url = "http://api.polleverywhere.com"
      self.http_adapter = :sync
    end

    # Make sure that a set URL is always an URI object.
    def url=(val)
      @url = URI.parse(val)
    end

    # Setup the HTTP adapter that will execute HTTP requests.
    def http_adapter=(name)
      @http_adapter = HTTP.adapter(name.to_sym)
    end

    # Builds an HTTP Basic header for our authentication. Eventually
    # this form of authorization will be replaced with a token authorization 
    # so that a password is not required.
    def http_basic_credentials
      "Basic #{Base64.encode64("#{username}:#{password}")}"
    end
  end
end