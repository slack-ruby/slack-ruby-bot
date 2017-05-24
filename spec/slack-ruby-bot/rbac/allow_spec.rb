describe SlackRubyBot::RBAC do
  context 'in allow mode' do
    before(:each) do
      SlackRubyBot::Config.rbac_allow = :rbac_allow
    end

    after(:all) do
      SlackRubyBot::Config.rbac_allow = :rbac_deny
    end

    it 'returns false by default' do
      expect(SlackRubyBot::RBAC.allowed_for?(nil, nil)).to be false
    end

    it 'returns false for a nil command' do
      expect(SlackRubyBot::RBAC.allowed_for?(SlackRubyBot::Config.user, nil)).to be false
    end

    it 'returns false for an unregistered command' do
      expect(SlackRubyBot::RBAC.allowed_for?(SlackRubyBot::Config.user, 'some_command')).to be false
    end

    it 'returns true for a registered command to a user' do
      SlackRubyBot::RBAC.add_user_to_group(SlackRubyBot::Config.user, :group1)
      SlackRubyBot::RBAC.add_command_to_group('some_command', :group1)
      expect(SlackRubyBot::RBAC.allowed_for?(SlackRubyBot::Config.user, 'some_command')).to be true
    end
  end
end
