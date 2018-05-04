if ENV.key?('WITH_GIPHY')
  describe Giphy do
    let(:burrito_gif) { 'https://media3.giphy.com/media/xTiTndNDuNFxUW5Xoc/giphy.gif' }
    before do
      Giphy::Configuration.configure do |config|
        config.api_key = 'giphy-api-key'
      end
    end
    after do
      Giphy::Configuration.configure do |config|
        config.api_key = ENV['GIPHY_API_KEY']
      end
    end
    it 'random', vcr: { cassette_name: 'giphy_burrito' } do
      expect(Giphy.random('burrito').image_url.to_s).to eq burrito_gif
    end
  end
end
