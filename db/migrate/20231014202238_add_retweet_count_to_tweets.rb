# frozen_string_literal: true

class AddRetweetCountToTweets < ActiveRecord::Migration[7.0]
  def change
    add_column :tweets, :retweet_count, :integer, default: 0
  end
end
