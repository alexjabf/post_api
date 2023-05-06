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
class PostSerializer
  include JSONAPI::Serializer

  set_type :posts
  attributes :id, :author, :content, :comments_count, :created_at, :updated_at

  has_many :comments, serializer: CommentSerializer
  has_many :replies, serializer: ReplySerializer

  attribute :comments do |comment|
    comment.as_json(include: :replies)
  end

  cache_options store: Rails.cache, namespace: 'jsonapi-serializer', expires_in: 1.hour
end
