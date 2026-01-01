# frozen_string_literal: true

class CreateChurps < ActiveRecord::Migration[8.1]
  def change
    create_table :churps, id: :uuid do |t|
      t.text :body
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
