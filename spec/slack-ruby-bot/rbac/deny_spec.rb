describe SlackRubyBot::RBAC do
  context 'in deny mode' do
    before(:each) do
      SlackRubyBot::Config.rbac_allow = false
    end

    it 'returns true by default' do
      expect(SlackRubyBot::RBAC.allowed_for?(nil, nil)).to be true
    end

    it 'returns true for a nil command' do
      expect(SlackRubyBot::RBAC.allowed_for?(SlackRubyBot::Config.user, nil)).to be true
    end

    it 'returns true for an unregistered command' do
      expect(SlackRubyBot::RBAC.allowed_for?(SlackRubyBot::Config.user, 'some_command')).to be true
    end

    it 'returns false for a registered command to a user' do
      SlackRubyBot::RBAC.add_user_to_group(SlackRubyBot::Config.user, :group1)
      SlackRubyBot::RBAC.add_command_to_group('some_command', :group1)
      expect(SlackRubyBot::RBAC.allowed_for?(SlackRubyBot::Config.user, 'some_command')).to be false
    end
  end
end
