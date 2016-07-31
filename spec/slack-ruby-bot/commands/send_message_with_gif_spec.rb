require 'spec_helper'

describe SlackRubyBot::Commands, if: ENV.key?('WITH_GIPHY') do
  let! :command do
    Class.new(SlackRubyBot::Commands::Base) do
      command 'send_message_with_gif_spec' do |client, data, match|
        client.say(channel: data.channel, text: match['expression'], gif: 'dummy')
      end
    end
  end
  let(:gif_image_url) { 'http://media2.giphy.com/media/pzOijFsdDrsS4/giphy.gif' }

  it 'sends a message with gif' do
    gif = Giphy::RandomGif.new('image_url' => gif_image_url)
    expect(Giphy).to receive(:random).and_return(gif)
    expect(message: "#{SlackRubyBot.config.user} send_message_with_gif_spec message").to respond_with_slack_message("message\n#{gif_image_url}")
  end

  it 'eats up errors' do
    expect(Giphy).to receive(:random) { raise 'oh no!' }
    expect(message: "#{SlackRubyBot.config.user} send_message_with_gif_spec message").to respond_with_slack_message('message')
  end

  it 'eats up nil gif' do
    expect(Giphy).to receive(:random).and_return(nil)
    expect(message: "#{SlackRubyBot.config.user} send_message_with_gif_spec message").to respond_with_slack_message('message')
  end

  context 'when client.send_gifs is false' do
    let :client do
      SlackRubyBot::Client.new.tap { |c| c.send_gifs = false }
    end

    it 'does not send a gif' do
      expect(Giphy).to_not receive(:random)
      expect(message: "#{SlackRubyBot.config.user} send_message_with_gif_spec message").to respond_with_slack_message('message')
    end
  end
end
