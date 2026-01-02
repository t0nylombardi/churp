# frozen_string_literal: true

require "rails_helper"

RSpec.describe "GET /api/v1/churps", type: :request do
  let(:user) {
    create(:user,
      password: "Password1234!",
      password_confirmation: "Password1234!")
  }
  let(:valid_user) {
    {
      user: {
        email: user.email,
        password: "Password1234!"
      }
    }
  }

  before do
    3.times do
      create(:churp)
    end
  end

  it "signs in a user" do
    post "/api/v1/users/sign_in", params: valid_user.to_json,
      headers: {
        "Accept" => "application/json",
        "Content-Type" => "application/json"
      }

    expect(response).to have_http_status(:ok)
  end
end
