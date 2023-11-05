# frozen_string_literal: true

class MoveChurpBodyToRichText < ActiveRecord::Migration[7.1]
  def change
    Churp.all.each do |churp|
      churp.update(content: churp.body)
    end
    remove_column :churps, :body
  end

  def down
    add_column :churps, :body, :text
  end
end
