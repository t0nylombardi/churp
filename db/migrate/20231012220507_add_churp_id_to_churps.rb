# frozen_string_literal: true

class AddChurpIdToChurps < ActiveRecord::Migration[7.0]
  def change
    add_column :churps, :churp_id, :integer
  end
end
