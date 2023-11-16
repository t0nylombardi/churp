# frozen_string_literal: true

class MentionsQueryService < ApplicationService
  SEARCH_MODELS = %w(HashTag User Profile).freeze
  LIMIT = 10

  attr_accessor :query

  def initialize(query)
    # super(query)
    @query = query
  end

  def execute!
    mentions ||= multi_search
    if mentions.all?(&:empty?)
      errors.add(:base, 'query is empty')
    else
      mentions
    end
  end

  private

  def multi_search
    return [] if query.blank?

    search_array = []
    SEARCH_MODELS.each do |model|
      search_array << mention_query(model)
    end

    Searchkick.multi_search(search_array)
  end

  def mention_query(model)
    model.safe_constantize.search(query, fields: fields(model),
                                         match:,
                                         limit:)
  end

  def boost_by_recency
    {
      created_at: {
        scale: '7d',
        decay: 0.5
      }
    }
  end

  def match
    :word_middle
  end

  def fields(model)
    case model.downcase.to_sym
    when :user
      %i(username)
    when :profile
      %i(first_name last_name)
    when :hashtag
      %i(name)
    else
      []
    end
  end

  def limit
    LIMIT
  end
end
