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
class ReplySerializer
  include JSONAPI::Serializer

  set_type :replies
  attributes :id, :post_id, :parent_comment_id, :author, :content, :created_at, :updated_at

  belongs_to :parent_comment, class_name: 'Comment', optional: true, serializer: CommentSerializer
  belongs_to :post, serializer: PostSerializer

  attribute :post, :parent_comment

  cache_options store: Rails.cache, namespace: 'jsonapi-serializer', expires_in: 1.hour
end
