# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:valid_attributes) { { author: 'Alex Fierro', content: 'My first post' } }
  let(:invalid_attributes) { { author: '', content: '' } }
  let(:posts) { create_list(:post, 10) }

  describe 'validations' do
    it { should validate_presence_of(:author) }
    it { should validate_length_of(:author).is_at_most(50) }
    it { should validate_presence_of(:content) }
    it { should validate_length_of(:content).is_at_most(500) }
  end

  describe 'read all records' do
    it 'returns all records' do
      expect(Post.all).to match_array(posts)
    end
  end

  describe 'CRUD operations' do
    it 'can be created' do
      post = Post.new(valid_attributes)
      expect(post.save).to eq(true)
    end

    it 'can be read' do
      post = Post.create(valid_attributes)
      expect(Post.find(post.id)).to eq(post)
    end

    it 'can be updated' do
      post = Post.create(valid_attributes)
      post.update(author: 'Jane Doe')
      expect(Post.find(post.id).author).to eq('Jane Doe')
    end

    it 'can be deleted' do
      post = Post.create(valid_attributes)
      post.destroy
      expect(Post.find_by(id: post.id)).to be_nil
    end
  end
end
