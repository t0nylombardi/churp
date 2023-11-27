# frozen_string_literal: true

class AddUniqueIndexToUserName < ActiveRecord::Migration[7.1]
  def change
    add_index :users, :username, unique: true
  end
end
