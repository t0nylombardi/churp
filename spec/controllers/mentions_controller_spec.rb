# frozen_string_literal: true

require "rails_helper"

RSpec.describe MentionsController do
  render_views

  describe "GET #index" do
    let!(:user) { create(:user, username: "testman") }
    let(:meeseek) { create(:user, :with_profile, username: "meeseek") }
    let(:rick) { create(:user, :with_profile, username: "rick") }
    let(:morty) { create(:user, :with_profile, username: "morty") }
    let(:params) { { query: "meeseek" } }

    context "when searching for users" do
      before { sign_in user }

      it "returns http success" do
        get :index, params:, as: :json

        expect(response).to have_http_status(200)
      end

      it "returns matching account" do
        get :index, params:, as: :json

        expect(JSON.parse(response.body)).to include(include("username" => "meeseek"))
      end
    end

    context "when searching is empty" do
      before { sign_in user }

      it "returns matching account" do
        get :index, params: { query: nil }, as: :json

        expect(JSON.parse(response.body)).to include({ "error" => "query empty" })
      end
    end
  end
end
