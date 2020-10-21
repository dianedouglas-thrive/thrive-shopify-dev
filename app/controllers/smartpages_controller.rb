class SmartpagesController < AuthenticatedController
  before_action :set_smartpage, only: [:show, :edit, :update, :destroy]
  before_action :set_shop

  # GET /smartpages
  # GET /smartpages.json
  def index
    @smartpages = Smartpage.all
  end

  # GET /smartpages/1
  # GET /smartpages/1.json
  def show
  end

  # GET /smartpages/new
  def new
    @smartpage = Smartpage.new
  end

  # GET /smartpages/1/edit
  def edit
  end

  # POST /smartpages
  # POST /smartpages.json
  def create
    @smartpage = Smartpage.new(smartpage_params)
    @smartpage.shop_id = @shop.id if @shop

    respond_to do |format|
      if @shop == nil
        format.html { render :new, notice: 'Shop not found. Please log out and log back in again.' }
        format.json { render json: @smartpage.errors, status: :unprocessable_entity }
      elsif @smartpage.save
        # if no page here, then this is a new smartpage. else delete it. 
        page = shopify_find_smartpage(@smartpage.path)
        delete_response = shopify_delete_smartpage(page) if page
        new_shopify_page = shopify_create_smartpage(@smartpage.path)
        if new_shopify_page.save
          format.html { redirect_to @smartpage, notice: 'Smartpage was successfully created.' }
          format.json { render :show, status: :created, location: @smartpage }
        else
          format.html { render :edit, notice: "Error creating new Shopify page. Original page: #{page} Delete response: #{delete_response}" }
          format.json { render json: new_shopify_page.errors, status: :unprocessable_entity }
        end
      else
        format.html { render :new }
        format.json { render json: @smartpage.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /smartpages/1
  # PATCH/PUT /smartpages/1.json
  def update
    respond_to do |format|
      old_handle = @smartpage.path
      if @smartpage.update(smartpage_params)
        # if we are updating our smartpage db record for this shop, 
        # we find the page, delete it if it exists and then recreate. 
        page = shopify_find_smartpage(old_handle)
        delete_response = shopify_delete_smartpage(page) if page
        new_shopify_page = shopify_create_smartpage(@smartpage.path)
        if new_shopify_page.save
          format.html { redirect_to @smartpage, notice: 'Smartpage was successfully updated.' }
          format.json { render :show, status: :ok, location: @smartpage }
        else
          format.html { render :edit, notice: "Error creating new Shopify page. Original page: #{page} Delete response: #{delete_response}" }
          format.json { render json: new_shopify_page.errors, status: :unprocessable_entity }
        end
      else
        format.html { render :edit }
        format.json { render json: @smartpage.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /smartpages/1
  # DELETE /smartpages/1.json
  def destroy
    @smartpage.destroy
    page = shopify_find_smartpage(@smartpage.path)
    delete_response = shopify_delete_smartpage(page) if page
    respond_to do |format|
      if page == nil
        format.html { redirect_to smartpages_url, notice: 'Smartpage was successfully destroyed, but did not exist in merchant store.' }
        format.json { head :no_content }
      elsif delete_response && delete_response.code == '200'
        format.html { redirect_to smartpages_url, notice: 'Smartpage was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to smartpages_url, notice: "Error: Could not destroy. Smartpage: #{@smartpage.errors} Page: #{page} Delete Response: #{delete_response}" }
        format.json { head :no_content }
      end
    end
  end

  private
    def shopify_find_smartpage(path)
      ShopifyAPI::Page.where(handle: path).first
    end


    def shopify_delete_smartpage(page)
      ShopifyAPI::Page.delete(page.id)
    end


    def shopify_create_smartpage(path)
      page = ShopifyAPI::Page.new(handle: path, title: "&nbsp;")
      script = "<script src='//integrate.thrive.today'></script>"
      page.body_html = script
      page.save
      page
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_smartpage
      @smartpage = Smartpage.find(params[:id])
    end

    def set_shop
      @shop = Shop.where(id: session['shop_id']).first
    end

    # Only allow a list of trusted parameters through.
    def smartpage_params
      params.require(:smartpage).permit(:path)
    end
end
