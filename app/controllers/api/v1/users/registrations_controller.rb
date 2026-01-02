# frozen_string_literal: true

module Api
  module V1
    module Users
      class RegistrationsController < Devise::RegistrationsController
        include Devise::Controllers::Helpers
        respond_to :json
        skip_before_action :verify_authenticity_token

        def create
          build_resource(sign_up_params)

          if resource.save
            sign_up(resource_name, resource)
            respond_with(resource)
          else
            render_signup_failure(resource)
          end
        end

        protected

        def sign_up_params
          params
            .fetch(:user, params)
            .permit(
              :email,
              :username,
              :password,
              :password_confirmation,
              profile_attributes: [:name]
            )
        end

        private

        def respond_with(resource, _opts = {})
          return render_signup_success(resource) if signup_success?(resource)
          return render_account_deleted if account_deleted?
          render_signup_failure(resource)
        end

        def signup_success?(resource)
          post_request? && resource.persisted?
        end

        def account_deleted?
          delete_request?
        end

        def post_request?
          request.post?
        end

        def delete_request?
          request.delete?
        end

        def render_signup_success(resource)
          render json: {
            status: { code: 200, message: "Signed up successfully." },
            data: serialized_user(resource)
          }, status: :ok
        end

        def render_account_deleted
          render json: {
            status: { code: 200, message: "Account deleted successfully." }
          }, status: :ok
        end

        def render_signup_failure(resource)
          render json: {
            status: {
              code: 422,
              message: signup_error_message(resource)
            }
          }, status: :unprocessable_entity
        end

        def serialized_user(resource)
          UserSerializer
            .new(resource)
            .serializable_hash
            .dig(:data, :attributes)
        end

        def signup_error_message(resource)
          Rails.logger.debug { "Signup errors: #{resource.errors.full_messages}" }
          "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}"
        end
      end
    end
  end
end
