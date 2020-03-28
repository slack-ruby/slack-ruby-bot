# frozen_string_literal: true

describe SlackRubyBot::Commands::Support::Match do
  context 'initialized with invalid args' do
    subject { -> { described_class.new('invalid-match-data') } }
    it 'raises ArgumentError' do
      expect(subject)
        .to raise_error(ArgumentError, 'match_data should be a type of MatchData')
    end
  end

  context 'initalized without attachment' do
    subject do
      match_data = /(?<group1>foo)(?<group2>bar)/.match('foobar')
      described_class.new(match_data)
    end

    it 'responds to MatchData methods' do
      MatchData.public_instance_methods(false).each do |method|
        expect(subject).to respond_to(method)
      end
    end

    describe '#attachment' do
      it { expect(subject.attachment).to be_nil }
    end
    describe '#attachment_field' do
      it { expect(subject.attachment_field).to be_nil }
    end
  end

  context 'initialized with attachment' do
    let(:attachment) { Hashie::Mash.new(text: 'Some text') }
    let(:attachment_field) { :text }
    subject do
      match_data = /(?<group1>foo)(?<group2>bar)/.match('foobar')
      described_class.new(match_data, attachment, attachment_field)
    end

    it 'responds to MatchData methods' do
      MatchData.public_instance_methods(false).each do |method|
        expect(subject).to respond_to(method)
      end
    end

    describe '#attachment' do
      it { expect(subject.attachment).not_to be_nil }
      it { expect(subject.attachment).to be_kind_of(Hash) }
      it { expect(subject.attachment).to eq(attachment) }
    end
    describe '#attachment_field' do
      it { expect(subject.attachment_field).not_to be_nil }
      it { expect(subject.attachment_field).to eq(:text) }
    end
  end
end
