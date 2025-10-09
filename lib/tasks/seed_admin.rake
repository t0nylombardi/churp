# frozen_string_literal: true

namespace :seed do
  desc "Seed admin user and profile"
  task create_admin: :environment do
    puts "🌱 Seeding admin account..."

    seeder = Seed::AdminSeeder.new
    result = seeder.call

    if result.success?
      puts "✅ Admin created: #{result.user.email}"
      puts "🧑 Profile: #{result.user.profile.full_name}"
    else
      puts "❌ Failed to create admin: #{result.error_message}"
    end
  rescue => e
    Rails.logger.error "[Seed::Admin] Fatal error: #{e.message}"
    puts "💥 Seeding failed: #{e.message}"
  end
end
