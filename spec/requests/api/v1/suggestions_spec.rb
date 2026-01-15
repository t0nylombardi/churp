# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::SuggestionsController", type: :request do
  let(:password) { "Password1234!" }
  let(:user) { create(:user, password_digest: Authentication::Passwords::Hasher.hash(password)) }
  let(:headers) { auth_headers_for(user, password:) }

  before do
    Rails.application.routes.draw do
      namespace :api do
        namespace :v1 do
          get "suggestions", to: "suggestions#index"
        end
      end
    end
  end

  after do
    Rails.application.reload_routes!
  end

  describe "GET /api/v1/suggestions" do
    it "returns matching users ordered by username and limited to five" do
      create(:user, username: "bob")

      %w[al3 al1 al6 al5 al2 al4].each do |username|
        create(:user, username: username)
      end

      get "/api/v1/suggestions", params: { q: "al" }, headers: headers

      expect(response).to have_http_status(:ok)

      parsed_body = JSON.parse(response.body)
      parsed_body = JSON.parse(parsed_body) if parsed_body.is_a?(String)

      usernames = parsed_body.fetch("data", []).map do |item|
        item.dig("attributes", "username") || item["username"]
      end

      expect(usernames).to eq(%w[@al1 @al2 @al3 @al4 @al5])
    end

    it "returns unprocessable content when query is blank" do
      get "/api/v1/suggestions", params: { q: " " }, headers: headers

      expect(response).to have_http_status(:unprocessable_content)
      body = JSON.parse(response.body)
      expect(body["error"]).to be_present
    end
  end
end
