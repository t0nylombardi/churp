# frozen_string_literal: true

namespace :seed do
  desc "Seed random follows between users"
  task create_follows: :environment do
    puts "🌱 Seeding user follows..."

    result = Seed::FollowSeeder.new.call

    case result
    in Dry::Monads::Success(summary)
      puts "✅ Created #{summary[:created]} follows."
      puts "⚠️ Skipped #{summary[:skipped]} duplicates."
    in Dry::Monads::Failure(error)
      puts "❌ Follow seeding failed: #{error.message}"
      exit(1)
    end
  end
end
