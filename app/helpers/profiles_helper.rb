# frozen_string_literal: true

module ProfilesHelper
  DEFAULT_BG = '/images/rod-long-bg.jpeg'

  def profile_background_image(profile_bg)
    return "background-image: url(#{DEFAULT_BG});" unless profile_bg&.attached?

    "background-image: url('#{profile_bg.url}');"
  end

  def form_profile_bg(profile_bg)
    return DEFAULT_BG unless profile_bg&.attached?

    profile_bg.url
  end

  def avatar_pic(profile)
    profile_pic = profile&.profile_pic
    return url_for_attachment(profile) if profile_pic&.attached?
    return letter_avatar(profile) unless profile_pic&.attached?

    'stanley-roper-profile.png'
  end

  def letter_avatar(profile)
    name = profile.name || 'Sage Doe'
    path = LetterAvatar.generate(name, 400).sub('public/', '')
    "#{churp_root_url}/#{path}"
  end

  def url_for_attachment(profile)
    return Rails.application.routes.url_helpers.url_for profile.profile_pic if Rails.env.test?

    profile.profile_pic.url
  end

  def churp_root_url
    Rails.application
         .default_url_options
         .values
         .first
  end

  def edit_profile_class
    'flex justify-center max-h-max whitespace-nowrap focus:outline-none focus:ring\
    max-w-max border bg-transparent border-vividSkyBlue text-vividSkyBlue hover:border-cyan-600\
    items-center hover:shadow-lg font-bold py-2 px-4 rounded-full mr-0 ml-auto'
  end

  def profile_button_class(error: nil)
    "flex justify-center max-h-max whitespace-nowrap focus:outline-none focus:ring\
    max-w-max border bg-transparent #{error ? error_colors : primary_colors}\
    items-center hover:shadow-lg font-bold py-2 px-4 rounded-full mr-0 ml-auto"
  end

  def primary_colors
    'border-vividSkyBlue text-vividSkyBlue hover:border-vividSkyBlue'
  end

  def error_colors
    'border-red-700 text-red-700 hover:border-red-700'
  end

  def profile_modal_class
    'mx-2 text-2xl font-medium rounded-full text-vividSkyBlue hover:bg-cyan-600 hover:text-blue-300 float-right'
  end

  def profile_form_input_class(options = {})
    "block shadow rounded-md border text-gray-800 border-gray-200 outline-none px-3 py-4 mt-2 w-full
    #{options[:extended_classes]}"
  end

  def profile_form_label_class(options = {})
    "absolute text-gray-400 dark:text-gray-500 duration-300 transform
    -translate-y-4 scale-75 top-4 z-10 origin-[0] left-2.5\
    peer-focus:text-blue-600 peer-focus:dark:text-blue-500\
    peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0
    peer-focus:scale-75 peer-focus:-translate-y-4 #{options[:extended_classes]}"
  end
end
