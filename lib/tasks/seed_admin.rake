# frozen_string_literal: true

namespace :seed do
  desc "Seed admin user and profile"
  task create_admin: :environment do
    puts "🌱 Seeding admin account..."

    result = Seed::AdminSeeder.new.call

    case result
    in Dry::Monads::Success(user)
      puts "✅ Admin created: #{user.email}"
      puts "🧑 Profile: #{user.profile.full_name}"
    in Dry::Monads::Failure(error)
      puts "❌ Failed to create admin: #{error.message}"
      exit(1)
    end
  end
end
