# frozen_string_literal: true

class Comment < ApplicationRecord
  validates :author, presence: true, length: { maximum: 50 }
  validates :content, presence: true, length: { maximum: 500 }
  validates :post, presence: true
  belongs_to :post
end
