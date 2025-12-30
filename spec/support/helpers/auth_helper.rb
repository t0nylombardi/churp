module ApiHelper
  def authenticated_header(request, user)
    request.headers.merge!(auth_headers_for(user))
  end

  def auth_headers_for(user, headers: default_auth_headers)
    Devise::JWT::TestHelpers.auth_headers(headers, user)
  end

  def auth_token_for(user)
    auth_headers_for(user)["Authorization"]
  end

  private

  def default_auth_headers
    {
      "Accept" => "application/json",
      "Content-Type" => "application/json"
    }
  end
end
