# frozen_string_literal: true

require "swagger_helper"

# == API V1 /churps contract specs
# These rswag specs double as executable documentation for the public JSON API.
# Each example mirrors the behavior of Api::V1::ChurpsController and exercises
# devise-jwt authentication exactly the way our mobile/web clients do:
# 1. Authenticate via Devise to obtain a JWT.
# 2. Send the `Authorization` header with every privileged request.
#
# The helper methods included from ApiHelper (see spec/support/helpers/auth_helper.rb)
# emulate that handshake by generating a signed JWT for the factory user.
# This keeps the Swagger examples realistic, verifies the Devise stack end-to-end,
# and prevents us from ever documenting unauthenticated happy paths by accident.
RSpec.describe "API V1 Churps", swagger_doc: "v1/swagger.yaml", type: :request do
  let(:current_user) { create(:user) }
  let(:Authorization) { auth_token_for(current_user) }

  # A well-formed churp payload used across POST specs.
  let(:churp_payload) do
    {
      churp: {
        body: "Shipping Churp v1 today!",
        churp_id: nil
      }
    }
  end

  path "/api/v1/churps" do
    # -- GET /api/v1/churps -----------------------------------------------
    # Lists the global feed with Pagy metadata. Requires a valid JWT.
    get "List churps" do
      tags "Churps"
      produces "application/json"
      security [bearerAuth: []]

      parameter name: :page,
        in: :query,
        schema: { type: :integer, minimum: 1 },
        description: "Optional page cursor provided by Pagy."

      response "200", "returns a paginated collection" do
        schema "$ref" => "#/components/schemas/ChurpCollectionResponse"
        let!(:churps) { create_list(:churp, 2, user: current_user) }

        run_test!
      end

      response "401", "JWT missing or invalid" do
        schema "$ref" => "#/components/schemas/UnauthorizedError"
        let(:Authorization) { nil }

        run_test!
      end
    end

    # -- POST /api/v1/churps ----------------------------------------------
    # Creates a new churp owned by the authenticated user.
    post "Create churp" do
      tags "Churps"
      consumes "application/json"
      produces "application/json"
      security [bearerAuth: []]

      parameter name: :payload,
        in: :body,
        schema: { "$ref" => "#/components/schemas/ChurpPayload" }

      response "201", "churp persisted" do
        schema "$ref" => "#/components/schemas/ChurpMutationResponse"
        let(:payload) { churp_payload }

        run_test!
      end

      response "422", "validation errors" do
        schema "$ref" => "#/components/schemas/ErrorResponse"
        let(:payload) { { churp: { body: "" } } }

        run_test!
      end
    end
  end

  path "/api/v1/churps/{id}" do
    parameter name: :id, in: :path, type: :string, description: "Churp ID"

    # -- GET /api/v1/churps/:id ------------------------------------------
    get "Show churp" do
      tags "Churps"
      produces "application/json"
      security [bearerAuth: []]

      response "200", "returns the churp" do
        schema "$ref" => "#/components/schemas/ChurpResponse"
        let(:churp) { create(:churp, user: current_user) }
        let(:id) { churp.id }

        run_test!
      end

      response "404", "unknown churp" do
        schema "$ref" => "#/components/schemas/ErrorResponse"
        let(:id) { 999_999 }

        run_test!
      end
    end

    # -- DELETE /api/v1/churps/:id ---------------------------------------
    delete "Delete churp" do
      tags "Churps"
      produces "application/json"
      security [bearerAuth: []]

      response "200", "deletes the churp" do
        schema "$ref" => "#/components/schemas/StatusOnlyResponse"
        let(:churp) { create(:churp, user: current_user) }
        let(:id) { churp.id }

        run_test!
      end

      response "404", "cannot delete missing churp" do
        schema "$ref" => "#/components/schemas/ErrorResponse"
        let(:id) { 999_999 }

        run_test!
      end
    end
  end

  path "/api/v1/churps/{id}/like" do
    parameter name: :id, in: :path, type: :string, description: "Churp ID"

    # -- POST /api/v1/churps/:id/like ------------------------------------
    post "Like churp" do
      tags "Churps"
      produces "application/json"
      security [bearerAuth: []]

      response "200", "like registered" do
        schema "$ref" => "#/components/schemas/StatusOnlyResponse"
        let(:churp) { create(:churp, user: current_user) }
        let(:id) { churp.id }

        run_test!
      end

      response "404", "unknown churp" do
        schema "$ref" => "#/components/schemas/ErrorResponse"
        let(:id) { 999_999 }

        run_test!
      end
    end
  end

  path "/api/v1/churps/{id}/rechurp" do
    parameter name: :id, in: :path, type: :string, description: "Original churp ID"

    # -- POST /api/v1/churps/:id/rechurp ---------------------------------
    post "Rechurp" do
      tags "Churps"
      produces "application/json"
      security [bearerAuth: []]

      response "201", "rechurp succeeds" do
        schema "$ref" => "#/components/schemas/StatusOnlyResponse"
        let(:churp) { create(:churp, user: current_user) }
        let(:id) { churp.id }

        run_test!
      end

      response "422", "rechurp rejected" do
        schema "$ref" => "#/components/schemas/ErrorResponse"
        let(:churp) { create(:churp, user: current_user) }
        let(:id) { churp.id }

        before do
          error_response = instance_double(
            "Churps::RechurpService",
            success?: false,
            error: "Cannot rechurp this churp."
          )
          allow(Churps::RechurpService).to receive(:call).and_return(error_response)
        end

        run_test!
      end
    end
  end
end
