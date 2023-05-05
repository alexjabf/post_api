# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::CommentsController, type: :controller do
  describe 'GET #index' do
    let!(:comments) { create_list(:comment, 20) }

    context 'without pagination' do
      before { get :index, format: :json }

      it 'returns a success response' do
        expect(response).to be_successful
      end

      it 'returns the first page of comments by default' do
        expect(JSON.parse(response.body)['comments'].size).to eq(20)
      end
    end

    context 'with pagination' do
      before { get :index, params: { page: 2, per_page: 10 }, format: :json }

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns the requested page of comments' do
        expect(JSON.parse(response.body)['comments'].size).to eq(10)
      end

      it 'returns comments in the correct order' do
        expected_order = Comment.order(created_at: :asc).offset(10).limit(10).pluck(:id)
        actual_order = JSON.parse(response.body)['comments'].map { |comment| comment['id'] }
        expect(actual_order).to eq(expected_order)
      end
    end
  end

  describe 'GET #show' do
    let!(:comment) { create(:comment) }

    it 'returns a success response' do
      get :show, params: { id: comment.id }, format: :json
      expect(response).to be_successful
    end

    it 'returns the requested comment' do
      get :show, params: { id: comment.id }, format: :json
      expect(JSON.parse(response.body)['comment']['id']).to eq(comment.id)
    end
  end

  describe 'POST #create' do
    let(:existing_post) { create(:post) }
    let(:valid_attributes) { attributes_for(:comment, post_id: existing_post.id) }
    let(:invalid_attributes) { attributes_for(:comment, author: nil) }

    context 'with valid parameters' do
      include_context 'authenticatable'

      it 'creates a new comment' do
        expect do
          post :create, params: { comment: valid_attributes }, format: :json
        end.to change(Comment, :count).by(1)
      end

      it 'returns a success response with the created comment' do
        post :create, params: { comment: valid_attributes }, format: :json
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['id']).not_to be_nil
      end
    end

    context 'with invalid parameters' do
      include_context 'authenticatable'

      it 'does not create a new comment' do
        expect do
          post :create, params: { comment: invalid_attributes }, format: :json
        end.to change(Comment, :count).by(0)
      end

      it 'returns an error response with the validation errors' do
        post :create, params: { comment: invalid_attributes }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).not_to be_empty
      end
    end

    context 'when not authenticated' do
      include_context 'authenticatable', 'invalid_username', 'invalid_password'

      it 'returns unauthorized status' do
        post :create, params: { comment: valid_attributes }, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PUT #update' do
    let(:post) { create(:post) }
    let!(:comment) { create(:comment) }
    let(:new_attributes) { attributes_for(:comment, author: 'Alex Fierro', post_id: post.id) }
    let(:invalid_attributes) { attributes_for(:comment, author: nil) }

    context 'with valid parameters' do
      include_context 'authenticatable'

      it 'updates the requested comment' do
        put :update, params: { id: comment.id, comment: new_attributes }, format: :json
        comment.reload
        expect(comment.author).to eq('Alex Fierro')
      end

      it 'returns a success response with the updated comment' do
        put :update, params: { id: comment.id, comment: new_attributes }, format: :json
        expect(response).to be_successful
        expect(JSON.parse(response.body)['id']).to eq(comment.id)
      end
    end

    context 'with invalid parameters' do
      include_context 'authenticatable'

      it 'does not create a new comment' do
        expect do
          put :update, params: { id: comment.id, comment: invalid_attributes }, format: :json
        end.to change(Comment, :count).by(0)
      end
      it 'returns an error response with the validation errors' do
        put :update, params: { id: comment.id, comment: invalid_attributes }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).not_to be_empty
      end
    end

    context 'when not authenticated' do
      include_context 'authenticatable', 'invalid_username', 'invalid_password'

      it 'returns unauthorized status' do
        put :update, params: { id: comment.id, comment: invalid_attributes }, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:comment) { create(:comment) }

    context 'with invalid authentication' do
      include_context 'authenticatable'

      it 'destroys the requested comment' do
        expect do
          delete :destroy, params: { id: comment.id }, format: :json
        end.to change(Comment, :count).by(-1)
      end

      it 'returns a success response with no content' do
        delete :destroy, params: { id: comment.id }, format: :json
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when not authenticated' do
      include_context 'authenticatable', 'invalid_username', 'invalid_password'

      it 'returns unauthorized status' do
        delete :destroy, params: { id: comment.id }, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
