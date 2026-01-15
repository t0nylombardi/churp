# frozen_string_literal: true

class CreateChurpMentions < ActiveRecord::Migration[8.1]
  def change
    create_table :churp_mentions, id: :uuid do |t|
      # churp_mentions
      t.uuid :churp_id, null: false
      t.uuid :mentioned_user_id, null: false
      t.index [:churp_id, :mentioned_user_id], unique: true
      t.timestamps
    end

    add_foreign_key :churp_mentions, :churps, column: :churp_id
    add_foreign_key :churp_mentions, :users, column: :mentioned_user_id

    add_index :churp_mentions, :mentioned_user_id
  end
end
