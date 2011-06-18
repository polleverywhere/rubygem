require 'rest-client'

module PollEverywhere
  module HTTP
    # HTTP adapters make it possible to deal with syncronous or asyncronous HTTP libraries
    module Adapter
      def self.registry
        @adapters ||= Hash.new{|hash,key| h[k.to_sym] }
      end

      def self.register(name, klass)
        registry[name] = klass
      end

      class Sync
        attr_accessor :url

        def initialize
          yield self if block_given?
        end

        def execute(request, &block)
          # TODO get rid of the dependency for RestClient by sucking it up and using the Ruby HTTP client
          RestClient::Request.execute(:method => request.method, :url => url_for(request.url), :payload => request.body, :headers => request.headers) do |r,_,_,_|
            block.call Response.new(r.code, r.headers, r.body)
          end
        end

      private
        def url_for(path)
          # TODO conditionally check if this is a path or full URL
          "#{url}#{path}"
        end
      end

      class Test
        def execute(request, &block)
          requests << request
          block.call(Response.new)
        end

        def requests
          @requests ||= []
        end
      end
      
      self.register :sync, Sync
      self.register :test, Test
    end
  end
end