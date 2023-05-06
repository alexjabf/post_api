# frozen_string_literal: true

# frozen_string literal: true

require 'rails_helper'

RSpec.describe ReplySerializer do
  let(:post) { create(:post) }
  let(:parent_comment) { create(:comment, post:) }
  let(:reply) { create(:comment, parent_comment:, post:) }
  let(:serializer) { described_class.new(reply) }
  let(:serialization) { serializer.serializable_hash }

  describe 'data' do
    it 'has a type of reply' do
      expect(serialization[:data][:type]).to eq(:replies)
    end

    it 'has an id' do
      expect(serialization[:data][:id]).to eq(reply.id.to_s)
    end

    it 'includes expected attributes' do
      expect(serialization[:data][:attributes][:id]).to eq(reply.id)
      expect(serialization[:data][:attributes][:author]).to eq(reply.author)
      expect(serialization[:data][:attributes][:content]).to eq(reply.content)
      expect(serialization[:data][:attributes][:created_at]).to eq(reply.created_at)
      expect(serialization[:data][:attributes][:updated_at]).to eq(reply.updated_at)
      expect(serialization[:data][:attributes][:post_id]).to eq(reply.post_id)
      expect(serialization[:data][:attributes][:parent_comment_id]).to eq(reply.parent_comment_id)
      expect(serialization[:data][:attributes][:post]).to eq(post)
      expect(serialization[:data][:attributes][:parent_comment]).to eq(parent_comment)
    end

    it 'includes expected associations' do
      comments_data = { id: post.id.to_s, type: :posts }
      expect(serialization[:data][:relationships][:post][:data]).to eq(comments_data)
      parent_comments_data = { id: parent_comment.id.to_s,  type: :comments }
      expect(serialization[:data][:relationships][:parent_comment][:data]).to eq(parent_comments_data)
    end
  end
end
