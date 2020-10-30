class OrdersCreateJob < ActiveJob::Base
  def perform(shop_domain:, webhook:)
    shop = Shop.find_by(shopify_domain: shop_domain)

    if shop.nil?
      logger.error("#{self.class} failed: cannot find shop with domain '#{shop_domain}'")
      return
    end

    # authenticate with current shop session using this block on shop model.
    # could be done in a custom controller if you want
    # https://github.com/Shopify/shopify_app#webhooksmanager
    shop.with_shopify_session do

      # get order id out of webhook parameter
      order_id = webhook['id']

      # format it for graphql order id argument
      # takes a string
      graphql_order_id = "gid://shopify/Order/#{order_id}"

      # grab the client. initialized inside engine.
      client = ShopifyAPI::GraphQL.client

      # create query structure. 
      # says expect a variable called $id of type ID! 
      # type ID! is a scalar from the schema but a string works.
      # pass $id into the order query as order(id: $id)
      # request data back from order inside brackets: { email }
      order_query = client.parse <<-'GRAPHQL'
        query($id: ID!) {
          order(id: $id) {
            email
          }
        }
      GRAPHQL

      # get result from client.query() passing in all variables as a hash in key 'variables'
      result = client.query(order_query, variables: { id: graphql_order_id })
      puts result.data.order.email
    end
  end
end
