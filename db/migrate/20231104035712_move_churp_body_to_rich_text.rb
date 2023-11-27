# frozen_string_literal: true

class MoveChurpBodyToRichText < ActiveRecord::Migration[7.1]
  def change
    reversible do |dir|
      Churp.all.each do |churp|
        churp.update(content: churp.body)
      end

      remove_column :churps, :body

      dir.down do
        add_column :churps, :body, :text
      end
    end
  end
end
