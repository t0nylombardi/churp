# frozen_string_literal: true

namespace :seed do
  desc 'Seeds database'
  task db_populate: :environment do
    message "--------------------------------------------------------------\n"
    message 'STARTED - populating DB'
    message "Have no fears. This process is idempotent.\n\n"

    Rake::Task['seed:destroy_all_records'].execute
    Rake::Task['seed:create_admin'].execute
    Rake::Task['seed:create_users'].execute(num_of_users: 50)
    Rake::Task['seed:create_churps'].execute(num_of_churps: 50)
    Rake::Task['seed:create_follows'].execute

    message '--------------------------------------------------------------'
    message 'SUCCESS - populated DB'
  end

  desc 'Destroys all data in the database'
  task destroy_all_records: :environment do
    User.destroy_all
    Churp.destroy_all
    Profile.destroy_all
    Like.destroy_all
    HashTag.destroy_all
    ChurpHashTag.destroy_all
    View.destroy_all
  end
end

def message(message, delay = 0)
  puts message if Rails.env.development?

  sleep(delay)
end
