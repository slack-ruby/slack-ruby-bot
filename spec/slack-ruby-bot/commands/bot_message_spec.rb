describe SlackRubyBot::Commands::Help do
  def app
    SlackRubyBot::App.new
  end
  it 'bot' do
    expect(message: "#{SlackRubyBot.config.user} bot").to respond_with_slack_message("Sorry <@user>, I don't understand that command!")
  end

  it 'bot does not respond when mute' do
    SlackRubyBot::Config.mute = true
    expect(message: "#{SlackRubyBot.config.user} bot").to not_respond
    SlackRubyBot::Config.mute = false
  end
end
