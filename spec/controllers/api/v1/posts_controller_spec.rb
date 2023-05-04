# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::PostsController, type: :controller do
  describe 'GET #index' do
    let!(:posts) { create_list(:post, 20) }

    it 'returns a success response' do
      get :index, format: :json
      expect(response).to be_successful
    end

    it 'returns the first page of posts by default' do
      get :index, format: :json
      expect(JSON.parse(response.body).size).to eq(10)
    end

    it 'returns the requested page of posts' do
      get :index, params: { page: 2 }, format: :json
      expect(JSON.parse(response.body).size).to eq(10)
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
      expect(JSON.parse(response.body)['post']['id']).to eq(post.id)
    end
  end

  describe 'POST #create' do
    let(:valid_attributes) { attributes_for(:post) }
    let(:invalid_attributes) { attributes_for(:post, author: nil) }

    context 'with valid parameters' do
      it 'creates a new post' do
        expect do
          post :create, params: { post: valid_attributes }, format: :json
        end.to change(Post, :count).by(1)
      end

      it 'returns a success response with the created post' do
        post :create, params: { post: valid_attributes }, format: :json
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['id']).not_to be_nil
      end
    end

    context 'with invalid parameters' do
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
  end

  describe 'PUT #update' do
    let!(:post) { create(:post) }
    let(:new_attributes) { attributes_for(:post, author: 'Alex Fierro') }
    let(:invalid_attributes) { attributes_for(:post, author: nil) }

    context 'with valid parameters' do
      it 'updates the requested post' do
        put :update, params: { id: post.id, post: new_attributes }, format: :json
        post.reload
        expect(post.author).to eq('Alex Fierro')
      end

      it 'returns a success response with the updated post' do
        put :update, params: { id: post.id, post: new_attributes }, format: :json
        expect(response).to be_successful
        expect(JSON.parse(response.body)['id']).to eq(post.id)
      end
    end

    context 'with invalid parameters' do
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
  end

  describe 'DELETE #destroy' do
    let!(:post) { create(:post) }
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
end
