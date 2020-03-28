# frozen_string_literal: true

require 'iex-ruby-client'
require 'slack-ruby-bot'

SlackRubyBot::Client.logger.level = Logger::WARN

class MarketBot < SlackRubyBot::Bot
  scan(/([A-Z]{2,5}+)/) do |client, data, stocks|
    stocks.each do |stock|
      begin
        quote = IEX::Resources::Quote.get(stock.first)

        client.web_client.chat_postMessage(
          channel: data.channel,
          as_user: true,
          attachments: [
            {
              fallback: "#{quote.company_name} (#{quote.symbol}): $#{quote.latest_price}",
              title: "#{quote.company_name} (#{quote.symbol})",
              text: "$#{quote.latest_price} (#{quote.change_percent})",
              color: quote.change.to_f > 0 ? '#00FF00' : '#FF0000'
            }
          ]
        )
      rescue IEX::Errors::SymbolNotFoundError
        logger.warn "no stock found for symbol #{stock}"
      end
    end
  end
end

MarketBot.run
