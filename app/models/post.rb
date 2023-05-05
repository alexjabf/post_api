# frozen_string_literal: true

class Post < ApplicationRecord
  validates :author, presence: true, length: { maximum: 50 }
  validates :content, presence: true, length: { maximum: 500 }
  has_many :comments, dependent: :destroy
  accepts_nested_attributes_for :comments
end
