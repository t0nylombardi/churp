class ApplicationController < ActionController::Base
  include Pagy::Backend

  layout :layout_by_resource

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_hash_tags

  def layout_by_resource
    if devise_controller?
      'devise'
    else
      'application'
    end
  end

  def set_hash_tags
    @popular_hashtags = HashTag.top_three
  end

  def self.render_with_signed_in_user(user, *args)
    ActionController::Renderer::RACK_KEY_TRANSLATION['warden'] ||= 'warden'
    proxy = Warden::Proxy.new({}, Warden::Manager.new({})).tap{ |i| i.set_user(user, scope: :user) }
    renderer = self.renderer.new('warden' => proxy)
    renderer.render(*args)
  end

  def not_found_method
    render file: Rails.public_path.join('404.html'), status: :not_found, layout: false
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |user_params|
      user_params.permit([:email, :username, :password, :password_confirmation, { profile_attributes: :name }])
    end

    # devise_parameter_sanitizer.permit(:sign_up, keys: [
    #   :username, profile_attributes: [ :name ]
    # ])

    # devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end
