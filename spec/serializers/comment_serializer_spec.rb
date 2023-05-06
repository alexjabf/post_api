# frozen_string_literal: true

# frozen_string literal: true

require 'rails_helper'

RSpec.describe CommentSerializer do
  let(:post) { create(:post) }
  let(:comment) { create(:comment, post:) }
  let(:replies) { create_list(:comment, 5, parent_comment: comment, post:) }
  let(:serializer) { described_class.new(comment.reload) }
  let(:serialization) { serializer.serializable_hash }

  describe 'data' do
    it 'has a type of comments' do
      expect(serialization[:data][:type]).to eq(:comments)
    end

    it 'has an id' do
      expect(serialization[:data][:id]).to eq(comment.id.to_s)
    end

    it 'includes expected attributes' do
      expect(serialization[:data][:attributes][:id]).to eq(comment.id)
      expect(serialization[:data][:attributes][:author]).to eq(comment.author)
      expect(serialization[:data][:attributes][:content]).to eq(comment.content)
      expect(serialization[:data][:attributes][:created_at]).to eq(comment.created_at)
      expect(serialization[:data][:attributes][:updated_at]).to eq(comment.updated_at)
      expect(serialization[:data][:attributes][:post_id]).to eq(post.id)
      expect(serialization[:data][:attributes][:parent_comment_id]).to be_nil
      expect(serialization[:data][:attributes][:post]).to eq(post)
      expect(serialization[:data][:attributes][:replies]).to eq(replies)
    end

    it 'includes expected associations' do
      comments_data = { id: post.id.to_s, type: :posts }
      expect(serialization[:data][:relationships][:post][:data]).to eq(comments_data)
      replies_data = comment.replies.map { |comment| { id: comment.id.to_s, type: 'replies' } }
      expect(serialization[:data][:relationships][:replies][:data]).to eq(replies_data)
    end
  end
end
