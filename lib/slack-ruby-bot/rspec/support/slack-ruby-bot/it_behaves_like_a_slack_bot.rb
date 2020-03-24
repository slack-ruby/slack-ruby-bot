shared_examples 'a slack ruby bot' do
  context 'not configured' do
    before do
      @slack_api_token = ENV.delete('SLACK_API_TOKEN')
    end
    after do
      ENV['SLACK_API_TOKEN'] = @slack_api_token
    end
    it 'requires SLACK_API_TOKEN' do
      expect { subject }.to raise_error RuntimeError, "Missing ENV['SLACK_API_TOKEN']."
    end
  end
end
