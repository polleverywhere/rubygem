require 'uri'
require 'json'

module PollEverywhere
  autoload :HTTP, 'polleverywhere/http'

  def self.service
    @service ||= Service.new("http://api.polleverywhere.com/")
  end

  def self.service=(service)
    @service = service
  end

  def self.http_adapter
    @http_adapter ||= HTTP.adapter(:sync) do |adapter|
      adapter.url = service.url
    end
  end

  def self.http
    HTTP::RequestBuilder.new
  end
  
  # This class hangs on to information specific about the Poll Everywhere server endpoint.
  class Service
    attr_reader :url

    def initialize(url)
      @url = URI.parse(url)
    end
  end
  
  class Poll
    States = [:opened, :closed, :maxed_out].freeze
    attr_accessor :id, :title, :opened_at, :state, :owner_id, :options, :permalink, :created_at, :updated_at
    attr_accessor :http
    
    def initialize(http=PollEverywhere.http)
      self.http = http
    end

    def persisted?
      !!id
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

    def destroy
      http.delete(path).response do |response|
        self.id = self.permalink = nil
      end
    end

    def path
      "/#{root_key}s/#{permalink}" if persisted?
    end
  end

  class MultipleChoicePoll < Poll
    class Option
      attr_accessor :value, :keyword, :id, :correct, :results_percentage, :results_count
      attr_reader :poll

      def initialize(poll)
        @poll = poll
      end

      # Converts the poll option into a hash that can be serialized
      def to_hash
        { :value => value, :keyword => keyword, :id => id }
      end

      # Sets the values for the poll options with a given hash
      def from_hash(hash)
        hash.each do |key, value|
          self.send "#{key}=", value
        end
        self
      end

      # Create an instsance of a multiple choice option from a hash
      def self.from_hash(poll, hash)
        new(poll).from_hash(hash)
      end
    end

    attr_reader :root_key

    def root_key
      :multiple_choice_poll
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
          Option.from_hash(self, val)
        else
          Option.from_hash(self, :value => val.to_s)
        end
      end
    end

    def to_hash
      {
        root_key => {
          :id => id,
          :permalink => permalink,
          :title => title,
          :state => state,
          :options => options.map(&:to_hash)
        }
      }
    end

    def from_hash(hash)
      hash = hash[root_key.to_s] if hash[root_key.to_s] # pop the root key if its given
      hash.each do |key, value|
        self.send("#{key}=", value) if self.respond_to?("#{key}=")
      end
      self
    end

    # Create an instance of a poll from a hash
    def self.from_hash(hash)
      new.from_hash hash
    end

    def self.root_key
      :multiple_choice_poll
    end

    def to_json
      JSON(to_hash)
    end

    def from_json(string)
      from_hash JSON(string)
    end

    # Convert the seriazable params into an array of parameters that a querystring or curl might use.
    def to_params
      to_hash[root_key].map do |(param, value)|
        "#{root_key}[#{param}]='#{value}'"
      end
    end

    # Genearte curl commands. Userful for documentation.
    def to_curl_params(service=Polleverywhere.service)
      %(curl -X #{persisted? ? "PUT" : "POST"} "#{service.url}#{path}" \\\n#{to_params.map{|p| "  #{p}"}.join " \\\n"})
    end
  end
end