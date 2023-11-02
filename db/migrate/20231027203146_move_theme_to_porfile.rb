class MoveThemeToPorfile < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :theme
    remove_column :users, :theme_color
    # add columns to profile
    add_column :profiles, :theme, :integer, default: 0
    add_column :profiles, :theme_color, :integer, default: 0
  end
end
