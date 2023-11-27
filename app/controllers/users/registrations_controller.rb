# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    def account_update_params
      if params[@devise_mapping.name][:password_confirmation].blank?
        params[@devise_mapping.name].delete(:password)
        params[@devise_mapping.name].delete(:password_confirmation)
      end

      super
    end
  end
end
