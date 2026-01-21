class AddIndexToHashtags < ActiveRecord::Migration[8.1]
  def change
    add_index :hash_tags, :name, unique: true
  end
end
