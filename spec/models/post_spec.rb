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

  describe 'accepts_nested_attributes_for :comments' do
    let(:post) { create(:post) }

    it 'should create a new comment when valid nested attributes are provided' do
      expect do
        post.update(comments_attributes: [{ author: 'Alex Fierro', content: 'My first comment' }])
      end.to change { Comment.count }.by(1)
    end

    it 'should update an existing comment when valid nested attributes are provided' do
      comment = create(:comment, post:, author: 'Alex Fierro', content: 'My second comment')

      post.update(comments_attributes: [{ id: comment.id, author: 'Javier Fierro', content: 'Updated comment' }])

      comment.reload
      expect(comment.author).to eq('Javier Fierro')
      expect(comment.content).to eq('Updated comment')
    end

    it 'should delete a comment when the _destroy flag is set to true' do
      comment = create(:comment, post:)

      expect do
        post.update(comments_attributes: [{ id: comment.id, _destroy: true }])
      end.to change { Comment.count }.by(-1)
    end

    it 'should not create a new comment when invalid nested attributes are provided' do
      expect do
        post.update(comments_attributes: [{ author: nil, content: nil }])
      end.not_to(change { Comment.count })
    end
  end

  describe 'read all records' do
    it 'returns all records' do
      expect(Post.all).to match_array(posts)
    end
  end

  describe 'association with comments' do
    let!(:post) { create(:post) }
    let!(:comment) { create(:comment, post:) }

    it 'has many comments' do
      expect(post.comments).to eq([comment])
    end

    it 'adds comment to post' do
      expect(post.comments.count).to eq(1)
      expect(post.comments.first).to eq(comment)
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
      post.update(author: 'Javier Fierro')
      expect(Post.find(post.id).author).to eq('Javier Fierro')
    end

    it 'can be deleted' do
      post = Post.create(valid_attributes)
      post.destroy
      expect(Post.find_by(id: post.id)).to be_nil
    end
  end

  describe '#increment_comments_count!' do
    let(:post) { create(:post) }

    it 'should increment the comments_count attribute by 1' do
      expect { post.increment_comments_count! }.to change { post.comments_count }.by(1)
    end

    it 'should update the comments_count attribute in the database' do
      expect { post.increment_comments_count! }.to change { post.reload.comments_count }.by(1)
    end
  end

  describe '#decrement_comments_count!' do
    let(:post) { create(:post, comments_count: 3) }

    it 'should decrement the comments_count attribute by 1' do
      expect { post.decrement_comments_count! }.to change { post.comments_count }.by(-1)
    end

    it 'should update the comments_count attribute in the database' do
      expect { post.decrement_comments_count! }.to change { post.reload.comments_count }.by(-1)
    end
  end
end
