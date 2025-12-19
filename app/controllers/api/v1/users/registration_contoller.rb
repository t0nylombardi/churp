module Api
  module V1
    module Users
      class RegistrationController < Api::V1::BaseController
        respond_to? :json
        skip_before_action :authenticate_user!, only: :create
      end
    end
  end
end
