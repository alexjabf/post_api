# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    author { Faker::Name.name }
    content { Faker::Lorem.paragraph(sentence_count: 10) }
  end
end
