# frozen_string_literal: true

class RemoveJtiFromUsers < ActiveRecord::Migration[8.1]
  def change
    remove_column :users, :jti, :string
  end
end
