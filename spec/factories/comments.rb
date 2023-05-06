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
FactoryBot.define do
  factory :comment do
    author { Faker::Name.name }
    content { Faker::Lorem.paragraph(sentence_count: 2) }
    post
  end
end
