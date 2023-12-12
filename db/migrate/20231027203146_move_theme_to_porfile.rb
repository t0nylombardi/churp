# frozen_string_literal: true

class MoveThemeToPorfile < ActiveRecord::Migration[7.1]
  def up
    change_table :users, bulk: true do |t|
      t.remove :theme
      t.remove :theme_color
    end

    change_table :profiles, bulk: true do |t|
      t.integer :theme, default: 0
      t.integer :theme_color, default: 0
    end
  end

  def down
    change_table :users, bulk: true do |t|
      t.string :theme
      t.string :theme_color
    end

    change_table :profiles, bulk: true do |t|
      t.remove :theme, :integer, default: 0
      t.remove :theme_color, :integer, default: 0
    end
  end
end
