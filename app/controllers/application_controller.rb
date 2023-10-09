class ApplicationController < ActionController::Base
  include Pagy::Backend

  layout :layout_by_resource

  before_action :configure_permitted_parameters, if: :devise_controller?

  def layout_by_resource
    if devise_controller?
      "devise"
    else
      "application"
    end
  end

  def self.render_with_signed_in_user(user, *args)
    ActionController::Renderer::RACK_KEY_TRANSLATION['warden'] ||= 'warden'
    proxy = Warden::Proxy.new({}, Warden::Manager.new({})).tap{|i| i.set_user(user, scope: :user) }
    renderer = self.renderer.new('warden' => proxy)
    renderer.render(*args)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end
