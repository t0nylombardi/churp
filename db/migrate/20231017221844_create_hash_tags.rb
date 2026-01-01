# frozen_string_literal: true

class CreateHashTags < ActiveRecord::Migration[8.1]
  def change
    create_table :hash_tags, id: :uuid do |t|
      t.string :name

      t.timestamps
    end
  end
end
