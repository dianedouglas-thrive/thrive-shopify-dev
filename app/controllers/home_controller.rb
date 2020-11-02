# frozen_string_literal: true

class HomeController < AuthenticatedController
  def index
    @products = ShopifyAPI::Product.find(:all, params: { limit: 10 })
    @webhooks = ShopifyAPI::Webhook.find(:all)
    @smartpage = Smartpage.new

    asset = ShopifyAPI::Asset.find("layout/theme.liquid")
    html = asset.value
    # if we have not done this already
    # then add the snippet to check if customer is logged in.
    # when we update or uninstall we can search for our unique div class.
    # we can call out to a static script on a cdn from here.
    if html.index('thrive-customer-check').nil?
      head_location = html.index('<head>') + '<head>'.length
      snippet = 
        "<div class='thrive-customer-check'>
          {% if customer %}
            <script>
              console.log('hello I am logged in');
              console.log({{customer.id}});
            </script>
          {% endif %}
        </div>"
      html.insert(head_location, snippet)
      asset.value = html
      asset.save
    end
  end

  def smartpages
  end
end
