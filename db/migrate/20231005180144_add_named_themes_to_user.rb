# frozen_string_literal: true

class AddNamedThemesToUser < ActiveRecord::Migration[7.0]
  def change
    change_table :users, bulk: true do |t|
      t.string :username, unique: true
      t.string :display_name, null: true
      t.string :slug, null: true
      t.integer :theme, :integer, default: 0
      t.integer :users, :theme_color, :integer, default: 0
    end

    add_index :users, :username
    add_index :users, :display_name
    add_index :users, :slug
    add_index :users, :slug, unique: true
  end
end
