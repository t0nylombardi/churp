# frozen_string_literal: true

require "rails_helper"
require_relative "../support/devise"

RSpec.describe ProfilesController do
  let(:user) { create(:user_with_profile) }

  describe "GET #show" do
    it "renders the show template" do
      sign_in user

      profile = create(:profile, user:)
      get :show, params: { id: profile.user.username }
      expect(response).to render_template(:show)
    end
  end

  describe "GET #new" do
    it "assigns a new profile to @profile" do
      sign_in user
      get :new
      expect(assigns(:profile)).to be_a_new(Profile)
    end
  end

  describe "GET #edit" do
    it "renders the edit template" do
      sign_in user
      profile = create(:profile, user:)
      get :edit, params: { id: profile.user.username }
      expect(response).to render_template(:edit)
    end
  end

  describe "PATCH #update" do
    let(:profile) { create(:profile) }

    context "with valid parameters" do
      it "updates the profile" do
        sign_in user
        patch :update, params: { id: profile.user.username, profile: { name: "New Name" } }
        profile.reload
        expect(profile.name).to eq("New Name")
      end
    end

    context "with invalid parameters" do
      it "does not update the profile" do
        sign_in user
        patch :update, params: { id: profile.user.username, profile: { name: "" } }
        profile.reload
        expect(profile.name).not_to eq("")
      end
    end
  end

  describe "POST #follow" do
    it "allows a user to follow another user" do
      sign_in user
      other_user = create(:user_with_profile)
      post :follow, params: { id: other_user.username }
      expect(user).to be_following(other_user)
    end
  end

  describe "POST #unfollow" do
    it "allows a user to unfollow another user" do
      sign_in user
      other_user = create(:user_with_profile)
      user.follow(other_user)
      post :unfollow, params: { id: other_user.username }

      expect(user).not_to be_following(other_user)
    end
  end
end
