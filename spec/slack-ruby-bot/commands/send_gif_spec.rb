require 'spec_helper'

describe SlackRubyBot::Commands, if: ENV.key?('WITH_GIPHY') do
  let! :command do
    Class.new(SlackRubyBot::Commands::Base) do
      command 'send_gif_spec' do |client, data, _match|
        client.say(channel: data.channel, gif: 'dummy')
      end
    end
  end

  let(:gif_image_url) { 'http://media2.giphy.com/media/pzOijFsdDrsS4/giphy.gif' }

  it 'sends a gif' do
    gif = Giphy::RandomGif.new('image_url' => gif_image_url)
    expect(Giphy).to receive(:random).and_return(gif)
    expect(message: "#{SlackRubyBot.config.user} send_gif_spec message").to respond_with_slack_message(gif_image_url)
  end
  it 'eats up the error' do
    expect(Giphy).to receive(:random) { raise 'oh no!' }
    expect(message: "#{SlackRubyBot.config.user} send_gif_spec message").to respond_with_slack_message('')
  end
  it 'eats up nil gif' do
    expect(Giphy).to receive(:random).and_return(nil)
    expect(message: "#{SlackRubyBot.config.user} send_gif_spec message").to respond_with_slack_message('')
  end
end
