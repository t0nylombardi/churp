class RemoveDeviseFromUsers < ActiveRecord::Migration[8.1]
  def up
    remove_index :users, :confirmation_token if index_exists?(:users, :confirmation_token)
    remove_index :users, :reset_password_token if index_exists?(:users, :reset_password_token)
    remove_index :users, :jti if index_exists?(:users, :jti)
    remove_index :users, :unlock_token if index_exists?(:users, :unlock_token)

    change_table :users, bulk: true do |t|
      t.remove :confirmation_sent_at
      t.remove :confirmation_token
      t.remove :confirmed_at
      t.remove :current_sign_in_ip
      t.remove :current_sign_in_at
      t.remove :failed_attempts
      t.remove :jti
      t.remove :locked_at
      t.remove :unlock_token
      t.remove :encrypted_password
      t.remove :reset_password_token
      t.remove :reset_password_sent_at
      t.remove :remember_created_at
      t.remove :unconfirmed_email
      t.remove :sign_in_count
      t.remove :last_sign_in_at
      t.remove :last_sign_in_ip
    end
  end

  def down
    change_table :users, bulk: true do |t|
      t.string :encrypted_password, null: false, default: ""
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      t.datetime :confirmation_sent_at
      t.string :confirmation_token
      t.datetime :confirmed_at
      t.string :unconfirmed_email
      t.integer :failed_attempts, default: 0, null: false
      t.string :unlock_token
      t.datetime :locked_at
      t.integer :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet :current_sign_in_ip
      t.inet :last_sign_in_ip
      t.string :jti
    end

    add_index :users, :confirmation_token, unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :unlock_token, unique: true
    add_index :users, :jti, unique: true
  end
end
