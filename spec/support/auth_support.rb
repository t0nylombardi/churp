require "rails_helper"

RSpec.describe "GET /api/v1/churps", type: :request do
  let(:user) { create(:user, password: "Password1234!") }
  let!(:churps) { create_list(:churp, 3, user:) }

  it "returns paginated churps" do
    headers = auth_headers_for(user)

    get "/api/v1/churps", headers: headers

    expect(response).to have_http_status(:ok)

    body = JSON.parse(response.body)
    expect(body["data"].length).to eq(3)
    expect(body["meta"]).to be_present
  end
end
