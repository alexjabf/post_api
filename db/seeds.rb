# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

100.times do |_n|
  post = Post.create(author: Faker::Name.name, content: Faker::Lorem.paragraph(sentence_count: 10))
  rand(1..10).times.map do
    Comment.create(
      author: Faker::Name.name, content: Faker::Lorem.paragraph(sentence_count: 10), post:,
      replies_attributes: [
        rand(0..5).times.map do
          {
            post:,
            author: Faker::Name.name,
            content: Faker::Lorem.paragraph(sentence_count: 5)
          }
        end
      ].flatten
    )
  end
end
