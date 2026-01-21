# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::ChurpsController", type: :request do
  let_it_be(:user) { create(:user) }
  let_it_be(:other_user) { create(:user) }

  let(:headers) { auth_headers_for(user) }

  let!(:churp) do
    create(
      :churp,
      user: other_user,
      content: {
        version: 1,
        blocks: [{ type: "text", content: "new churp" }]
      }
    )
  end

  describe "GET /api/v1/churps" do
    before do
      create_list(:churp, 3, user: other_user)
      get "/api/v1/churps", headers:
    end

    it "returns http success" do
      # binding.pry
      expect(response).to have_http_status(:ok)
    end

    it "returns paginated data" do
      body = JSON.parse(response.body)
      expect(body).to have_key("meta")
    end
  end

  describe "GET /api/v1/churps/:id" do
    before do
      get "/api/v1/churps/#{churp.id}", headers:
    end

    it "returns http success" do
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /api/v1/churps" do
    let(:params) do
      {
        churp: {
          content: {
            version: 1,
            blocks: [{ type: "text", content: "new churp" }]
          }
        }
      }
    end

    context "with valid params" do
      before do
        post "/api/v1/churps",
          params: params.to_json,
          headers:
      end

      it "creates a churp" do
        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid params" do
      before do
        post "/api/v1/churps",
          params: { churp: { content: nil } }.to_json,
          headers:
      end

      it "returns unprocessable content" do
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "PATCH /api/v1/churps/:id" do
    let!(:owned_churp) { create(:churp, user:) }

    context "when user owns the churp" do
      before do
        patch "/api/v1/churps/#{owned_churp.id}",
          params: {
            churp: {
              content: {
                version: 1,
                blocks: [{ type: "text", content: "updated" }]
              }
            }
          }.to_json,
          headers:
      end

      it "updates the churp" do
        expect(response).to have_http_status(:ok)
      end
    end

    context "when user does not own the churp" do
      before do
        patch "/api/v1/churps/#{churp.id}",
          params: {
            churp: {
              content: {
                version: 1,
                blocks: [{ type: "text", content: "hacked" }]
              }
            }
          }.to_json,
          headers:
      end

      it "returns not found" do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "DELETE /api/v1/churps/:id" do
    let!(:owned_churp) { create(:churp, user:) }

    before do
      delete "/api/v1/churps/#{owned_churp.id}", headers:
    end

    it "deletes the churp" do
      expect(response).to have_http_status(:no_content)
    end
  end

  describe "POST /api/v1/churps/:id/like" do
    before do
      post "/api/v1/churps/#{churp.id}/like", headers:
    end

    it "likes the churp" do
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /api/v1/churps/:id/rechurp" do
    context "when rechurp succeeds" do
      before do
        post "/api/v1/churps/#{churp.id}/rechurp", headers:
      end

      it "creates a rechurp" do
        expect(response).to have_http_status(:created)
      end
    end

    context "when rechurp fails" do
      before do
        allow(Churps::RechurpService).to receive(:call)
          .and_return(
            double(success?: false, errors: ["boom"])
          )

        post "/api/v1/churps/#{churp.id}/rechurp", headers:
      end

      it "returns unprocessable entity" do
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end
end
