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
class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :parent_comment, class_name: 'Comment', optional: true
  has_many :replies, class_name: 'Comment', foreign_key: :parent_comment_id, dependent: :destroy
  accepts_nested_attributes_for :replies, allow_destroy: true

  validates :author, presence: true, length: { maximum: 50 }
  validates :content, presence: true, length: { maximum: 500 }
  validates :post, presence: true

  after_save :increment_comments_count
  after_destroy :decrement_comments_count

  before_validation :assign_post_id_to_replies, if: -> { replies.present? }
  validate :parent_comment_exists, if: -> { parent_comment_id.present? }

  scope :by_post, lambda { |post_id, order_by = 'comments.id', order_type = 'DESC'|
    order_by = ActiveRecord::Base.sanitize_sql(order_by)
    order_type = ActiveRecord::Base.sanitize_sql(order_type)
    data = post_id.present? ? where(post_id:) : all
    data.includes(:replies, :post).order("#{order_by} #{order_type}")
  }

  private

  def parent_comment_exists
    return unless parent_comment_id.present? && !Comment.exists?(parent_comment_id)

    errors.add(:parent_comment_id, "can't be blank")
  end

  def assign_post_id_to_replies
    replies.each { |reply| reply.post_id = post_id }
  end

  def increment_comments_count
    post.increment_comments_count!
  end

  def decrement_comments_count
    post.decrement_comments_count!
  end
end
