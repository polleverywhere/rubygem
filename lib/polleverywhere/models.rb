module PollEverywhere # :nodoc
  module Models # :nodoc
    # Poll is an abstract base classe for multiple choice and free text polls
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

      # prop :state do
      #   description %{Determines whether or not a poll can recieve responses. If the state is 'closed', the poll won't receive responses from the audience. If the poll is 'opened', the poll can receive responses from the audience. If the state is 'maxed_out', the poll won't receive responses until the account is upgraded to support more poll responses.}
      # end

      attr_accessor :http

      def initialize(http=PollEverywhere.http)
        self.http = http
      end

      # Start the poll so that it may receive audience responses
      def start
        state = "opened"
        save
      end

      # Stop the poll so that it stops receieving responses
      def stop
        state = "closed"
        save
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
end