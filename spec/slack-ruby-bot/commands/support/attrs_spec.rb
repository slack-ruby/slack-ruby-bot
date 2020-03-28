# frozen_string_literal: true

describe SlackRubyBot::Commands::Support::Attrs do
  let(:help_attrs) { described_class.new('WeatherBot') }

  it 'captures commands help attributes' do
    expect(help_attrs.commands).to be_empty

    sample_title = 'how\'s the weather?'
    sample_desc = 'Tells you the weather in a <city>.'
    sample_long_desc = "Accurate 10 Day Weather Forecasts for thousands of places around the World.\n" \
      'We provide detailed Weather Forecasts over a 10 day period updated four times a day.'

    help_attrs.command(sample_title) do
      desc sample_desc
      long_desc sample_long_desc
    end

    expect(help_attrs.commands.count).to eq(1)
    command = help_attrs.commands.first
    expect(command.command_name).to eq(sample_title)
    expect(command.command_desc).to eq(sample_desc)
    expect(command.command_long_desc).to eq(sample_long_desc)
  end
end
