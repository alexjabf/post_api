# frozen_string_literal: true

class AddParentCommentIdToComments < ActiveRecord::Migration[7.0]
  def change
    add_column :comments, :parent_comment_id, :integer
  end
end
