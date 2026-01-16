class AddProfileImagesToJsonbMedia < ActiveRecord::Migration[8.1]
  def change
    add_column :profiles, :avatar, :jsonb, null: false, default: {}
    add_column :profiles, :cover, :jsonb, null: false, default: {}
  end

  add_index :profiles, :avatar, using: :gin
  add_index :profiles, :cover, using: :gin
end
