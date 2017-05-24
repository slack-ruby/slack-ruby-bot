describe SlackRubyBot::Commands do
  let! :command do
    Class.new(SlackRubyBot::Commands::Base) do
      command 'space' do |client, data, match|
        client.say(channel: data.channel, text: "#{match[:command]}: #{match[:expression]}")
      end
    end
  end

  context 'in deny mode' do
    before(:each) do
      SlackRubyBot::Config.rbac_allow = false
    end

    context 'with no user set' do
      it 'runs the command successfully' do
        expect(message: "#{SlackRubyBot::Config.user}   space red").to invoke_command('space: red')
      end
    end

    context 'with no command registered' do
      it 'runs the command successfully' do
        expect(message: "#{SlackRubyBot::Config.user}   space red").to invoke_command('space: red')
      end
    end

    context 'with user and command registered' do
      it 'does not run the command' do
        SlackRubyBot::RBAC.add_user_to_group(SlackRubyBot::Config.user, :group1)
        SlackRubyBot::RBAC.add_command_to_group('space', :group1)
        expect(message: "#{SlackRubyBot::Config.user}   space red").to not_invoke_command('space: red')
      end
    end
  end
end
