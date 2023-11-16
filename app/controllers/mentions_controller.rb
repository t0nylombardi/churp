# frozen_string_literal: true

class MentionsController < ApplicationController
  def index
    # service ||= MentionsQueryService.call(params[:query])
    # @mentions = parse_mentions(service.result) if service.success?
    @mentions = User.where('username ILIKe ?', "%#{params[:query]}%").limit(10)

    respond_to do |format|
      format.json
    end
  end

  private

  def parse_mentions(mentions)
    return [] if mentions.nil?

    collections = []
    mentions.each do |mention|
      case mention.klass.to_s
      when 'User'
        collections << mention.uniq(&:username) unless mention.empty?
      when 'Profile' || 'HashTag'
        collections << mention.uniq(&:name) unless mention.empty?
      else
        []
      end
    end

    collections
  end
end
