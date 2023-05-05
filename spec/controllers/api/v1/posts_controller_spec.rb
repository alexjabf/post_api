# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::PostsController, type: :controller do
  describe 'GET #index' do
    let!(:posts) { create_list(:post, 20) }

    context 'without pagination' do
      before { get :index, format: :json }

      it 'returns a success response' do
        expect(response).to be_successful
      end

      it 'returns the first page of posts by default' do
        expect(JSON.parse(response.body)['data'].size).to eq(20)
      end
    end

    context 'with pagination' do
      before { get :index, params: { page: 2, per_page: 10 }, format: :json }

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns the requested page of posts' do
        expect(JSON.parse(response.body)['data'].size).to eq(10)
      end

      it 'returns posts in the correct order' do
        expected_order = Post.order(created_at: :asc).offset(10).limit(10).pluck(:id)
        expect(JSON.parse(response.body)['data'].pluck('id').map(&:to_i)).to eq(expected_order)
      end
    end
  end

  describe 'GET #show' do
    let!(:post) { create(:post) }

    it 'returns a success response' do
      get :show, params: { id: post.id }, format: :json
      expect(response).to be_successful
    end

    it 'returns the requested post' do
      get :show, params: { id: post.id }, format: :json
      expect(JSON.parse(response.body)['data']['id'].to_i).to eq(post.id)
    end
  end

  describe 'POST #create' do
    let(:valid_attributes) { attributes_for(:post) }
    let(:invalid_attributes) { attributes_for(:post, author: nil) }

    context 'with valid parameters' do
      include_context 'authenticatable'

      it 'creates a new post' do
        expect do
          post :create, params: { post: valid_attributes }, format: :json
        end.to change(Post, :count).by(1)
      end

      it 'returns a success response with the created post' do
        post :create, params: { post: valid_attributes }, format: :json
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['data']['id']).not_to be_nil
      end
    end

    context 'with invalid parameters' do
      include_context 'authenticatable'

      it 'does not create a new post' do
        expect do
          post :create, params: { post: invalid_attributes }, format: :json
        end.to change(Post, :count).by(0)
      end

      it 'returns an error response with the validation errors' do
        post :create, params: { post: invalid_attributes }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).not_to be_empty
      end
    end

    context 'when not authenticated' do
      include_context 'authenticatable', 'invalid_username', 'invalid_password'

      it 'returns unauthorized status' do
        post :create, params: { post: valid_attributes }, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PUT #update' do
    let!(:post) { create(:post) }
    let(:new_attributes) { attributes_for(:post, author: 'Alex Fierro') }
    let(:invalid_attributes) { attributes_for(:post, author: nil) }

    context 'with valid parameters' do
      include_context 'authenticatable'

      it 'updates the requested post' do
        put :update, params: { id: post.id, post: new_attributes }, format: :json
        post.reload
        expect(post.author).to eq('Alex Fierro')
      end

      it 'returns a success response with the updated post' do
        put :update, params: { id: post.id, post: new_attributes }, format: :json
        expect(response).to be_successful
        expect(JSON.parse(response.body)['data']['id'].to_i).to eq(post.id)
      end
    end

    context 'with invalid parameters' do
      include_context 'authenticatable'

      it 'does not create a new post' do
        expect do
          put :update, params: { id: post.id, post: invalid_attributes }, format: :json
        end.to change(Post, :count).by(0)
      end
      it 'returns an error response with the validation errors' do
        put :update, params: { id: post.id, post: invalid_attributes }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).not_to be_empty
      end
    end

    context 'when not authenticated' do
      include_context 'authenticatable', 'invalid_username', 'invalid_password'

      it 'returns unauthorized status' do
        put :update, params: { id: post.id, post: invalid_attributes }, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:post) { create(:post) }

    context 'with invalid authentication' do
      include_context 'authenticatable'

      it 'destroys the requested post' do
        expect do
          delete :destroy, params: { id: post.id }, format: :json
        end.to change(Post, :count).by(-1)
      end

      it 'returns a success response with no content' do
        delete :destroy, params: { id: post.id }, format: :json
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when not authenticated' do
      include_context 'authenticatable', 'invalid_username', 'invalid_password'

      it 'returns unauthorized status' do
        delete :destroy, params: { id: post.id }, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
