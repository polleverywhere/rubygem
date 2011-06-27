require 'sourcify'
require 'haml'

module PollEverywhere
  module API
    # Generates API integration documentation from HAML
    class Documentation
      attr_reader :template

      def initialize(template)
        @template = template
      end

      # Generates API documentation
      def generate
        Haml::Engine.new(template, :format => :html5).render(self)
      end

      # Generate the HAML documentation from the default docs path
      def self.generate(path=File.expand_path('../../../docs/api.haml', __FILE__))
        new(File.read(path)).generate
      end

      def examples(model)
        model.http.adapter.request.to_curl
      end

      def example(&block)
        formats = {}
        block.call
        # formats[:ruby] = block.to_source(:strip_enclosure => true)
        formats[:curl] = PollEverywhere.config.http_adapter.last_requests.map(&:to_curl).join("\n\n")
        puts formats.map{ |format, example| %(<pre class="#{format}">#{example}</code>) }.join
      end
    end
  end
end