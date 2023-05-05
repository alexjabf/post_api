# frozen_string_literal: true

# frozen_string literal: true

require 'rails_helper'

RSpec.describe PostSerializer do
  let(:post) { create(:post) }
  let(:serializer) { described_class.new(post) }
  let(:serialization) { serializer.serializable_hash }

  describe 'data' do
    it 'has a type of post' do
      expect(serialization[:data][:type]).to eq(:posts)
    end

    it 'has an id' do
      expect(serialization[:data][:id]).to eq(post.id.to_s)
    end

    it 'includes expected attributes' do
      expect(serialization[:data][:attributes][:id]).to eq(post.id)
      expect(serialization[:data][:attributes][:author]).to eq(post.author)
      expect(serialization[:data][:attributes][:content]).to eq(post.content)
      expect(serialization[:data][:attributes][:comments_count]).to eq(post.comments_count)
      expect(serialization[:data][:attributes][:created_at]).to eq(post.created_at)
      expect(serialization[:data][:attributes][:updated_at]).to eq(post.updated_at)
    end

    it 'includes expected associations' do
      comments_data = post.comments.map { |comment| { id: comment.id.to_s, type: 'comments' } }
      expect(serialization[:data][:relationships][:comments][:data]).to eq(comments_data)
      replies_data = post.comments.map { |comment| { id: comment.id.to_s, type: 'replies' } }
      expect(serialization[:data][:relationships][:replies][:data]).to eq(replies_data)
    end
  end
end
