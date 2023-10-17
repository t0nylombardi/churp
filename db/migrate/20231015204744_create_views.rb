# frozen_string_literal: true

class CreateViews < ActiveRecord::Migration[7.0]
  def change
    create_table :views do |t|
      t.references :user, null: false, foreign_key: true
      t.references :churp, null: false, foreign_key: true
      t.string :ip_address
      t.string :user_agent
      t.string :city
      t.string :state

      t.timestamps
    end
  end
end
