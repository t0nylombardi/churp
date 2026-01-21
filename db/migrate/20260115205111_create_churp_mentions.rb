# frozen_string_literal: true

class CreateChurpMentions < ActiveRecord::Migration[8.1]
  def change
    create_table :churp_mentions, id: :uuid do |t|
      # churp_mentions
      t.uuid :churp_id, null: false
      t.uuid :mentioned_user_id, null: false

      t.integer :start_index, null: false
      t.integer :end_index, null: false

      t.timestamps
    end

    add_foreign_key :churp_mentions, :churps,
      column: :churp_id,
      on_delete: :cascade

    add_foreign_key :churp_mentions, :users,
      column: :mentioned_user_id,
      on_delete: :cascade

    add_index :churp_mentions,
      [:churp_id, :mentioned_user_id],
      unique: true

    add_index :churp_mentions, :mentioned_user_id
  end
end
