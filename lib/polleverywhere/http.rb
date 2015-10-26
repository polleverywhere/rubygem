module PollEverywhere
  module HTTP
    autoload :RequestBuilder, 'polleverywhere/http/request_builder'
    autoload :Adapter,        'polleverywhere/http/adapter'

    # Shortcut for getting adapater instances
    def self.adapter(name, &block)
      Adapter.registry[name].new(&block)
    end

    # Simple HTTP request/response objects for our adapter and DSL
    class Request < Struct.new(:method, :url, :headers, :body)
      def to_curl
        case method.to_s
        when /^put|post$/i
          %(curl -X #{method.to_s.upcase} #{headers.map{|h,v| %(-H "#{h}: #{v}")}.join(" ")} -d "#{body.gsub(/[!"`'\n]/){|m| "\\#{m}" }}" "#{url}")
        when /^get$/i
          %(curl #{headers.map{|h,v| %(-H "#{h}: #{v}")}.join(" ")} "#{url}")
        else
          %(curl -X #{method.to_s.upcase} #{headers.map{|h,v| %(-H "#{h}: #{v}")}.join(" ")} "#{url}")
        end
      end
    end

    Response = Struct.new(:status, :headers, :body)
  end
end