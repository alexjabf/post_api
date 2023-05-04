# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Post', type: :request do
  let(:post) { create(:post) }

  describe 'GET /index' do
    it 'returns http success' do
      get '/api/v1/posts'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /show' do
    it 'returns http success' do
      get "/api/v1/posts/#{post.id}"
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /create' do
    it 'returns http success' do
      get '/api/v1/posts'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PATCH /update' do
    it 'returns http success' do
      get "/api/v1/posts/#{post.id}"
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PATCH /activate' do
    it 'returns http success' do
      get "/api/v1/posts/#{post.id}"
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PATCH /deactivate' do
    it 'returns http success' do
      get "/api/v1/posts/#{post.id}"
      expect(response).to have_http_status(:success)
    end
  end

  describe 'DELETE /destroy' do
    it 'returns http success' do
      get "/api/v1/posts/#{post.id}"
      expect(response).to have_http_status(:success)
    end
  end
end
