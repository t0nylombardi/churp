# frozen_string_literal: true

namespace :seed do
  desc "Completely populate the database with seed data"
  task db_populate: :environment do
    result = Seed::DatabaseSeeder.new.call

    case result
    in Dry::Monads::Success(message)
      puts "✅ #{message}"
    in Dry::Monads::Failure(error)
      puts "❌ Database population failed: #{error}"
      exit(1)
    end
  end

  desc "Destroy all records in the database"
  task destroy_all_records: :environment do
    puts "💣 Destroying all records..."

    result = Seed::DestroyAllRecords.new.call

    case result
    in Dry::Monads::Success(message)
      puts "🧹 #{message}"
    in Dry::Monads::Failure(error)
      puts "❌ Failed to destroy records: #{error.message}"
      exit(1)
    end
  end
end
