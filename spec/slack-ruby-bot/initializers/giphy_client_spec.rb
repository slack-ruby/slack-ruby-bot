# frozen_string_literal: true

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
    context 'rated pg' do
      before do
        Giphy.config.rating = 'PG'
      end
      after do
        Giphy.config.rating = 'G'
      end
      let(:burrito_gif) { 'https://media0.giphy.com/media/3o6gb3OJb2tWB76uwE/giphy.gif' }
      it 'random', vcr: { cassette_name: 'giphy_client_burrito_rated_pg' } do
        expect(Giphy.random('burrito').image_url).to eq burrito_gif
      end
    end
  end
end
