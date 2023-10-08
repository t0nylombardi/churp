class AddNamedThemesToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :username, :string, index: true, unique: true
    add_column :users, :display_name, :string, index: true
    add_column :users, :slug, :string, index: true
    add_column :users, :theme, :integer, default: 0
    add_column :users, :theme_color, :integer, default: 0

    add_index :users, :slug, unique: true
  end
end
