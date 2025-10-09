# frozen_string_literal: true

module Seed
  class DatabaseSeeder
    def call
      header "🌱 Starting database population"
      time_it do
        safely { run_task("seed:destroy_all_records") }
        safely { run_task("seed:create_admin") }
        safely { run_task("seed:create_users", num_of_users: 50) }
        safely { run_task("seed:create_churps", num_of_churps: 50) }
        safely { run_task("seed:create_follows") }
      end
      success "✅ Database successfully populated!"
    rescue => e
      failure "💥 Database seeding failed: #{e.message}"
      Rails.logger.error "[Seed::DatabaseSeeder] #{e.full_message}"
    end

    private

    def run_task(name, **args)
      start "Running #{name}"
      Rake::Task[name].reenable # allow repeated invocations safely
      Rake::Task[name].invoke(*args.values)
      success "Finished #{name}"
    rescue => e
      failure "Failed #{name}: #{e.message}"
      raise # re-raise to stop pipeline
    end

    # Utility logging helpers
    def header(msg)
      puts "\n--------------------------------------------------------------"
      puts msg
      puts "--------------------------------------------------------------\n\n"
    end

    def start(msg)
      puts "➡️  #{msg}"
    end

    def success(msg)
      puts "✅ #{msg}"
    end

    def failure(msg)
      puts "❌ #{msg}"
    end

    def safely
      yield
    rescue => e
      failure e.message
      Rails.logger.error "[Seed::DatabaseSeeder] #{e.message}"
    end

    def time_it
      start_time = Time.current
      yield
      duration = (Time.current - start_time).round(2)
      puts "\n⏱️  Completed in #{duration}s\n\n"
    end
  end
end
