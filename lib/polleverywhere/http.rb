module PollEverywhere
  module HTTP
    autoload :RequestBuilder, 'polleverywhere/http/request_builder'
    autoload :Adapter,        'polleverywhere/http/adapter'

    # Shortcut for getting adapater instances
    def self.adapter(name, &block)
      Adapter.registry[name].new(&block)
    end
    
    # Simple HTTP request/response objects for our adapter and DSL
    Request  = Struct.new(:method, :url, :headers, :body)
    Response = Struct.new(:status, :headers, :body)
  end
end