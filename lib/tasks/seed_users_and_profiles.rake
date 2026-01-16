# frozen_string_literal: true

namespace :seed do
  desc "Seed a given number of users with profiles"
  task :create_users, [:num_of_users] => :environment do |_t, args|
    num = args[:num_of_users].to_i
    abort("❌ Please provide a positive number of users.") if num <= 0

    puts "🌱 Seeding #{num} users with profiles..."

    result = Seed::UserSeeder.new(count: num).call

    case result
    in Dry::Monads::Success(summary)
      puts "✅ Created #{summary[:created]} users."
      puts "⚠️ Skipped #{summary[:failed]} invalid users."
    in Dry::Monads::Failure(error)
      puts "❌ User seeding failed: #{error.message}"
      exit(1)
    end
  end
end
