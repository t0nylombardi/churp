# frozen_string_literal: true

class AddContentColmnToChurp < ActiveRecord::Migration[8.1]
  def change
    add_column :churps, :content, :jsonb, null: false, default: {}
  end
end
