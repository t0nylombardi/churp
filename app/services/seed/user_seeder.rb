module Seed
  class UserSeeder < BaseSeeder
    BATCH_SIZE = 500

    def initialize(count:)
      @count = count
      @buffer = []
      @created = 0
      @failed = 0
    end

    def call
      @count.times { yield build_and_buffer_user }
      yield flush

      success(summary)
    end

    private

    def build_and_buffer_user
      user = build_user

      if user.valid?
        @buffer << user
        flush if @buffer.size >= BATCH_SIZE
        success
      else
        @failed += 1
        Rails.logger.warn "[Seed::UserSeeder] Invalid user: #{user.errors.full_messages.join(", ")}"
      end
    end

    def flush
      return success if @buffer.empty?

      User.import(@buffer, recursive: true, validate: false)
      @created += @buffer.size
      @buffer.clear

      success
    rescue => e
      failure(e)
    end

    def build_user
      User.new(
        email: Faker::Internet.unique.email,
        password: "Passw0rd1!",
        password_confirmation: "Passw0rd1!",
        username: "@#{Faker::Internet.username(specifier: 10)}",
        password_changed_at: Time.current,
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

    def summary
      {created: @created, failed: @failed}
    end
  end
end
