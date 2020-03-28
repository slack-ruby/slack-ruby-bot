# frozen_string_literal: true

describe RSpec do
  let! :command do
    Class.new(SlackRubyBot::Commands::Base) do
      command 'raise' do |_client, _data, match|
        raise ArgumentError, match[:command]
      end

      attachment 'raise' do |_client, data, _match|
        raise ArgumentError, data.attachments[0].pretext
      end
    end
  end
  def app
    SlackRubyBot::App.new
  end
  it 'respond_with_error' do
    expect(message: "#{SlackRubyBot.config.user} raise").to respond_with_error(ArgumentError, 'raise')
  end
  it 'respond_with_error_using_attachment_match' do
    expect(attachments: { pretext: 'raise' }).to respond_with_error(ArgumentError, 'raise')
  end
end
