# frozen_string_literal: true

module Seed
  class AdminSeeder < BaseSeeder
    ADMIN_EMAIL = "admin@churp.com"

    def call
      yield ensure_admin_absent
      user = yield create_admin
      yield create_profile(user)

      success(user)
    end

    private

    def ensure_admin_absent
      return success unless User.exists?(role: "admin")

      failure("Admin already exists")
    end

    def create_admin
      success(
        User.create!(
          email: ADMIN_EMAIL,
          password: "Passw0rd1234!",
          username: "@t0nylombardi",
          role: "admin"
        )
      )
    rescue ActiveRecord::RecordInvalid => e
      failure(e)
    end

    def create_profile(user)
      user.create_profile!(
        first_name: "Anthony",
        last_name: "Lombardi",
        description: "I like Tacos and Tacos like me",
        website: "https://t0nylombardi.dev",
        birth_date: Date.new(1933, 7, 8)
      )

      success
    rescue ActiveRecord::RecordInvalid => e
      failure(e)
    end
  end
end
