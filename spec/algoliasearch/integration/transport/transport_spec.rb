require 'algoliasearch'

include CallType, RetryOutcomeType
RSpec.describe Algolia::Transport::Transport, type: :request do
  context 'when using the transport layer' do
    let(:app_id) { ENV['ALGOLIA_APPLICATION_ID'] }
    let(:api_key) { ENV['ALGOLIA_API_KEY'] }
    let(:config) { Algolia::Search::Config.new(app_id: app_id, api_key: api_key, user_agent: 'test-ruby') }
    let(:transport) { described_class.new(config) }
    let(:indexes_uri) { "/#{Defaults::VERSION}/indexes" }

    it 'request succeeds' do
      response = transport.read(:GET, indexes_uri)

      expect(response['items']).not_to be nil
    end

    it 'request fails with wrong credentials' do
      custom_headers = {
        Defaults::HEADER_API_KEY => 'xxxxxxx',
        Defaults::HEADER_APP_ID => 'XXXX'
      }

      expect do
        transport.read(:GET, indexes_uri, opts: {headers: custom_headers})
      end.to raise_error(Algolia::AlgoliaApiError, 'Invalid Application-ID or API key')
    end
  end
end
