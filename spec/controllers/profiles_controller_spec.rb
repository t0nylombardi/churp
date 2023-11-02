require 'rails_helper'
require_relative '../support/devise'

RSpec.describe ProfilesController, type: :controller do
  render_views

  context 'when GET #show' do
    let!(:user) { create(:user, :with_profile) }

    context 'with a normal account in an HTML request' do

      it 'returns a standard HTML response', :aggregate_failures do
        sign_in user

        get :show, params: { id: user.slug }
        expect(response).to have_http_status(200)
      end
    end
  end

  context 'when POST #create' do
    let!(:user) { create :user }

    let(:params) do
      {
        profile: {
          name: 'Rick',
          description: 'Sanchez',
          website: 't0nylombardi.dev',
          birth_date: Faker::Date.birthday(min_age: 18, max_age: 110),
          user_id: user.id
        }
      }
    end

    context 'when success' do
      it 'creates a record' do
        sign_in user
        post(:create, params:)
        expect { post :create, params: }.to change(Profile, :count).by(1)

        expect(response).to have_http_status(302)
      end
    end

    context 'when failure' do
      # this is not really needed since the profile is created 
      # at sign up. However, I will come back to implement this test.

    end
  end

  context 'when PUT #update' do
    let!(:user) { create :user, :with_profile }

    let(:params) do
      {
        profile: {
          name: 'Rick Sanchez',
          description: 'I love tacos',
          website: 't0nylombardi.dev',
          birth_date: '1983-10-10'.to_date,
          user_id: user.id
        }
      }
    end

    context 'when success' do
      before { sign_in user }

      it 'creates a record' do
        post(:create, params:)

        expect(Profile.last.name).to eq('Rick Sanchez')
        expect(Profile.last.description).to eq('I love tacos')
        expect(Profile.last.website).to eq('t0nylombardi.dev')
        expect(response).to have_http_status(302)
      end
    end
  end

  context 'when POST #follow' do

    context 'when success' do
      let(:current_user) { FactoryBot.create(:user, :with_profile) }
      let(:other_user) { create(:user, :with_profile) }

      before do
        sign_in current_user
      end

      it 'follows a person' do
        post :follow, params: { id: other_user.id }

        expect(current_user.following.include?(other_user)).to be(true)
      end
    end
  end

  context 'when POST #unfollow' do

    context 'when success' do
      let(:current_user) { FactoryBot.create(:user, :with_profile) }
      let(:other_user) { create(:user, :with_profile) }

      before do
        sign_in current_user
      end

      it 'follows a person' do
        current_user.follow(other_user)
        post :unfollow, params: { id: other_user.id }

        expect(current_user.following.include?(other_user)).to be(false)
      end
    end
  end

end
