# frozen_string_literal: true

namespace :seed do
  desc "Completely populate the database with seed data"
  task db_populate: :environment do
    seeder = Seed::DatabaseSeeder.new
    seeder.call
  end

  desc "Destroy all records in the database"
  task destroy_all_records: :environment do
    puts "💣 Destroying all records..."
    [View, ChurpHashTag, HashTag, Like, Profile, Churp, User].each do |model|
      count = model.count
      model.destroy_all
      puts "🧹 Destroyed #{count} #{model.name.pluralize(count)}"
    end
    puts "✅ All records destroyed."
  end
end
