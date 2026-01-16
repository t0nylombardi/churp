class AddIndexToChurpHashtags < ActiveRecord::Migration[8.1]
  def change
    add_index :churp_hash_tags, [:churp_id, :hash_tag_id], unique: true
  end
end
