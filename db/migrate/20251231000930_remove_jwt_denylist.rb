class RemoveJwtDenylist < ActiveRecord::Migration[8.1]
  def up
    drop_table :jwt_denylists

    remove index :jwt_denylist, :jti if index_exists?(:jwt_denylist, :jti)
  end

  def down
    create_table :jwt_denylist do |t|
      t.string :jti, null: false
      t.datetime :exp, null: false
      t.timestamps
    end
  end
end
