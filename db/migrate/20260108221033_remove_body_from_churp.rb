# frozen_string_literal: true

class RemoveBodyFromChurp < ActiveRecord::Migration[8.1]
  def change
    remove_column :churps, :body, :text
  end
end
