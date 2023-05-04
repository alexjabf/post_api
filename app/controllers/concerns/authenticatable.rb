# frozen_string_literal: true

module Authenticatable
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  extend ActiveSupport::Concern

  included do
    before_action :authenticate!, except: %i[index show]
  end

  def authenticate!
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV.fetch('API_USERNAME', nil) && password == ENV.fetch('API_PASSWORD', nil)
    end
  end
end
