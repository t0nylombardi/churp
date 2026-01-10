# frozen_string_literal: true

class RenameRechurpCountOnChurps < ActiveRecord::Migration[8.1]
  def change
    rename_column :churps, :rechurp_count, :rechurps_count
  end
end
