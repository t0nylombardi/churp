class AddUsageCountToHashTags < ActiveRecord::Migration[8.1]
  def change
    add_column :hash_tags, :usage_count, :integer, null: false, default: 0
  end
end
