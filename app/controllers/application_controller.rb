class ApplicationController < ActionController::Base
  after_action :allow_shopify_iframe

  private

  def allow_shopify_iframe
    response.headers['X-Frame-Options'] = 'ALLOWALL'
  end
end
