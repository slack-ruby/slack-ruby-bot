require 'spec_helper'

describe SlackRubyBot::Commands do
  let! :command do
    Class.new(SlackRubyBot::Commands::Base) do
      command 'send_message_with_gif_spec' do |client, data, match|
        send_message_with_gif client, data.channel, match['expression'], 'dummy'
      end
    end
  end
  def app
    SlackRubyBot::App.new
  end
  let(:client) { app.send(:client) }
  let(:gif_image_url) { 'http://media2.giphy.com/media/pzOijFsdDrsS4/giphy.gif' }
  it 'sends a message with gif' do
    gif = Giphy::RandomGif.new('image_url' => gif_image_url)
    expect(Giphy).to receive(:random).and_return(gif)
    expect(SlackRubyBot::Commands::Base).to receive(:send_client_message).with(client, channel: 'channel', text: "message\n#{gif_image_url}")
    app.send(:message, client, text: "#{SlackRubyBot.config.user} send_message_with_gif_spec message", channel: 'channel', user: 'user')
  end
  it 'eats up the error' do
    expect(Giphy).to receive(:random) { fail 'oh no!' }
    expect(SlackRubyBot::Commands::Base).to receive(:send_client_message).with(client, channel: 'channel', text: 'message')
    app.send(:message, client, text: "#{SlackRubyBot.config.user} send_message_with_gif_spec message", channel: 'channel', user: 'user')
  end
  it 'eats up nil gif' do
    expect(Giphy).to receive(:random).and_return(nil)
    expect(SlackRubyBot::Commands::Base).to receive(:send_client_message).with(client, channel: 'channel', text: 'message')
    app.send(:message, client, text: "#{SlackRubyBot.config.user} send_message_with_gif_spec message", channel: 'channel', user: 'user')
  end
  context 'send_gifs' do
    context 'set to false via client' do
      before do
        client.send_gifs = false
      end
      it 'does not send a gif' do
        expect(Giphy).to_not receive(:random)
        expect(SlackRubyBot::Commands::Base).to receive(:send_client_message).with(client, channel: 'channel', text: 'message')
        app.send(:message, client, text: "#{SlackRubyBot.config.user} send_message_with_gif_spec message", channel: 'channel', user: 'user')
      end
      after do
        client.send_gifs = true
      end
    end
    context 'set to false via config' do
      before do
        SlackRubyBot::Config.send_gifs = false
      end
      it 'does not send a gif' do
        expect(Giphy).to_not receive(:random)
        expect(SlackRubyBot::Commands::Base).to receive(:send_client_message).with(client, channel: 'channel', text: 'message')
        app.send(:message, client, text: "#{SlackRubyBot.config.user} send_message_with_gif_spec message", channel: 'channel', user: 'user')
      end
      after do
        SlackRubyBot::Config.send_gifs = nil
      end
    end
    context 'set to false via SLACK_RUBY_BOT_SEND_GIFS' do
      before do
        ENV['SLACK_RUBY_BOT_SEND_GIFS'] = 'false'
      end
      it 'does not send a gif' do
        expect(Giphy).to_not receive(:random)
        expect(SlackRubyBot::Commands::Base).to receive(:send_client_message).with(client, channel: 'channel', text: 'message')
        app.send(:message, client, text: "#{SlackRubyBot.config.user} send_message_with_gif_spec message", channel: 'channel', user: 'user')
      end
      after do
        ENV.delete 'SLACK_RUBY_BOT_SEND_GIFS'
      end
    end
  end
end
