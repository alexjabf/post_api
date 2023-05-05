# frozen_string_literal: true

class Post < ApplicationRecord
  validates :author, presence: true, length: { maximum: 50 }
  validates :content, presence: true, length: { maximum: 500 }
  has_many :comments, dependent: :destroy
  accepts_nested_attributes_for :comments, allow_destroy: true

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
