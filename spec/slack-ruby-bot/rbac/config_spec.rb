describe SlackRubyBot::RBAC do
  context 'setting config option SlackRubyBot::Config.rbac_allow' do
    before(:each) { SlackRubyBot::Config.rbac_allow = nil }
    after(:each) { SlackRubyBot::Config.rbac_allow = nil }

    it 'when nil defaults to deny mode' do
      SlackRubyBot::Config.rbac_allow = nil
      expect(SlackRubyBot::RBAC.deny_mode?).to be true
      expect(SlackRubyBot::RBAC.allow_mode?).to be false
    end

    it 'when false returns deny mode' do
      SlackRubyBot::Config.rbac_allow = false
      expect(SlackRubyBot::RBAC.deny_mode?).to be true
      expect(SlackRubyBot::RBAC.allow_mode?).to be false
    end

    it 'when :rbac_deny returns deny mode' do
      SlackRubyBot::Config.rbac_allow = :rbac_deny
      expect(SlackRubyBot::RBAC.deny_mode?).to be true
      expect(SlackRubyBot::RBAC.allow_mode?).to be false
    end

    it 'set to false returns deny mode' do
      SlackRubyBot::Config.rbac_allow = false
      expect(SlackRubyBot::RBAC.deny_mode?).to be true
      expect(SlackRubyBot::RBAC.allow_mode?).to be false
    end

    it 'when true returns allow mode' do
      SlackRubyBot::Config.rbac_allow = true
      expect(SlackRubyBot::RBAC.deny_mode?).to be false
      expect(SlackRubyBot::RBAC.allow_mode?).to be true
    end
  end
end
