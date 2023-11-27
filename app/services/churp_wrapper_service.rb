class ChurpWrapperService < ApplicationService
  URL_PATTERN = %r{((https?|ftp|file):\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?}

  attr_reader :content

  def initialize(content)
    @content = content
  end

  def execute!
    link_wrapper
  end

  private

  def link_wrapper
    text = content_to_s(content)

    href_wrapper(hashtag_wrapper(text)).html_safe
  end

  def href_wrapper(text)
    text.strip.gsub(URL_PATTERN, html_wrapper(search: false))
  end

  def hashtag_wrapper(text)
    text.gsub(/#\w+/, html_wrapper(search: true))
  end

  def html_wrapper(search: false)
    search_str = search ? '/search?q=\\0 ' : '\\0 '

    "<a href=#{search_str} class='hover:underline' rel='noopener noreferrer nofollow' target='_blank'>\\0</a>"
  end

  def shorten_url(url)
    URI(url).host
  end

  def content_to_s(content)
    content.body.to_s
  end

end