# frozen_string_literal: true

class SearchController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    if params[:q].start_with?('#')
      query = params[:q].delete('#')
      @churps = Churp.search_hashtags(query)
    else
      @churps = Churp.with_all_rich_text.where('body like ?', "%#{params[:q]}%")
    end
  end

  def search_hashtags
    @results = search_for_hashtags

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream:
          turbo_stream.update('search',
                              partial: 'search/index',
                              locals: { posts: @results })
      end
    end
  end

  def suggestions
    @results = search_for_hashtags

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream:
          turbo_stream.update('suggestions',
                              partial: 'search/suggestions',
                              locals: { results: @results })
      end
    end
  end

  private

  def search_for_hashtags
    if params[:query].blank?
      HashTag.all
    else
      results = HashTag.search(params[:query],
                               fields: [:name],
                               match: :word_start,
                               boost_by_recency: { created_at: { scale: '7d', decay: 0.5 } },
                               limit: 10)
      results.uniq { |r| r[:name] }
    end
  end
end
