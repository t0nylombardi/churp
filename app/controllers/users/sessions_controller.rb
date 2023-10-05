class Users::SessionsController < Devise::SessionsController
  # before_action :verify_authenticity_token, only: :create

  # before_action :set_csrf_headers, only: :create
  # skip_before_action :verify_authenticity_token, only: :create

  protected

  def set_csrf_headers
    return if request.xhr?

    # Add the newly created csrf token to the page headers
    # These values are sent on 1 request only
    response.headers['X-CSRF-Token'] = "#{form_authenticity_token}"
    response.headers['X-CSRF-Param'] = "#{request_forgery_protection_token}"
  end
end
