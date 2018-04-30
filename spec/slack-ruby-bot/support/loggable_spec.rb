# frozen_string_literal: true

describe SlackRubyBot::Loggable do
  let!(:class_with_logger)       { Class.new SlackRubyBot::Commands::Base }
  let!(:child_class_with_logger) { Class.new class_with_logger }
  describe 'logger for class' do
    context 'set logger by config' do
      let(:logger) { double 'logger' }
      it do
        SlackRubyBot.configure do |config|
          config.logger = logger
        end
        expect(class_with_logger.logger).to eq logger
        expect(child_class_with_logger.logger).to eq logger
      end
    end
    context 'default logger' do
      it do
        expect(class_with_logger.logger).to be_kind_of Logger
        expect(child_class_with_logger.logger).to be_kind_of Logger
      end
    end
    it 'should be cached' do
      first_logger = class_with_logger.logger
      second_logger = class_with_logger.logger
      expect(first_logger.object_id).to eq second_logger.object_id
    end
    it 'should not be shared by a child class' do
      first_logger = class_with_logger.logger
      second_logger = child_class_with_logger.logger
      expect(first_logger.object_id).to_not eq second_logger.object_id
    end
  end
  describe 'logger for instance' do
    it 'same with one for class' do
      expect(class_with_logger.new.logger.object_id).to eq class_with_logger.logger.object_id
      expect(child_class_with_logger.new.logger.object_id).to eq child_class_with_logger.logger.object_id
    end
  end
end
