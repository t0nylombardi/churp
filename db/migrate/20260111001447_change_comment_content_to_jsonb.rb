# frozen_string_literal: true

class ChangeCommentContentToJsonb < ActiveRecord::Migration[8.1]
  def up
    change_column :comments, :content, :jsonb, using: "content::jsonb", default: {}
  end

  def down
    change_column :comments, :content, :text, using: "content::text"
  end
end
