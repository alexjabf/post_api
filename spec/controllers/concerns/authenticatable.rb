# frozen_string_literal: true

RSpec.shared_context 'authenticatable', :authenticatable do |username, password|
  before do
    username ||= 'username'
    password ||= 'password'

    allow(ENV).to receive(:fetch).with('API_USERNAME', nil).and_return('username')
    allow(ENV).to receive(:fetch).with('API_PASSWORD', nil).and_return('password')

    credentials = ActionController::HttpAuthentication::Basic.encode_credentials(username, password)
    request.headers['Authorization'] = credentials
  end
end
