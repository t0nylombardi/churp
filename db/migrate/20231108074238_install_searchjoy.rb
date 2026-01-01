# frozen_string_literal: true

class InstallSearchjoy < ActiveRecord::Migration[8.1]
  def change
    create_table :searchjoy_searches, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :search_type
      t.string :query
      t.string :normalized_query
      t.integer :results_count
      t.datetime :created_at
      t.datetime :converted_at
    end

    add_index :searchjoy_searches, [:created_at]
    add_index :searchjoy_searches, %i[search_type created_at]
    add_index :searchjoy_searches, %i[search_type normalized_query created_at], name: "index_searchjoy_searches_type_query"

    create_table :searchjoy_conversions, id: :uuid do |t|
      t.references :search, type: :uuid
      t.references :convertable, polymorphic: true, index: {
        name: "index_searchjoy_conversions_on_convertable"
      }, type: :uuid
      t.datetime :created_at
    end
  end
end
