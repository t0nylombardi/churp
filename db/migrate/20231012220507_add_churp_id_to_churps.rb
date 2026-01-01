# frozen_string_literal: true

class AddChurpIdToChurps < ActiveRecord::Migration[8.1]
  def change
    add_column :churps, :churp_id, :integer
  end
end
