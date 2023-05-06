# frozen_string_literal: true

# == Schema Information
#
# Table name: posts
#
#  id             :bigint           not null, primary key
#  author         :string(50)       not null
#  content        :string(500)      not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  comments_count :integer          default(0), not null
#
class Post < ApplicationRecord
  validates :author, presence: true, length: { maximum: 50 }
  validates :content, presence: true, length: { maximum: 500 }
  has_many :comments, -> { where(parent_comment_id: nil) }, dependent: :destroy
  has_many :replies, through: :comments, source: :replies
  accepts_nested_attributes_for :comments, allow_destroy: true

  # We use a scope to eager load the comments and filter out the comments that are replies since
  # those are already included in the comments.
  scope :post_comments, lambda { |order_by = 'posts.id', order_type = 'DESC'|
    order_by = ActiveRecord::Base.sanitize_sql(order_by)
    order_type = ActiveRecord::Base.sanitize_sql(order_type)
    data = where(comments: { parent_comment_id: nil })
    data.includes(:comments, :replies).order("#{order_by} #{order_type}")
  }

  # We ise with_lock for the increment and decrement methods to ensure that the
  # comments_count is updated correctly if multiple requests are made at the same
  # time and avoid race conditions.
  def increment_comments_count!
    with_lock do
      increment!(:comments_count)
    end
  end

  def decrement_comments_count!
    with_lock do
      decrement!(:comments_count)
    end
  end
end
