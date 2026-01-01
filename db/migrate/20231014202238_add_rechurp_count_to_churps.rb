# frozen_string_literal: true

class AddRechurpCountToChurps < ActiveRecord::Migration[8.1]
  def change
    add_column :churps, :rechurp_count, :uuid, default: 0
  end
end
