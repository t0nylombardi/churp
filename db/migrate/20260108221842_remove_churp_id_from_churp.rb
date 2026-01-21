# frozen_string_literal: true

class RemoveChurpIdFromChurp < ActiveRecord::Migration[8.1]
  def up
    remove_column :churps, :churp_id

    add_column :churps, :original_churp_id, :uuid, null: true
    add_index :churps, :original_churp_id
    add_foreign_key :churps, :churps, column: :original_churp_id
  end

  def down
    add_column :churps, :churp_id, :uuid, null: false
    add_index :churps, :churp_id
    add_foreign_key :churps, :churps, column: :churp_id

    remove_foreign_key :churps, column: :original_churp_id
    remove_index :churps, :original_churp_id
    remove_column :churps, :original_churp_id
  end
end
