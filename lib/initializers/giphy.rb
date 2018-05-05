begin
  require 'giphy'
rescue LoadError
else
  Giphy::Configuration.configure do |config|
    config.api_key = ENV['GIPHY_API_KEY']
  end
end
