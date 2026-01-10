class CreateRechurps < ActiveRecord::Migration[8.1]
  def change
    create_table :rechurps, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :original_churp, null: false,
        foreign_key: { to_table: :churps },
        type: :uuid

      t.timestamps
    end

    add_index :rechurps, [:original_churp_id, :created_at]
    add_index :rechurps, [:user_id, :created_at]
  end
end
