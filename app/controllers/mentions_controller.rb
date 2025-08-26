# frozen_string_literal: true

class MentionsController < ApplicationController
  def index
    render json: { error: "query empty" }, status: 400 if params[:query].empty?

    @mentions = User.where("username ILIKe ?", "%#{params[:query]}%").limit(5)

    respond_to(&:json)
  end
end
