# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::AuthenticationController", type: :request do
  let(:headers) { json_headers }
  let(:password) { "Password1234!" }

  describe "POST /api/v1/authentication/register" do
    let(:params) do
      {
        username: "tester",
        email: "tester@example.com",
        password:
      }
    end

    context "with valid params" do
      it "creates a user" do
        expect do
          post "/api/v1/authentication/register",
            params: params.to_json,
            headers:
        end.to change(User, :count).by(1)

        expect(response).to have_http_status(:created)
      end

      it "returns the user id" do
        post "/api/v1/authentication/register",
          params: params.to_json,
          headers: headers

        body = JSON.parse(response.body)
        expect(body).to have_key("id")
      end
    end

    context "with invalid params" do
      it "returns unprocessable content" do
        invalid_params = params.merge(email: nil)

        expect do
          post "/api/v1/authentication/register",
            params: invalid_params.to_json,
            headers:
        end.not_to change(User, :count)

        expect(response).to have_http_status(:unprocessable_content)
        body = JSON.parse(response.body)
        expect(body).to include("error", "details")
      end
    end
  end

  describe "POST /api/v1/authentication/login" do
    let!(:user) do
      create(:user, password_digest: Authentication::Passwords::Hasher.hash(password))
    end

    context "with valid credentials" do
      let(:params) do
        {
          email: user.email,
          password:
        }
      end

      it "returns a token" do
        post "/api/v1/authentication/login",
          params: params.to_json, headers: headers

        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)
        expect(body.dig("token")).to be_present
      end
    end

    context "with invalid credentials" do
      it "returns unauthorized" do
        post "/api/v1/authentication/login",
          params: {
            email: user.email,
            password: "WrongPassword123!"
          }.to_json,
          headers: headers
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
