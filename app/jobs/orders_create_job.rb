class OrdersCreateJob < ActiveJob::Base
  def perform(shop_domain:, webhook:)
    shop = Shop.find_by(shopify_domain: shop_domain)

    if shop.nil?
      logger.error("#{self.class} failed: cannot find shop with domain '#{shop_domain}'")
      return
    end

    shop.with_shopify_session do
    	order_id = webhook['id']

    	client = ShopifyAPI::GraphQL.client

    	shop_name_query = client.parse <<-'GRAPHQL'
    	  {
    	    shop {
    	      name
    	    }
    	  }
    	GRAPHQL

    	result = client.query(shop_name_query)
    	byebug

    end
  end
end
