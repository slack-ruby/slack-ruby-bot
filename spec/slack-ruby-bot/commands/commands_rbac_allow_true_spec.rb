describe SlackRubyBot::Commands do
  let! :command do
    Class.new(SlackRubyBot::Commands::Base) do
      command 'frontier' do |client, data, match|
        client.say(channel: data.channel, text: "#{match[:command]}: #{match[:expression]}")
      end
    end
  end

  context 'in allow mode' do
    before(:each) do
      SlackRubyBot::Config.rbac_allow = true
    end

    context 'with no user set' do
      it 'does not run the command' do
        expect(message: "#{SlackRubyBot::Config.user}   frontier red").to not_invoke_command('frontier: red')
      end
    end

    context 'with no command registered' do
      it 'does not run the command' do
        expect(message: "#{SlackRubyBot::Config.user}   frontier red").to not_invoke_command('frontier: red')
      end
    end

    context 'with user and command registered' do
      it 'runs the command successfully' do
        SlackRubyBot::RBAC.add_user_to_group(SlackRubyBot::Config.user, :group1)
        SlackRubyBot::RBAC.add_command_to_group('frontier', :group1)
        expect(message: "#{SlackRubyBot::Config.user}   frontier red").to invoke_command('frontier: red')
      end
    end
  end
end
