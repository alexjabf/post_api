# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  let!(:post) { create(:post) }
  let(:valid_attributes) { { author: 'Alex Fierro', content: 'My first comment', post: } }
  let(:invalid_attributes) { { author: '', content: '' } }
  let(:comments) { create_list(:comment, 10) }

  describe 'validations' do
    it { should validate_presence_of(:post) }
    it { should validate_presence_of(:author) }
    it { should validate_length_of(:author).is_at_most(50) }
    it { should validate_presence_of(:content) }
    it { should validate_length_of(:content).is_at_most(500) }
  end

  describe 'read all records' do
    it 'returns all records' do
      expect(Comment.all).to match_array(comments)
    end
  end

  describe 'association with post' do
    let!(:comment) { create(:comment, post:) }

    it 'belongs to a post' do
      expect(comment.post).to eq(post)
    end

    it 'adds comment to post' do
      expect(post.comments.count).to eq(1)
      expect(post.comments.first).to eq(comment)
    end
  end

  describe '.by_post' do
    let!(:post1) { create(:post) }
    let!(:post2) { create(:post) }
    let!(:comment1) { create(:comment, post: post1) }
    let!(:comment2) { create(:comment, post: post2) }

    it 'should return all comments if no post_id is provided' do
      expect(Comment.by_post(nil)).to match_array([comment1, comment2])
    end

    it 'should return only comments for the specified post if a post_id is provided' do
      expect(Comment.by_post(post1.id)).to match_array([comment1])
      expect(Comment.by_post(post2.id)).to match_array([comment2])
    end
  end

  describe 'CRUD operations' do
    it 'can be created' do
      comment = Comment.new(valid_attributes)
      expect(comment.save).to eq(true)
    end

    it 'can be read' do
      comment = Comment.create(valid_attributes)
      expect(Comment.find(comment.id)).to eq(comment)
    end

    it 'can be updated' do
      comment = Comment.create(valid_attributes)
      comment.update(author: 'Alex Fierro')
      expect(Comment.find(comment.id).author).to eq('Alex Fierro')
    end

    it 'can be deleted' do
      comment = Comment.create(valid_attributes)
      comment.destroy
      expect(Comment.find_by(id: comment.id)).to be_nil
    end
  end

  describe '#increment_comments_count' do
    let(:post) { create(:post) }

    it 'should increment the comments_count attribute on the associated post' do
      expect do
        create(:comment, post:)
      end.to change { post.reload.comments_count }.by(1)
    end
  end

  describe '#decrement_comments_count' do
    let(:post) { create(:post) }
    let!(:comment) { create(:comment, post:) }

    it 'should decrement the comments_count attribute on the associated post' do
      expect do
        comment.destroy
      end.to change { post.reload.comments_count }.by(-1)
    end
  end
end
