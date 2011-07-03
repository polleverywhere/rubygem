# Renders various formats of code for a given piece of Ruby API code.
module Haml::Filters::Example
  include Haml::Filters::Base

  def render(text)
    # TODO move this into a klass so that different formats are supported 'n' such
    formats = {}
    formats[:ruby] = text
    eval(text, self.send(:binding)) # Run the ruby code so we can get at the curl formats, etc
    formats[:curl] = PollEverywhere.config.http_adapter.last_requests.map(&:to_curl).join("\n\n")
    formats.map{ |format, example| %(<pre class="#{format}">#{example}</pre>) }.join
  end
end