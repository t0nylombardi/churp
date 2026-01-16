# frozen_string_literal: true

module Seed
  class ChurpSeeder < BaseSeeder
    include Dry::Monads[:result, :do]

    DEFAULT_HASHTAGS = %w[
      #train #transport #railway #bridge #metro #trainspotting #railfan
      #nature #birds #wildlife #travel #explore #photography #art #funny
      #viral #music #fitness #cute #love #reels
    ].freeze

    def initialize(count:)
      @count = count
      @users = User.all.to_a
    end

    def call
      results = Array.new(@count) { create_churp }

      success(
        created: results.count(&:success?),
        failed: results.count(&:failure?)
      )
    end

    private

    def create_churp
      churp = yield build_churp
      yield persist_churp(churp)
      yield seed_comments(churp)

      success(churp)
    rescue ActiveRecord::ActiveRecordError => e
      Rails.logger.error("[Seed::ChurpSeeder] #{e.message}")
      failure(e)
    end

    def build_churp
      success(
        Churp.new(
          user: random_user,
          content: content_block(
            Faker::Lorem.paragraph(sentence_count: 3),
            random_user.username,
            hashtags(3)
          )
        )
      )
    end

    def persist_churp(churp)
      ActiveRecord::Base.transaction do
        churp.save!
      end

      success(churp)
    end

    def seed_comments(churp)
      3.times do
        churp.comments.create!(
          user: random_user,
          content: content_block(
            Faker::Lorem.sentence(word_count: 20),
            hashtags(2)
          )
        )
      end

      success
    end

    def content_block(*parts)
      {
        "version" => 1,
        "blocks" => [
          {
            "type" => "paragraph",
            "text" => parts.join(" ")
          }
        ]
      }
    end

    def random_user
      @users.sample
    end

    def hashtags(count)
      DEFAULT_HASHTAGS.sample(count).join(" ")
    end
  end
end
