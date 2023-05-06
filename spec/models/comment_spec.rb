# frozen_string_literal: true

# == Schema Information
#
# Table name: comments
#
#  id                :bigint           not null, primary key
#  post_id           :bigint           not null
#  author            :string(50)       not null
#  content           :string(500)      not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  parent_comment_id :integer
#
require 'rails_helper'

RSpec.describe Comment, type: :model do
  let!(:post) { create(:post) }
  let(:valid_attributes) { { author: 'Alex Fierro', content: 'My first comment', post: } }
  let(:invalid_attributes) { { author: '', content: '' } }
  let(:comments) { create_list(:comment, 10) }
  let(:comment) { create(:comment, post:) }
  let(:child_comment) { build(:comment, parent_comment: comment, post:) }

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

  describe 'post association' do
    let!(:comment) { create(:comment, post:) }

    it { should belong_to(:post).class_name('Post') }

    it 'belongs to a post' do
      expect(comment.post).to eq(post)
    end

    it 'adds comment to post' do
      expect(post.comments.count).to eq(1)
      expect(post.comments.first).to eq(comment)
    end
  end

  describe 'replies associations' do
    it { should belong_to(:parent_comment).class_name('Comment').optional }
    it { should have_many(:replies).class_name('Comment').dependent(:destroy) }
  end

  describe 'create child comment' do
    context 'when parent comment exists' do
      it 'creates the child comment' do
        expect { child_comment.save }.to change { comment.replies.count }.by(1)
      end
    end

    context 'when parent comment does not exist' do
      before { child_comment.parent_comment_id = 10_000 }

      it 'does not create the child comment' do
        expect { child_comment.save }.not_to change(Comment, :count)
      end

      it 'adds an error to the child comment' do
        child_comment.save
        expect(child_comment.errors[:parent_comment_id]).to include("can't be blank")
      end
    end
  end

  describe '#parent_comment_exists' do
    context 'when parent_comment_id is present and does not exist' do
      let(:comment) { build(:comment, parent_comment_id: 9999) }

      it 'adds an error to the parent_comment_id attribute' do
        comment.validate
        expect(comment.errors[:parent_comment_id]).to include("can't be blank")
      end
    end

    context 'when parent_comment_id is present and exists' do
      let(:parent_comment) { create(:comment) }
      let(:comment) { build(:comment, parent_comment_id: parent_comment.id) }

      it 'does not add an error to the parent_comment_id attribute' do
        comment.validate
        expect(comment.errors[:parent_comment_id]).to be_empty
      end
    end

    context 'when parent_comment_id is not present' do
      let(:comment) { build(:comment, parent_comment_id: nil) }

      it 'does not add an error to the parent_comment_id attribute' do
        comment.validate
        expect(comment.errors[:parent_comment_id]).to be_empty
      end
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
