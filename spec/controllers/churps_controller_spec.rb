# frozen_string_literal: true

require "rails_helper"
require_relative "../support/devise"

RSpec.describe ChurpsController do
  describe "GET /" do
    let(:user) { create(:user) }
    let(:valid_attributes) { { content: Faker::Lorem.sentence(word_count: 3), user_id: user.id } }
    let(:invalid_attributes) { { content: "", user_id: user.id } }
    let(:valid_session) { {} }

    login_user

    describe "GET #index" do
      before { Churp.create!(valid_attributes) }

      it "returns a successful response" do
        get :index, params: { content: Faker::Lorem.sentence(word_count: 3) }
        expect(response).to be_successful
      end
    end

    describe "POST #like" do
      let(:churp) { create(:churp) }

      it "creates a like for the current user" do
        expect {
          post :like, params: { churp_id: churp.id }
        }.to change(Like, :count).by(1)
      end

      context "when format is Turbo Stream" do # standard:disable RSpec/NestedGroups
        before do
          post :like, params: { churp_id: churp.id }, format: :turbo_stream
        end

        it "returns HTTP 200" do
          expect(response).to have_http_status(:ok)
        end

        it "renders the likes partial" do
          expect(response).to render_template("churps/shared/_likes")
        end

        it "renders the likes partial with churp local" do
          expect(response).to render_template("churps/shared/_likes", locals: { churp: })
        end
      end

      context "when format is HTML" do # standard:disable RSpec/NestedGroups
        before { post :like, params: { churp_id: churp.id } }

        it "returns a found response" do
          expect(response).to have_http_status(:found)
        end

        it "redirects to churps_path" do
          expect(response).to redirect_to(churps_path)
        end
      end
    end

    describe "POST #rechurp" do
      let(:churp) { create(:churp) }

      before { sign_in user }

      context "when rechurp is successful" do # standard:disable RSpec/NestedGroups
        it "creates a rechurp" do
          expect {
            post :rechurp, params: { id: churp.id, churp: }
          }.to change(Churp, :count).by(1)
        end

        it "increments the rechurp_count" do
          post :rechurp, params: { id: churp.id, churp: { content: "foo" } }
          expect(assigns(:rechurp).rechurp_count).to eq(churp.rechurp_count + 1)
        end

        it "redirects to churps_url" do
          post :rechurp, params: { id: churp.id, churp: { content: "foo" } }
          expect(response).to redirect_to(churps_url)
        end
      end
    end
  end
end
