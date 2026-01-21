# frozen_string_literal: true

module Seed
  class DatabaseSeeder < BaseSeeder
    def call
      yield run(:destroy_all_records)
      yield run(:create_admin)
      yield run(:create_users, count: 50)
      yield run(:create_churps, count: 50)
      yield run(:create_follows)

      success("Database successfully populated")
    end

    private

    def run(task, **args)
      Rake::Task["seed:#{task}"].reenable
      Rake::Task["seed:#{task}"].invoke(*args.values)

      success
    rescue => e
      failure("[Seed::DatabaseSeeder] #{task} failed: #{e.message}")
    end
  end
end
