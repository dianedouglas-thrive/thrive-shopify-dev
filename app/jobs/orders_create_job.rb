class OrdersCreateJob < ActiveJob::Base
  def perform(shop_domain:, webhook:)
    shop = Shop.find_by(shopify_domain: shop_domain)

    if shop.nil?
      logger.error("#{self.class} failed: cannot find shop with domain '#{shop_domain}'")
      return
    end

    shop.with_shopify_session do
      # get order id out of webhook parameter
      graphql_order_id = webhook['admin_graphql_api_id']

      # grab the client. initialized inside engine.
      client = ShopifyAPI::GraphQL.client

      # create query structure. 
      order_query = client.parse <<-'GRAPHQL'
        query($id: ID!) {
          order(id: $id) {
            email
            customerJourneySummary {
              daysToConversion
              firstVisit {
                id
                landingPage
                landingPageHtml
                occurredAt
                referralCode
                referralInfoHtml
                referrerUrl
                source
                sourceDescription
                sourceType
                utmParameters {
                  campaign
                  content
                  medium
                  source
                  term
                }
              }
              lastVisit {
                id
                landingPage
                landingPageHtml
                occurredAt
                referralCode
                referralInfoHtml
                referrerUrl
                source
                sourceDescription
                sourceType
                utmParameters {
                  campaign
                  content
                  medium
                  source
                  term
                }
              }
            }
          }
        }
      GRAPHQL

      # get result from client.query() passing in all variables as a hash in key 'variables'
      result = client.query(order_query, variables: { id: graphql_order_id })
      # customer journey summary is not available immediately.
      total_wait_time = 0
      while result.data.order.customer_journey_summary.days_to_conversion.nil? && total_wait_time <= 60
        sleep(15.seconds)
        result = client.query(order_query, variables: { id: graphql_order_id })
        total_wait_time += 10
        puts "Make query."
      end
    end
  end
end
