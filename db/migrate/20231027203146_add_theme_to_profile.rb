# frozen_string_literal: true

class AddThemeToProfile < ActiveRecord::Migration[8.1]
  def change
    change_table :profiles, bulk: true do |t|
      t.integer :theme, default: 0
      t.integer :theme_color, default: 0
    end
  end
end
