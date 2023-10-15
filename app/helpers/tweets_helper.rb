module TweetsHelper

  def tweet_div(view)
    if view == :tweet
    <<-HTML
    <div 
      data-controller="show_tweet"
      data-action="click->show_tweet#show"
      data-show_tweet-url-value="<%= show_tweet_path(current_user, tweet) %>"
      class="#{tweet_class(view)}">
    HTML
    end

    <<-HTML
    <div class="#{tweet_class(view)}">
    HTML
  end

  def tweet_class(view, options = {})
    if view == :tweet
      "z-0 tweet-block border-b border-gray-200 dark:border-dim-200 hover:bg-gray-100 dark:hover:bg-dim-300\ 
      cursor-pointer transition duration-350 ease-in-out pb-4 border-l border-r #{options[:extended_classes]}"
    end

    "z-0 tweet-block border-b border-gray-200 dark:border-dim-200 pb-4 border-l border-r #{options[:extended_classes]}"
  end

  def share_icon_class(options = {})
    "flex-1 flex items-center dark:text-white text-xs text-gray-400 hover:text-green-400"\
    " dark:hover:text-green-400 transition duration-350 ease-in-out #{options[:extended_classes]}"
  end

end
