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
FactoryBot.define do
  factory :post do
    author { Faker::Name.name }
    content { Faker::Lorem.paragraph(sentence_count: 10) }
  end
end
