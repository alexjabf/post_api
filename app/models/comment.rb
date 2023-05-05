# frozen_string_literal: true

class Comment < ApplicationRecord
  validates :author, presence: true, length: { maximum: 50 }
  validates :content, presence: true, length: { maximum: 500 }
  validates :post, presence: true
  belongs_to :post
  after_create :increment_comments_count
  after_destroy :decrement_comments_count
  scope :by_post, lambda { |post_id|
    post_id.present? ? where(post_id:) : all
  }

  def increment_comments_count
    post.increment_comments_count!
  end

  def decrement_comments_count
    post.decrement_comments_count!
  end
end
