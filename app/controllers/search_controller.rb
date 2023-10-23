# frozen_string_literal: true

class SearchController < ApplicationController
  def index
    if params[:query].start_with?('#')
      query  = params[:query].gsub('#', '')
      @churps = Churp.search_hashags(query)
    else
      @churps = Churp.where("body like ?", "%#{query}%")
    end
  end
end