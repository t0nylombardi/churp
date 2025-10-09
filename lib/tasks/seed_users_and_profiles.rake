# frozen_string_literal: true

namespace :seed do
  desc "Seed a given number of users with profiles"
  task :create_users, [:num_of_users] => :environment do |_t, args|
    num = args[:num_of_users].to_i
    raise ArgumentError, "Please provide a positive number of users." if num <= 0

    puts "🌱 Seeding #{num} users with profiles..."

    seeder = Seed::UserSeeder.new(num)
    result = seeder.call

    puts "✅ Created #{result[:created]} users."
    puts "⚠️ Skipped #{result[:failed]} invalid users."
  rescue => e
    Rails.logger.error "[Seed::UserSeeder] Fatal error: #{e.message}"
    puts "💥 Seeding failed: #{e.message}"
  end
end
