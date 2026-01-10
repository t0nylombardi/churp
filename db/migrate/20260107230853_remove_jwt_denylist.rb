# frozen_string_literal: true

class RemoveJwtDenylist < ActiveRecord::Migration[8.1]
  def up
    drop_table :jwt_denylists
  end

  def down
    create_table "jwt_denylists", force: :cascade do |t|
      t.datetime "created_at", null: false
      t.datetime "exp"
      t.string "jti"
      t.datetime "updated_at", null: false
      t.index ["jti"], name: "index_jwt_denylists_on_jti"
    end
  end
end
