# frozen_string_literal: true

module AuthHelpers
  def auth_headers_for(user)
    post "/api/v1/users/sign_in", params: {
      user: {
        email: user.email,
        password: user.password
      }
    }.to_json, headers: json_headers

    binding.pry
    # token = response.headers["Authorization"]
    # expect(token).to be_present

    # json_headers.merge("Authorization" => token)
  end

  def json_headers
    {
      "Accept" => "application/json",
      "Content-Type" => "application/json"
    }
  end
end

RSpec.configure do |config|
  config.include AuthHelpers, type: :request
end
