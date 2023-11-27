# frozen_string_literal: true

module ChurpsHelper
  def share_icon_class(options = {})
    'flex-1 flex items-center dark:text-white text-xs text-gray-400 hover:text-green-400 ' \
      "dark:hover:text-green-400 transition duration-350 ease-in-out #{options[:extended_classes]}"
  end
end
