require 'slack-ruby-bot'
require 'yahoo-finance'

SlackRubyBot::Client.logger.level = Logger::WARN

class MarketBot < SlackRubyBot::Bot
  scan(/([A-Z]{2,5}+)/) do |client, data, stocks|
    YahooFinance::Client.new.quotes(stocks, [:name, :symbol, :last_trade_price, :change, :change_in_percent]).each do |quote|
      next if quote.symbol == 'N/A'
      client.web_client.chat_postMessage(
        channel: data.channel,
        as_user: true,
        attachments: [
          {
            fallback: "#{quote.name} (#{quote.symbol}): $#{quote.last_trade_price}",
            title: "#{quote.name} (#{quote.symbol})",
            text: "$#{quote.last_trade_price} (#{quote.change_in_percent})",
            color: quote.change.to_f > 0 ? '#00FF00' : '#FF0000'
          }
        ]
      )
    end
  end
end

MarketBot.run
