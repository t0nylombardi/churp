# frozen_string_literal: true

class CreateChurps < ActiveRecord::Migration[7.0]
  def change
    create_table :churps do |t|
      t.text :body
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
