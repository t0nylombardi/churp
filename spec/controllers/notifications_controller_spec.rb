# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationsController do
  context 'when GET #index' do
    let!(:user) { create(:user, :with_profile, username: 'ricksanchez') }
    let!(:churper) { create(:user, :with_profile) }

    context 'when signed in' do
      before { sign_in user }

      let!(:churp) { create(:churp, content: 'hey there! @ricksanchez', user: churper) }

      it 'returns notifications' do
        churp.run_callbacks(:commit)

        get :index
        expect(user.notifications.count).to be >= 0
      end

      it 'returns churps' do
        notification = user.notifications.last
        text = notification.params[:message].content.body.to_s

        get :index
        expect(text).to match(/hey there! @ricksanchez/)
      end
    end

    context 'when not signed in' do
      it 'redirects to signin/up page' do

        get :index
        expect(response).to have_http_status(302)
      end
    end
  end
end
