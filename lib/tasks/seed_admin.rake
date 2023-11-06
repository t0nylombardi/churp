# frozen_string_literal: true

namespace :seed do
  # Populates admin.
  #   Api `rails 'db:create_admin'`
  desc 'seed admin and respective profiles'
  task create_admin: :environment do
    user = User.create(
      email: 'admin@churp.com',
      password: 'Passw0rd1!',
      password_confirmation: 'Passw0rd1!',
      username: '@t0nylombardi',
      role: 'admin'
    )
    user.save!
    Rake::Task['seed:create_admin_profile'].invoke(user:)
  end

  task :create_admin_profile, [:user] => :environment do |_t, args|
    user = args[:user].values.first
    user.build_profile(
      first_name: 'Anthony',
      last_name: 'Lombardi',
      description: 'I like Tacos and Tacos like me',
      website: 't0nylombardi.dev',
      birth_date: '1983-03-31'.to_date
    ).save!
    puts "Created admin: #{user.email}"
  end
end
