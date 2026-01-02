# frozen_string_literal: true

namespace :seed do
  desc "Seed a specified number of churps with hashtags and comments"
  task :create_churps, [:num_of_churps] => :environment do |_t, args|
    num = args[:num_of_churps].to_i
    raise ArgumentError, "Please provide a number of churps to create." if num <= 0

    puts "🌱 Seeding #{num} churps..."

    churp_seeder = Seed::ChurpSeeder.new(num)
    result = churp_seeder.call

    puts "✅ Successfully created #{result[:success_count]} churps."
    puts "❌ Failed to create #{result[:error_count]} churps."
  rescue => e
    Rails.logger.error "Error during churp seeding: #{e.message}"
    puts "❌ Seeding failed: #{e.message}"
  end
end
