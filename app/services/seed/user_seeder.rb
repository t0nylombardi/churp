# frozen_string_literal: true

module Seed
  class UserSeeder
    BATCH_SIZE = 500

    def initialize(num)
      @num = num
      @created = 0
      @failed = 0
      @valid_users = []
      @invalid_users = []
    end

    def call
      generate_users
      bulk_import
      summary
    rescue => e
      Rails.logger.error "[Seed::UserSeeder] Error: #{e.message}"
      { created: @created, failed: @failed, error: e.message }
    end

    private

    def generate_users
      @num.times do |i|
        user = build_user(i)
        user.valid? ? @valid_users << user : handle_invalid(user)
        flush_batch if @valid_users.size >= BATCH_SIZE
      end
      flush_batch unless @valid_users.empty?
    end

    def build_user(i)
      User.new(
        email: "test#{i}@churp.com",
        password: "Passw0rd1!",
        password_confirmation: "Passw0rd1!",
        username: "#{Faker::Internet.username(specifier: 10).camelize}#{i}",
        role: :basic,
        profile: build_profile
      )
    end

    def build_profile
      Profile.new(
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        description: Faker::Lorem.sentence(word_count: 20),
        website: "https://#{Faker::Internet.domain_name}",
        birth_date: Faker::Date.birthday(min_age: 18, max_age: 65)
      )
    end

    def handle_invalid(user)
      Rails.logger.warn "[Seed::UserSeeder] Invalid user (#{user.email}): #{user.errors.full_messages.join(", ")}"
      @invalid_users << user
      @failed += 1
    end

    def flush_batch
      User.import @valid_users, recursive: true, validate: false
      @created += @valid_users.size
      puts "💾 Imported #{@valid_users.size} users... (total: #{@created})"
      @valid_users.clear
    rescue => e
      Rails.logger.error "[Seed::UserSeeder] Failed to import batch: #{e.message}"
    end

    def bulk_import
      # Remaining users (if not divisible by batch size)
      return if @valid_users.empty?

      User.import @valid_users, recursive: true, validate: false
      @created += @valid_users.size
      @valid_users.clear
    rescue => e
      Rails.logger.error "[Seed::UserSeeder] Final import failed: #{e.message}"
    end

    def summary
      {
        created: @created,
        failed: @failed
      }
    end
  end
end
