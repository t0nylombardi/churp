# frozen_string_literal: true

module Seed
  class ChurpSeeder
    include ActiveModel::Model

    attr_reader :num_of_churps, :hash_tags, :users, :success_count, :error_count

    def initialize(num_of_churps)
      @num_of_churps = num_of_churps
      @hash_tags = default_hash_tags
      @users = User.all.to_a
      @success_count = 0
      @error_count = 0
    end

    def call
      num_of_churps.times { create_random_churp }
      { success_count:, error_count: }
    end

    private

    def create_random_churp
      churp_body = Faker::Lorem.paragraph_by_chars(number: 200)
      hashtags_text = Array.new(5) { hash_tags.sample }.join(" ")
      user = users.sample

      churp = Churp.new(
        body: "#{churp_body} #{user.username} #{hashtags_text}",
        user:
      )

      ActiveRecord::Base.transaction do
        churp.save!
        3.times { create_comment_for(churp) }
        @success_count += 1
        puts "✨ Created churp ##{@success_count}: #{churp.id}"
      end
    rescue => e
      Rails.logger.error "Failed to create churp: #{e.message}"
      @error_count += 1
    end

    def create_comment_for(churp)
      comment_body = Faker::Lorem.sentence(word_count: 20)
      churp.comments.create!(
        content: "#{comment_body} #{Array.new(3) { hash_tags.sample }.join(" ")}",
        user: users.sample
      )
    end

    def default_hash_tags
      %w[
        #train #transport #railway #bridge #metro #trainspotting #railfan #nature #birds #wildlife
        #travel #explore #photography #art #funny #viral #music #fitness #cute #love #reels
      ]
    end
  end
end
