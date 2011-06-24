require 'uri'
require 'json'

module PollEverywhere
  autoload :HTTP,         'polleverywhere/http'
  autoload :API,          'polleverywhere/api'
  autoload :CoreExt,      'polleverywhere/core_ext'
  autoload :Serializable, 'polleverywhere/serializable'

  def self.url
    # @url ||= URI.parse("http://test:test@localhost:3000")
    @url ||= URI.parse("http://api.polleverywhere.com")
  end

  def self.service=(service)
    @service = service
  end

  def self.http_adapter
    @http_adapter ||= HTTP.adapter(:sync)
  end

  def self.http
    HTTP::RequestBuilder.new
  end

  class Poll
    include Serializable

    prop :id
    prop :title
    prop :opened_at
    prop :state
    prop :owner_id
    prop :options
    prop :permalink
    prop :updated_at

    attr_accessor :http

    def initialize(http=PollEverywhere.http)
      self.http = http
    end

    def persisted?
      !!permalink
    end

    def save
      if persisted?
        http.put(to_json).as(:json).to(path).response do |response|
          from_json response.body
        end
      else
        http.post(to_json).as(:json).to('/multiple_choice_polls').response do |response|
          from_json response.body
        end
      end
    end

    def self.get(permalink)
      from_hash(:permalink => permalink).fetch
    end

    def destroy
      http.delete(path).response do |response|
        self.id = self.permalink = nil
      end
    end

    def path
      "/#{self.class.root_key}s/#{permalink}" if persisted?
    end

    def possible_states
      [:opened, :closed, :maxed_out]
    end
  end

  class FreeTextPoll < Poll
    root_key :freetext_choice_poll

    prop :keyword
  end

  class MultipleChoicePoll < Poll

    root_key :multiple_choice_poll

    class Option
      include Serializable

      prop :id
      prop :value
      prop :keyword

      attr_reader :poll

      def initialize(poll)
        @poll = poll
      end
    end

    # Choices for a multiple choice poll
    def options
      @options ||= []
    end

    # Accept an array of options as strings, hashes, or options objects.
    def options=(options)
      @options = options.map do |val|
        case val
        when Option
          val.poll = self
          val
        when Hash
          Option.new(self).from_hash(val)
        else
          Option.new(self).from_hash(:value => val.to_s)
        end
      end
    end

    def fetch
      http.get.from(path).as(:json).response do |response|
        from_json response.body
      end
    end

    # Add the serialize options hash to the meix
    def to_hash
      hash = super
      hash[:multiple_choice_poll][:options] = options.map(&:to_hash)
      hash
    end
  end
end