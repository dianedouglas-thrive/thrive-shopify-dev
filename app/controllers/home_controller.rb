# frozen_string_literal: true

class HomeController < AuthenticatedController
  def index
    @products = ShopifyAPI::Product.find(:all, params: { limit: 10 })
    @webhooks = ShopifyAPI::Webhook.find(:all)
    @smartpage = Smartpage.new
  end

  def smartpages
  	# @pages = ShopifyAPI::Page.find(:all)
  	# @page  = ShopifyAPI::Page.find(52520190030)
  end
end
