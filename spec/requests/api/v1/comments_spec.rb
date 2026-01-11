# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::CommentsController", type: :request do
  let(:password) { "Password1234!" }
  let(:user) { create(:user, password_digest: Authentication::Passwords::Hasher.hash(password)) }
  let(:other_user) { create(:user, password_digest: Authentication::Passwords::Hasher.hash(password)) }
  let(:headers) { auth_headers_for(user, password:) }

  let(:valid_content) do
    {
      "version" => 1,
      "blocks" => [
        { "type" => "text", "content" => "hello world" }
      ]
    }
  end

  let!(:churp) { create(:churp, user: other_user) }

  describe "POST /api/v1/churps/:churp_id/comments" do
    let(:params) do
      {
        comment: {
          content: valid_content
        }
      }
    end

    before do
      post "/api/v1/churps/#{churp.id}/comments",
        params: params.to_json,
        headers: headers
    end

    it "creates a comment for the churp" do
      expect(response).to have_http_status(:created)
    end

    it "returns unprocessable content for invalid params" do
      post "/api/v1/churps/#{churp.id}/comments",
        params: {
          comment: {
            content: nil
          }
        }.to_json,
        headers: headers

      expect(response).to have_http_status(:unprocessable_content)
    end

    it "returns not found when churp is missing" do
      post "/api/v1/churps/does-not-exist/comments",
        params: {
          comment: {
            content: valid_content
          }
        }.to_json,
        headers: headers

      expect(response).to have_http_status(:not_found)
    end

    it "returns unauthorized without auth" do
      post "/api/v1/churps/#{churp.id}/comments",
        params: {
          comment: {
            content: valid_content
          }
        }.to_json,
        headers: json_headers

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "DELETE /api/v1/churps/:churp_id/comments/:id" do
    it "deletes the comment" do
      comment = create(:comment, churp:, user: other_user, content: valid_content)

      expect do
        delete "/api/v1/churps/#{churp.id}/comments/#{comment.id}", headers:
      end.to change(Comment, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end

    it "returns not found when comment is not on the churp" do
      other_churp = create(:churp)
      comment = create(:comment, churp: other_churp, user: other_user, content: valid_content)

      delete "/api/v1/churps/#{churp.id}/comments/#{comment.id}", headers: headers

      expect(response).to have_http_status(:not_found)
    end

    it "returns unauthorized without auth" do
      comment = create(:comment, churp:, user: other_user, content: valid_content)

      delete "/api/v1/churps/#{churp.id}/comments/#{comment.id}", headers: json_headers

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
