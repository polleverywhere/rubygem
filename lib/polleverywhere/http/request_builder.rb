module PollEverywhere
  module HTTP
    # DSL for building requests within our application that build a Request object and send them to 
    # an adapter to fulfill the request.
    class RequestBuilder
      attr_accessor :method, :body, :headers, :params, :url, :format, :response, :adapter

      def initialize(adapter=PollEverywhere.http_adapter)
        self.adapter = adapter
        self.headers = {'Content-Type' => 'application/json', 'Accept' => 'application/json'}
        yield self if block_given?
      end

      def put(body=nil)
        self.method, self.body = :put, body
        self
      end

      def post(body=nil)
        self.method, self.body = :post, body
        self
      end

      def get(params={})
        self.method, self.params = :get, params
        self
      end

      def delete(params={})
        self.method, self.params = :delete, params
        self
      end

      # Specify the URL of the request.
      def to(url)
        self.url = url
        self
      end
      alias :from :to

      # Specify the mime-type/format of the request.
      def as(format)
        self.format = format
        self
      end

      # Generate a Request object, send it to an adapter, and have it fullfill the response by 
      # yielding a Response object.
      def response(&block)
        adapter.execute Request.new(method, url, headers, body), &block
      end
    end
  end
end