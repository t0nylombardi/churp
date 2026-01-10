# frozen_string_literal: true

module AuthHelper
  def auth_token_for(user, password:)
    post "/api/v1/authentication/login",
      params: {
        email: user.email,
        password:
      }.to_json,
      headers: json_headers
    expect(response).to have_http_status(:ok)

    parsed = JSON.parse(response.body)
    token = parsed.dig("token", "value")
    raise "Auth token missing: #{parsed}" unless token

    token
  end

  def auth_headers_for(user, password:)
    token = auth_token_for(user, password:)

    expect(token).to be_present

    json_headers.merge(
      "Authorization" => "Bearer #{token}"
    )
  end

  def json_headers
    {
      "Accept" => "application/json",
      "Content-Type" => "application/json"
    }
  end
end
