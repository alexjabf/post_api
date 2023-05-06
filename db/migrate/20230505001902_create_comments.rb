# frozen_string_literal: true

class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.references :post, null: false, foreign_key: true
      t.string :author, null: false, limit: 50
      t.string :content, null: false, limit: 500

      t.timestamps
    end

    # We add indexes to columns that we will be searching on frequently to improve performance
    add_index :comments, :author
  end
end
