# frozen_string_literal: true

class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.string :author, null: false, limit: 50
      t.string :content, null: false, limit: 500

      t.timestamps
    end

    # We add indexes to columns that we will be searching on frequently to improve performance
    add_index :posts, :author
  end
end
