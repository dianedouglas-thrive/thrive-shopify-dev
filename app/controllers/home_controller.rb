# frozen_string_literal: true

class HomeController < AuthenticatedController
  def index
    find_thrive_data_snippet
    create_thrive_data_snippet
    include_thrive_data_snippet
  end

  def find_thrive_data_snippet
    # find previous version of our snippet and destroy it.
    # if not found create new, catch error to create new.
    begin
      @thrive_liquid = ShopifyAPI::Asset.find("snippets/thrive.liquid")
      @thrive_liquid.destroy
    rescue ActiveResource::ResourceNotFound => e
      Rails.logger.info("Could not find Trhive snippet. Creating new.")
    rescue Exception => e
      Rails.logger.info("Could not complete search for Thrive snippet. #{e.message}")
    end
  end

  def create_thrive_data_snippet
    @thrive_liquid = ShopifyAPI::Asset.new
    rendered_snippet = render_to_string("shopify_snippets/thrive.liquid", layout: false)
    @thrive_liquid.value = rendered_snippet
    @thrive_liquid.key = "snippets/thrive.liquid"
    @thrive_liquid.save
  end

  def include_thrive_data_snippet
    # get main theme liquid file and its html
    theme_liquid = ShopifyAPI::Asset.find("layout/theme.liquid")
    theme_liquid_html = theme_liquid.value
    # find head tag in html
    # append with render statement for our snippet if it is not already there. 
    # content of snippit can change because it is loaded into templates dynamically
    # and we replace the content of the snippet file with snippets/thrive.liquid on visit to our app's root in shopify admin.
    render_snippet_html = "{% render 'thrive' %}"
    if theme_liquid_html.index(render_snippet_html).nil?
      head_location = theme_liquid_html.index('<head>') + '<head>'.length
      theme_liquid_html.insert(head_location, render_snippet_html)
      theme_liquid.value = theme_liquid_html
      theme_liquid.save
    end
  end
end
