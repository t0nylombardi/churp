# frozen_string_literal: true

module ChurpsHelper
  def churp_div(view)
    if view == :churp
      <<-HTML
    <div#{' '}
      data-controller="show_churp"
      data-action="click->show_churp#show"
      data-show_churp-url-value="<%= show_churp_path(current_user, churp) %>"
      class="#{churp_class(view)}">
      HTML
    end

    <<-HTML
    <div class="#{churp_class(view)}">
    HTML
  end

  def churp_class(view, options = {})
    if view == :churp
      "z-0 churp-block border-b border-gray-200 dark:border-dim-200 hover:bg-gray-100 dark:hover:bg-dim-300
      cursor-pointer transition duration-350 ease-in-out pb-4 border-l border-r #{options[:extended_classes]}"
    end

    "z-0 churp-block border-b border-gray-200 dark:border-dim-200 pb-4 border-l border-r #{options[:extended_classes]}"
  end

  def share_icon_class(options = {})
    'flex-1 flex items-center dark:text-white text-xs text-gray-400 hover:text-green-400 ' \
      "dark:hover:text-green-400 transition duration-350 ease-in-out #{options[:extended_classes]}"
  end
end
