# frozen_string_literal: true

class CreateChurpHashTags < ActiveRecord::Migration[7.0]
  def change
    create_table :churp_hash_tags do |t|
      t.belongs_to :churp, index: true
      t.belongs_to :hash_tag, index: true

      t.timestamps
    end
  end
end
