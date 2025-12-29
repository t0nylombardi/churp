# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "API V1 Authentication", swagger_doc: "v1/swagger.yaml" do
  path "/api/v1/users" do
    post "Sign up" do
      tags "Authentication"
      consumes "application/json"
      produces "application/json"

      parameter name: :payload,
        in: :body,
        schema: { "$ref" => "#/components/schemas/UserRegistrationPayload" }

      response "200", "user registered" do
        schema "$ref" => "#/components/schemas/UserResponse"

        let(:payload) do
          {
            user: {
              email: "winston+new@churp.app",
              username: "winston_new",
              password: "Passw0rd1!",
              password_confirmation: "Passw0rd1!",
              profile_attributes: { name: "Winston" }
            }
          }
        end

        run_test!
      end

      response "422", "validation failure" do
        schema "$ref" => "#/components/schemas/ErrorResponse"

        let(:payload) do
          {
            user: {
              email: "invalid-email",
              username: "",
              password: "short",
              password_confirmation: "mismatch"
            }
          }
        end

        run_test!
      end
    end
  end

  path "/api/v1/users/sign_in" do
    post "Sign in" do
      tags "Authentication"
      consumes "application/json"
      produces "application/json"

      parameter name: :payload,
        in: :body,
        schema: { "$ref" => "#/components/schemas/UserSignInPayload" }

      response "200", "credentials accepted" do
        schema "$ref" => "#/components/schemas/UserResponse"

        let!(:user) do
          create(
            :user,
            email: "winston@churp.app",
            password: "Passw0rd1!",
            password_confirmation: "Passw0rd1!"
          )
        end

        let(:payload) do
          {
            user: {
              email: user.email,
              password: "Passw0rd1!"
            }
          }
        end

        run_test!
      end

      response "401", "invalid credentials" do
        schema type: :object, required: ["error"], properties: {
          error: { type: :string, example: "Invalid Email or password." }
        }

        let!(:user) do
          create(
            :user,
            email: "winston@churp.app",
            password: "Passw0rd1!",
            password_confirmation: "Passw0rd1!"
          )
        end

        let(:payload) do
          {
            user: {
              email: user.email,
              password: "wrong-password"
            }
          }
        end

        run_test!
      end
    end
  end
end
