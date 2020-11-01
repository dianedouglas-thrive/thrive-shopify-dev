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
            customer {
              id
              displayName
              phone
              tags
              acceptsMarketing
              totalSpent
              lifetimeDuration
              locale
              ordersCount
            }
            customerJourneySummary {
              customerOrderIndex
              momentsCount
              daysToConversion
              firstVisit {
                id
                landingPage
                referrerUrl
                source
              }
              lastVisit {
                id
                landingPage
                referrerUrl
                source
              }
            }
          }
        }
      GRAPHQL

      # get result from client.query() passing in all variables as a hash in key 'variables'
      result = client.query(order_query, variables: { id: graphql_order_id })
      
      # get nested data out of results
      customer_journey = result.data.order.customer_journey_summary
      customer = result.data.order.customer
      moments_count = customer_journey.moments_count.to_i
      orders_count = customer.orders_count.to_i
      first_visit = customer_journey.first_visit
      last_visit = customer_journey.last_visit
      
      # now that we have count of moments/orders can get total list for that order's customer and journey with second query
      order_query = client.parse <<-'GRAPHQL'
        query($id: ID!, $total_orders: Int, $total_moments: Int) {
          order(id: $id) {
            customer {
              orders(first: $total_orders){
                edges {
                  node {
                    id
                    totalPriceSet{
                      presentmentMoney{
                        amount
                      }
                    }
                  }
                }
              }
            }
            customerJourneySummary {
              moments(first: $total_moments) {
                edges {
                  node {
                    occurredAt
                  }
                }
              }
            }
          }
        }
      GRAPHQL

      result = client.query(order_query, variables: { id: graphql_order_id, total_orders: orders_count, total_moments: moments_count })
      # ex: get total price of first order, or any other attribute. could use a loop/map.
      puts result.data.order.customer.orders.edges.first.node.total_price_set.presentment_money.amount
      # ex: access moments array like this.
      puts result.data.order.customer_journey_summary.moments.edges.count
    end
  end
end
