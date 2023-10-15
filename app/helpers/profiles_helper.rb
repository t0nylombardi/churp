module ProfilesHelper
  DEFAULT_BG = 'https://images.unsplash.com/photo-1696506473875-a9398458ab54'

  def profile_background_image(profile_bg)
    return "background-image: url(#{DEFAULT_BG});" unless profile_bg&.attached?

    "background-image: url(#{rails_storage_proxy_url(profile_bg)};"
  end

  def form_profile_bg(profile_bg)
    return DEFAULT_BG unless profile_bg&.attached?

    rails_storage_proxy_url(profile_bg)
  end

  def profile_image(profile_pic)
    return 'stanley-roper-profile.png' unless profile_pic&.attached?

    profile_pic
  end

  def edit_profile_class
    'flex justify-center max-h-max whitespace-nowrap focus:outline-none focus:ring\
    max-w-max border bg-transparent border-blue-500 text-blue-500 hover:border-blue-800\
    items-center hover:shadow-lg font-bold py-2 px-4 rounded-full mr-0 ml-auto'
  end

  def profile_modal_class
    'mx-2 text-2xl font-medium rounded-full text-blue-400 hover:bg-gray-800 hover:text-blue-300 float-right'
  end

  def profile_form_input_class(options = {})
    "block shadow rounded-md border text-gray-800 border-gray-200 outline-none px-3 py-4 mt-2 w-full #{options[:extended_classes]}"
  end

  def profile_form_label_class(options = {})
    "absolute text-gray-400 dark:text-gray-500 duration-300 transform 
    -translate-y-4 scale-75 top-4 z-10 origin-[0] left-2.5\
    peer-focus:text-blue-600 peer-focus:dark:text-blue-500\
    peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0
    peer-focus:scale-75 peer-focus:-translate-y-4 #{options[:extended_classes]}"
  end
  
end
