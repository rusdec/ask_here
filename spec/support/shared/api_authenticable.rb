# These let api_authenticable must be declared
#   @let api_authenticable [Hash]
#     @param request_type [Symbol] the requst type `:get`, `:post`, `:put` or `:patch`
#     @param uri [String] the path for reqest
#     @param options [Hash] the other options of request

shared_examples_for 'API authenticable' do
  given(:request_type) { api_authenticable[:request_type] }
  given(:options) { api_authenticable[:options] }
  given(:request_uri) { api_authenticable[:request_uri] }
  before { options[:params] ||= {} }

  context 'when unauthenticated' do
    context 'and access_token is not given' do
      it 'returns status 401' do
        send request_type, request_uri, options
        expect(response.status).to eq(401)
      end
    end

    context 'and access_token is invalid' do
      it 'returns status 401' do
        options[:params][:access_token] = 'invalid_token'
        send request_type, request_uri, options
        expect(response.status).to eq(401)
      end
    end
  end

  context 'when authenticated' do
    it 'returns status 200' do
      options[:params][:access_token] = create(:access_token,
                                               resource_owner_id: create(:user).id).token
      send request_type, request_uri, options
      expect(response).to be_successful
    end
  end
end
