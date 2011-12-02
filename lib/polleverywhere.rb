require 'polleverywhere/version'

module PollEverywhere
  autoload :Configuration,  'polleverywhere/configuration'
  autoload :HTTP,           'polleverywhere/http'
  autoload :CoreExt,        'polleverywhere/core_ext'
  autoload :Serializable,   'polleverywhere/serializable'
  autoload :Configurable,   'polleverywhere/configurable'
  autoload :Models,         'polleverywhere/models'

  # Lets make life easier for developers and provide shortcuts to module and class names. 
  # PollEverywhere::Model::MultipleChoicePoll now becomes PollEverywhere::MCP. Cool eh? Thank me later.
  Participant = Models::Participant
  MCP = MultipleChoicePoll = Models::MultipleChoicePoll
  FTP = FreeTextPoll = Models::FreeTextPoll
  

  def self.config(&block)
    @config ||= Configuration.new
    @config.configure(&block) if block
    @config
  end

  def self.http
    HTTP::RequestBuilder.new
  end
end