# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    author { Faker::Name.name }
    content { Faker::Lorem.paragraph(sentence_count: 2) }
    post
  end
end
