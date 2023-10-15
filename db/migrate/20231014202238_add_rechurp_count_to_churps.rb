# frozen_string_literal: true

class AddRechurpCountToChurps < ActiveRecord::Migration[7.0]
  def change
    add_column :churps, :rechurp_count, :integer, default: 0
  end
end
