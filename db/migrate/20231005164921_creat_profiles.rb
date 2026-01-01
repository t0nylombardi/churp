# frozen_string_literal: true

class CreatProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :profiles, id: :uuid do |t|
      t.string :first_name
      t.string :last_name
      t.text :description
      t.string :website
      t.datetime :birth_date
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
