# frozen_string_literal: true

namespace :seed do
  desc "Seed a specified number of churps with hashtags and comments"
  task :create_churps, [:num_of_churps] => :environment do |_t, args|
    num = args[:num_of_churps].to_i
    abort("❌ Please provide a number of churps to create.") if num <= 0

    puts "🌱 Seeding #{num} churps..."

    result = Seed::ChurpSeeder.new(count: num).call

    case result
    in Dry::Monads::Success(summary)
      puts "✅ Successfully created #{summary[:created]} churps."
      puts "❌ Failed to create #{summary[:failed]} churps."
    in Dry::Monads::Failure(error)
      puts "❌ Churp seeding failed: #{error.message}"
      exit(1)
    end
  end
end
