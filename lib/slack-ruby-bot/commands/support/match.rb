module SlackRubyBot
  module Commands
    module Support
      class Match
        extend Forwardable

        delegate MatchData.public_instance_methods(false) => :@match_data

        attr_reader :attachment, :attachment_field

        def initialize(match_data, attachment = nil, attachment_field = nil)
          unless match_data.is_a? MatchData
            raise ArgumentError, 'match_data should be a type of MatchData'
          end
          @match_data = match_data
          @attachment = attachment
          @attachment_field = attachment_field
        end
      end
    end
  end
end
