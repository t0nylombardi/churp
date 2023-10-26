# frozen_string_literal: true

class StaticController < ApplicationController
  layout 'static/tos'

  def terms_of_service
    @updated_at = TermsOfService.updated_at
  end
  
  def privacy_policy
    @updated_at = PrivacyPolicy.updated_at
  end

  def cookie_policy
  end

  def ads_info
  end

  def about
  end

  def status
  end
end
