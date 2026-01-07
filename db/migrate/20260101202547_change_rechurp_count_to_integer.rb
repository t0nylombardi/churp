# frozen_string_literal: true

class ChangeRechurpCountToInteger < ActiveRecord::Migration[8.1]
  def up
    remove_column :churps, :rechurp_count
    add_column :churps, :rechurp_count, :integer, null: false, default: 0
  end

  def down
    remove_column :churps, :rechurp_count
    add_column :churps, :rechurp_count, :uuid
  end
end
