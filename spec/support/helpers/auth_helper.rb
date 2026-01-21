# frozen_string_literal: true

module AuthHelper
  def auth_token_for(user, password: "Password1234!")
    Authentication::Tokens::JwtEncoder.encode({ user_id: user.id })
  end

  def auth_headers_for(user, password: "Password1234!")
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
