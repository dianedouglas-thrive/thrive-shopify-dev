ShopifyApp.configure do |config|
  config.application_name = "My Shopify App"
  config.api_key = ENV['SHOPIFY_API_KEY']
  config.secret = ENV['SHOPIFY_API_SECRET']
  config.old_secret = ""
  config.scope = "read_products, read_script_tags, write_script_tags, read_content, write_content, read_customers, read_orders, write_orders, read_themes, write_themes"
  config.embedded_app = true
  config.after_authenticate_job = false
  config.api_version = "2020-10"
  config.shop_session_repository = 'Shop'
  # config.scripttags = [
  #   {event:'onload', src: 'https://integrate.thrive.today'}
  # ]
  # config.webhook_jobs_namespace = 'shopify/webhooks'
  config.webhooks = [
    {topic: 'orders/create', address: 'https://e35c94f0c8d4.ngrok.io/webhooks/orders_create', format: 'json'},
  ]
end

# ShopifyApp::Utils.fetch_known_api_versions                        # Uncomment to fetch known api versions from shopify servers on boot
# ShopifyAPI::ApiVersion.version_lookup_mode = :raise_on_unknown    # Uncomment to raise an error if attempting to use an api version that was not previously known
