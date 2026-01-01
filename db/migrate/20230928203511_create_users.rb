# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users, id: :uuid do |t|
      t.string :email, null: false, default: ""
      t.string :password_digest, null: false, default: ""
      t.datetime :password_changed_at, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.string :display_name, null: false, default: ""
      t.string :username, null: false, default: ""
      t.uuid :uuid, null: false, default: "gen_random_uuid()"
      t.string :slug, null: false, default: ""
      t.timestamps null: false
    end

    add_index :users, :email, unique: true
    add_index :users, :username, unique: true
    add_index :users, :uuid, unique: true
  end
end
