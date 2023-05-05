# frozen_string_literal: true

# frozen_string_literal:

require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    def index
      raise ActiveRecord::RecordNotFound, 'Not Found'
    end
  end

  describe 'rescue_from ActiveRecord::RecordNotFound' do
    it 'returns a 404 response' do
      get :index
      expect(response).to have_http_status(:not_found)
    end

    it 'returns a JSON error message' do
      get :index
      expect(JSON.parse(response.body)).to eq({ 'error' => 'Not Found' })
    end
  end
end
