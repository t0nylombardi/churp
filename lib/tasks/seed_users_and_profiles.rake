# frozen_string_literal: true

namespace :seed do
  # Populates users and profiles.
  #   Api `rails 'db:create_users'`
  desc 'seed users and create respective profiles'
  task :create_users, [:num_of_users] => :environment do |_t, args|
    0.upto(args[:num_of_users].to_i) do |_i|
      role = %i(admin basic).sample
      user = User.create(
        email: Faker::Internet.email,
        password: 'Passw0rd1!',
        password_confirmation: 'Passw0rd1!',
        username: "@#{Faker::Internet.username(specifier: 8)}",
        role:
      )
      user.save!
      Rake::Task['seed:create_profile'].invoke(user:)
      Rake::Task['seed:create_profile'].reenable
    end
  end

  task :create_profile, [:user] => :environment do |_t, args|
    user = args[:user].values.first
    user.build_profile(
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      description: Faker::Lorem.sentence(word_count: 20),
      website: "https://#{Faker::Internet.domain_name}",
      birth_date: Faker::Date.birthday(min_age: 18, max_age: 65)
    ).save!
    puts "Created user: #{user.email}"
  end
end
