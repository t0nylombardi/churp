# frozen_string_literal: true

namespace :seed do
  # Populates users and profiles.
  #   Api `rails 'db:create_users'`
  desc 'seed users and create respective profiles'
  task :create_users, [:num_of_users] => :environment do |_t, args|
    valid_users = []
    invalid_users = []
    0.upto(args[:num_of_users].to_i) do |i|
      user = User.new(
        email: "test@test#{i}.com",
        password: 'Passw0rd1!',
        password_confirmation: 'Passw0rd1!',
        username: "#{Faker::Internet.username(specifier: 10).camelize}#{i}",
        role: :basic
      )

      user.build_profile(
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        description: Faker::Lorem.sentence(word_count: 20),
        website: "https://#{Faker::Internet.domain_name}",
        birth_date: Faker::Date.birthday(min_age: 18, max_age: 65)
      )

      if user.valid?
        valid_users << user
      else
        invalid_users << user
      end

      valid_users.each do |u|
        u.run_callbacks(:save) { false }
        u.run_callbacks(:create) { false }
      end
    end

    User.import valid_users, recursive: true
    puts 'Created users'
  end
end
