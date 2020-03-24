if ENV.key?('WITH_GIPHY_CLIENT')
  describe Giphy do
    before do
      ENV['GIPHY_API_KEY'] = 'giphy-api-key'
    end
    after do
      ENV.delete('GIPHY_API_KEY')
    end
    context 'rated g' do
      let(:burrito_gif) { 'https://media2.giphy.com/media/ImpBgQl7zzrO0/giphy.gif' }
      it 'random', vcr: { cassette_name: 'giphy_client_burrito' } do
        expect(Giphy.random('burrito').image_url).to eq burrito_gif
      end
    end
    context 'rated y' do
      before do
        Giphy.config.rating = 'Y'
      end
      after do
        Giphy.config.rating = 'G'
      end
      let(:burrito_gif) { 'https://media3.giphy.com/media/hkdKLmIgB3ane/giphy.gif' }
      it 'random', vcr: { cassette_name: 'giphy_client_burrito_rated_y' } do
        expect(Giphy.random('burrito').image_url).to eq burrito_gif
      end
    end
  end
end
