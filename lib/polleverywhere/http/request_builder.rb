module PollEverywhere
  module HTTP # :nodoc
    # DSL for building requests within our application that build a Request object and send them to
    # an adapter to fulfill the request.
    class RequestBuilder
      attr_accessor :method, :body, :headers, :params, :url, :format, :response, :adapter, :base_url

      def initialize(adapter=PollEverywhere.config.http_adapter, base_url=PollEverywhere.config.url)
        self.adapter = adapter
        self.base_url = base_url
        self.headers = {
          'Content-Type' => 'application/json',
          'Accept' => 'application/json',
          'Authorization' => PollEverywhere.config.http_basic_credentials
        }

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
        if self.params.any?
          symbol = "?"
          self.params.each do |k, v|
            url += "#{symbol}#{k}=#{v}"
            symbol = "&"
          end
        end
        self.url = url
        self
      end
      alias :from :to

      # Specify the mime-type/format of the request.
      def as(format)
        self.format = format
        self
      end

      def request
        Request.new(method, url_for(url), headers, body)
      end

      # Generate a Request object, send it to an adapter, and have it fullfill the response by
      # yielding a Response object.
      def response(&block)
        adapter.execute request, &block
      end

    private
      # If a base_url is given, url_for can detect if a given .to is a path or URL, then
      # setup the approriate URL for the request.
      def url_for(uri)
        if uri.to_s !~ /^http/ and base_url
          "#{base_url}#{uri}"
        else
          uri.to_s
        end
      end
    end
  end
end