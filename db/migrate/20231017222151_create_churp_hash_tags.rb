# frozen_string_literal: true

class CreateChurpHashTags < ActiveRecord::Migration[8.1]
  def change
    create_table :churp_hash_tags, id: :uuid do |t|
      t.belongs_to :churp, index: true, type: :uuid
      t.belongs_to :hash_tag, index: true, type: :uuid

      t.timestamps
    end
  end
end
