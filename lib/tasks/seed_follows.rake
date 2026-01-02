# frozen_string_literal: true

namespace :seed do
  desc "Seed random follows between users"
  task create_follows: :environment do
    puts "🌱 Seeding user follows..."

    seeder = Seed::FollowSeeder.new
    result = seeder.call

    puts "✅ Created #{result[:created_count]} follows."
    puts "⚠️ Skipped #{result[:skipped_count]} duplicates."
  rescue => e
    Rails.logger.error "[Seed::FollowSeeder] Fatal error: #{e.message}"
    puts "💥 Seeding failed: #{e.message}"
  end
end
