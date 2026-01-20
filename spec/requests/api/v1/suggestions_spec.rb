# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::SuggestionsController", type: :request do
  let(:user) { create(:user) }
  let(:headers) { auth_headers_for(user) }

  describe "GET /api/v1/suggestions" do
    before do
      # create_list(:user, 6, username: "al_user")
      build_list(:user, 6) do |record, i|
        record.username = "al_#{i}"
        record.save!
      end
    end

    it "returns a successful response" do
      get "/api/v1/suggestions", params: { q: "al" }, headers: headers

      expect(response).to have_http_status(:ok)
    end

    it "returns at most five results" do
      get "/api/v1/suggestions", params: { q: "al" }, headers: headers

      usernames = JSON
        .parse(response.body)
        .fetch("data")
        .map { |u| u.dig("attributes", "username") }

      expect(usernames.size).to eq(5)
    end

    it "returns unprocessable content when query is blank" do
      get "/api/v1/suggestions", params: { q: " " }, headers: headers

      expect(response).to have_http_status(:unprocessable_content)
    end
  end
end
