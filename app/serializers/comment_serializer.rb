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
class CommentSerializer
  include JSONAPI::Serializer

  set_type :comments
  attributes :id, :post_id, :author, :content, :created_at, :updated_at

  has_many :replies
  has_one :post, serializer: PostSerializer

  attribute :post, :replies

  cache_options store: Rails.cache, namespace: 'jsonapi-serializer', expires_in: 1.hour
end
